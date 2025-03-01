// Copyright 2021 The XLS Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "xls/codegen/signature_generator.h"

#include "absl/strings/str_format.h"
#include "xls/common/status/status_macros.h"
#include "xls/ir/block.h"
#include "xls/ir/function.h"
#include "xls/ir/node_util.h"
#include "xls/ir/proc.h"

namespace xls::verilog {

absl::StatusOr<ModuleSignature> GenerateSignature(
    const CodegenOptions& options, FunctionBase* func_base,
    absl::optional<PipelineSchedule> schedule) {
  std::string module_name = options.module_name().has_value()
                                ? std::string{options.module_name().value()}
                                : func_base->name();
  ModuleSignatureBuilder b(module_name);

  // Optionally add clock and reset.
  if (options.clock_name().has_value()) {
    b.WithClock(options.clock_name().value());
  }
  if (options.reset().has_value()) {
    b.WithReset(options.reset()->name(), options.reset()->asynchronous(),
                options.reset()->active_low());
  }

  if (Function* func = dynamic_cast<Function*>(func_base)) {
    // Function given, use function params and output type to generate
    // type signature.
    for (Param* param : func->params()) {
      b.AddDataInput(param->name(), param->GetType()->GetFlatBitCount());
    }
    b.AddDataOutput("out", func->return_value()->GetType()->GetFlatBitCount());
    b.WithFunctionType(func->GetType());
  } else {
    XLS_RET_CHECK(func_base->IsBlock());
    Block* block = down_cast<Block*>(func_base);
    std::vector<Type*> input_types;
    std::vector<Type*> output_types;

    // Returns true if the given node is a data port (reset and valid in/out are
    // not considered data ports).
    auto is_data_port = [&](Node* node) {
      if (options.reset().has_value() &&
          node->GetName() == options.reset()->name()) {
        return false;
      }
      if (options.valid_control().has_value() &&
          (node->GetName() == options.valid_control()->input_name() ||
           node->GetName() == options.valid_control()->output_name())) {
        return false;
      }
      return true;
    };

    for (const Block::Port& port : block->GetPorts()) {
      if (absl::holds_alternative<InputPort*>(port)) {
        InputPort* input_port = absl::get<InputPort*>(port);
        if (!is_data_port(input_port)) {
          continue;
        }
        input_types.push_back(input_port->GetType());
        b.AddDataInput(input_port->GetName(),
                       input_port->GetType()->GetFlatBitCount());
      } else if (absl::holds_alternative<OutputPort*>(port)) {
        OutputPort* output_port = absl::get<OutputPort*>(port);
        if (!is_data_port(output_port)) {
          continue;
        }
        Type* type = output_port->operand(0)->GetType();
        output_types.push_back(type);
        b.AddDataOutput(output_port->GetName(), type->GetFlatBitCount());
      } else {
        // No need to do anything for the clock port.
        XLS_RET_CHECK(absl::holds_alternative<Block::ClockPort*>(port));
      }
    }
    if (output_types.size() == 1) {
      b.WithFunctionType(
          block->package()->GetFunctionType(input_types, output_types.front()));
    }
  }

  int64_t register_levels = 0;
  if (options.flop_inputs()) {
    register_levels += options.GetInputLatency();
  }
  if (options.flop_outputs()) {
    register_levels += options.GetOutputLatency();
  }
  if (schedule.has_value()) {
    register_levels += schedule.value().length() - 1;
  }
  if (register_levels == 0 && !options.emit_as_pipeline()) {
    // Block has no registers. The block is combinational.
    b.WithCombinationalInterface();
  } else {
    absl::optional<PipelineControl> pipeline_control;
    if (options.valid_control().has_value()) {
      pipeline_control = PipelineControl();
      *(pipeline_control->mutable_valid()) = options.valid_control().value();
    }
    // We assume initiation-interval of one because that is all we generate at
    // the moment.
    b.WithPipelineInterface(register_levels, /*initiation_interval=*/1,
                            pipeline_control);
  }

  return b.Build();
}

}  // namespace xls::verilog
