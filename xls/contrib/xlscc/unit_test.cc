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

#include "xls/contrib/xlscc/unit_test.h"

#include "gmock/gmock.h"
#include "gtest/gtest.h"
#include "absl/container/flat_hash_map.h"
#include "absl/status/status.h"
#include "absl/strings/str_format.h"
#include "clang/include/clang/AST/Decl.h"
#include "xls/common/status/matchers.h"
#include "xls/common/status/status_macros.h"
#include "xls/contrib/xlscc/translator.h"
#include "xls/interpreter/proc_network_interpreter.h"

using xls::status_testing::IsOkAndHolds;

const int determinism_test_repeat_count = 3;

void XlsccTestBase::Run(const absl::flat_hash_map<std::string, uint64_t>& args,
                        uint64_t expected, absl::string_view cpp_source,
                        xabsl::SourceLocation loc,
                        std::vector<absl::string_view> clang_argv) {
  testing::ScopedTrace trace(loc.file_name(), loc.line(), "Run failed");
  XLS_ASSERT_OK_AND_ASSIGN(std::string ir,
                           SourceToIr(cpp_source, nullptr, clang_argv));
  RunAndExpectEq(args, expected, ir, false, false, loc);
}

void XlsccTestBase::Run(
    const absl::flat_hash_map<std::string, xls::Value>& args,
    xls::Value expected, absl::string_view cpp_source,
    xabsl::SourceLocation loc, std::vector<absl::string_view> clang_argv) {
  testing::ScopedTrace trace(loc.file_name(), loc.line(), "Run failed");
  XLS_ASSERT_OK_AND_ASSIGN(std::string ir,
                           SourceToIr(cpp_source, nullptr, clang_argv));
  RunAndExpectEq(args, expected, ir, false, false, loc);
}

void XlsccTestBase::RunWithStatics(
    const absl::flat_hash_map<std::string, xls::Value>& args,
    const absl::Span<xls::Value>& expected_outputs,
    absl::string_view cpp_source, xabsl::SourceLocation loc) {
  testing::ScopedTrace trace(loc.file_name(), loc.line(),
                             "RunWithStatics failed");

  xlscc::GeneratedFunction* pfunc = nullptr;

  XLS_ASSERT_OK_AND_ASSIGN(std::string ir, SourceToIr(cpp_source, &pfunc));

  ASSERT_NE(pfunc, nullptr);

  ASSERT_GT(pfunc->static_values.size(), 0);

  ASSERT_EQ(pfunc->io_ops.size(), 0);

  XLS_ASSERT_OK_AND_ASSIGN(package_, ParsePackage(ir));

  XLS_ASSERT_OK_AND_ASSIGN(xls::Function * top_func,
                           package_->GetTopAsFunction());

  const absl::Span<xls::Param* const> params = top_func->params();

  ASSERT_GE(params.size(), pfunc->static_values.size());

  absl::flat_hash_map<const clang::NamedDecl*, std::string> static_param_names;
  absl::flat_hash_map<const clang::NamedDecl*, xls::Value> static_state;
  for (const xlscc::SideEffectingParameter& param :
       pfunc->side_effecting_parameters) {
    XLS_CHECK(param.type == xlscc::SideEffectingParameterType::kStatic);
    const xls::Value& init_value =
        pfunc->static_values.at(param.static_value).value();
    static_param_names[param.static_value] = param.param_name;
    XLS_CHECK(!static_state.contains(param.static_value));
    static_state[param.static_value] = init_value;
  }

  for (const xls::Value& expected_output : expected_outputs) {
    absl::flat_hash_map<std::string, xls::Value> args_with_statics = args;

    for (const clang::NamedDecl* decl :
         pfunc->GetDeterministicallyOrderedStaticValues()) {
      args_with_statics[static_param_names.at(decl)] = static_state.at(decl);
    }

    XLS_ASSERT_OK_AND_ASSIGN(xls::Value actual,
                             DropInterpreterEvents(xls::InterpretFunctionKwargs(
                                 top_func, args_with_statics)));
    XLS_ASSERT_OK_AND_ASSIGN(std::vector<xls::Value> returns,
                             actual.GetElements());
    ASSERT_EQ(returns.size(), pfunc->static_values.size() + 1);

    {
      int i = 0;
      for (const clang::NamedDecl* decl :
           pfunc->GetDeterministicallyOrderedStaticValues()) {
        XLS_CHECK(static_state.contains(decl));
        static_state[decl] = returns[i++];
      }
    }

    EXPECT_EQ(returns[pfunc->static_values.size()], expected_output);
  }
}

absl::Status XlsccTestBase::ScanFile(absl::string_view cpp_src,
                                     std::vector<absl::string_view> clang_argv,
                                     bool io_test_mode) {
  auto parser = std::make_unique<xlscc::CCParser>();
  XLS_RETURN_IF_ERROR(
      ScanTempFileWithContent(cpp_src, clang_argv, parser.get()));
  translator_.reset(new xlscc::Translator(1000, std::move(parser)));
  if (io_test_mode) {
    translator_->SetIOTestMode();
  }
  return absl::OkStatus();
}

/* static */ absl::Status XlsccTestBase::ScanTempFileWithContent(
    absl::string_view cpp_src, std::vector<absl::string_view> argv,
    xlscc::CCParser* translator) {
  XLS_ASSIGN_OR_RETURN(xls::TempFile temp,
                       xls::TempFile::CreateWithContent(cpp_src, ".cc"));

  std::string ps = temp.path();

  absl::Status ret;
  argv.push_back("-Werror");
  argv.push_back("-Wall");
  argv.push_back("-Wno-unknown-pragmas");
  XLS_RETURN_IF_ERROR(translator->SelectTop("my_package"));
  XLS_RETURN_IF_ERROR(translator->ScanFile(
      temp.path().c_str(), argv.empty()
                               ? absl::Span<absl::string_view>()
                               : absl::MakeSpan(&argv[0], argv.size())));
  return absl::OkStatus();
}

absl::StatusOr<std::string> XlsccTestBase::SourceToIr(
    absl::string_view cpp_src, xlscc::GeneratedFunction** pfunc,
    std::vector<absl::string_view> clang_argv, bool io_test_mode) {
  std::list<std::string> ir_texts;
  std::string ret_text;

  for (size_t test_i = 0; test_i < determinism_test_repeat_count; ++test_i) {
    XLS_RETURN_IF_ERROR(
        ScanFile(cpp_src, clang_argv, /* io_test_mode= */ io_test_mode));
    package_.reset(new xls::Package("my_package"));
    XLS_ASSIGN_OR_RETURN(xlscc::GeneratedFunction * func,
                         translator_->GenerateIR_Top_Function(package_.get()));
    XLS_RETURN_IF_ERROR(package_->SetTopByName(func->xls_func->name()));
    if (pfunc) {
      *pfunc = func;
    }
    ret_text = package_->DumpIr();
    ir_texts.push_back(ret_text);
  }

  // Determinism test
  for (const std::string& text : ir_texts) {
    EXPECT_EQ(text, ret_text) << "Failed determinism test";
  }
  return ret_text;
}

void XlsccTestBase::IOTest(std::string content, std::list<IOOpTest> inputs,
                           std::list<IOOpTest> outputs,
                           absl::flat_hash_map<std::string, xls::Value> args) {
  xlscc::GeneratedFunction* func;
  XLS_ASSERT_OK_AND_ASSIGN(std::string ir_src,
                           SourceToIr(content, &func, /* clang_argv= */ {},
                                      /* io_test_mode= */ true));

  XLS_ASSERT_OK_AND_ASSIGN(package_, ParsePackage(ir_src));
  XLS_ASSERT_OK_AND_ASSIGN(xls::Function * entry, package_->GetTopAsFunction());

  const int total_test_ops = inputs.size() + outputs.size();
  ASSERT_EQ(func->io_ops.size(), total_test_ops);

  std::list<IOOpTest> input_ops_orig = inputs;
  for (const xlscc::IOOp& op : func->io_ops) {
    const std::string ch_name = op.channel->unique_name;

    if (op.op == xlscc::OpType::kRecv) {
      const std::string arg_name =
          absl::StrFormat("%s_op%i", ch_name, op.channel_op_index);

      const IOOpTest test_op = inputs.front();
      inputs.pop_front();

      XLS_CHECK_EQ(ch_name, test_op.name);

      const xls::Value& new_val = test_op.value;

      if (!args.contains(arg_name)) {
        args[arg_name] = new_val;
        continue;
      }

      if (args[arg_name].IsBits()) {
        args[arg_name] = xls::Value::Tuple({args[arg_name], new_val});
      } else {
        XLS_CHECK(args[arg_name].IsTuple());
        const xls::Value prev_val = args[arg_name];
        XLS_ASSERT_OK_AND_ASSIGN(std::vector<xls::Value> values,
                                 prev_val.GetElements());
        values.push_back(new_val);
        args[arg_name] = xls::Value::Tuple(values);
      }
    }
  }

  XLS_ASSERT_OK_AND_ASSIGN(
      xls::Value actual,
      DropInterpreterEvents(xls::InterpretFunctionKwargs(entry, args)));

  std::vector<xls::Value> returns;

  if (total_test_ops > 1) {
    ASSERT_TRUE(actual.IsTuple());
    XLS_ASSERT_OK_AND_ASSIGN(returns, actual.GetElements());
  } else {
    returns.push_back(actual);
  }

  ASSERT_EQ(returns.size(), total_test_ops);

  inputs = input_ops_orig;

  int op_idx = 0;
  for (const xlscc::IOOp& op : func->io_ops) {
    const std::string ch_name = op.channel->unique_name;

    if (op.op == xlscc::OpType::kRecv) {
      const IOOpTest test_op = inputs.front();
      inputs.pop_front();

      XLS_CHECK(ch_name == test_op.name);

      ASSERT_TRUE(returns[op_idx].IsBits());
      XLS_ASSERT_OK_AND_ASSIGN(uint64_t val, returns[op_idx].bits().ToUint64());
      ASSERT_EQ(val, test_op.condition ? 1 : 0);

    } else if (op.op == xlscc::OpType::kSend) {
      const IOOpTest test_op = outputs.front();
      outputs.pop_front();

      XLS_CHECK(ch_name == test_op.name);

      ASSERT_TRUE(returns[op_idx].IsTuple());
      XLS_ASSERT_OK_AND_ASSIGN(std::vector<xls::Value> elements,
                               returns[op_idx].GetElements());
      ASSERT_EQ(elements.size(), 2);
      ASSERT_TRUE(elements[1].IsBits());
      XLS_ASSERT_OK_AND_ASSIGN(uint64_t val1, elements[1].bits().ToUint64());
      ASSERT_EQ(val1, test_op.condition ? 1 : 0);
      // Don't check data if it wasn't sent
      if (val1) {
        ASSERT_EQ(elements[0], test_op.value);
      }
    } else {
      FAIL() << "IOOp was neither send nor recv: " << static_cast<int>(op.op);
    }
    ++op_idx;
  }

  ASSERT_EQ(inputs.size(), 0);
  ASSERT_EQ(outputs.size(), 0);
}

void XlsccTestBase::ProcTest(
    std::string content, const xlscc::HLSBlock& block_spec,
    const absl::flat_hash_map<std::string, std::list<xls::Value>>&
        inputs_by_channel,
    const absl::flat_hash_map<std::string, std::list<xls::Value>>&
        outputs_by_channel,
    const int min_ticks, const int max_ticks) {
  std::list<std::string> ir_texts;
  std::string package_text;

  for (size_t test_i = 0; test_i < determinism_test_repeat_count; ++test_i) {
    XLS_ASSERT_OK(ScanFile(content));
    package_.reset(new xls::Package("my_package"));
    XLS_ASSERT_OK(
        translator_->GenerateIR_Block(package_.get(), block_spec).status());
    package_text = package_->DumpIr();
    ir_texts.push_back(package_text);
  }

  // Determinism test
  for (const std::string& text : ir_texts) {
    EXPECT_EQ(package_text, text) << "Failed determinism test";
  }

  XLS_LOG(INFO) << "Package IR: ";
  XLS_LOG(INFO) << package_text;

  std::vector<std::unique_ptr<xls::ChannelQueue>> queues;

  XLS_ASSERT_OK_AND_ASSIGN(
      auto interpreter,
      xls::ProcNetworkInterpreter::Create(package_.get(), {}));

  xls::ChannelQueueManager& queue_manager = interpreter->queue_manager();

  // Enqueue all inputs.
  for (auto [ch_name, values] : inputs_by_channel) {
    XLS_ASSERT_OK_AND_ASSIGN(xls::ChannelQueue * queue,
                             queue_manager.GetQueueByName(ch_name));

    for (const xls::Value& value : values) {
      XLS_ASSERT_OK(queue->Enqueue(value));
    }
  }

  absl::flat_hash_map<std::string, std::list<xls::Value>>
      mutable_outputs_by_channel = outputs_by_channel;

  int tick = 1;
  for (; tick < max_ticks; ++tick) {
    XLS_ASSERT_OK(interpreter->Tick());

    XLS_LOG(INFO) << "State after tick " << tick;
    for (const auto& [proc, value_or] : interpreter->ResolveState()) {
      XLS_CHECK(value_or.ok() ||
                value_or.status().code() == absl::StatusCode::kNotFound);
      XLS_LOG(INFO) << absl::StrFormat(
          "[%s]: %s", proc->name(),
          (value_or.ok() ? value_or.value().ToString() : "(none)"));
    }

    // Check as we go
    bool all_output_channels_empty = true;
    for (auto& [ch_name, values] : mutable_outputs_by_channel) {
      XLS_ASSERT_OK_AND_ASSIGN(xls::Channel * ch_out,
                               package_->GetChannel(ch_name));
      xls::ChannelQueue& ch_out_queue = queue_manager.GetQueue(ch_out);

      while (!ch_out_queue.empty()) {
        const xls::Value& next_output = values.front();
        EXPECT_THAT(ch_out_queue.Dequeue(), IsOkAndHolds(next_output));
        values.pop_front();
      }

      all_output_channels_empty = all_output_channels_empty && values.empty();
    }
    if (all_output_channels_empty) {
      break;
    }
  }

  for (auto [ch_name, values] : outputs_by_channel) {
    XLS_ASSERT_OK_AND_ASSIGN(xls::Channel * ch_out,
                             package_->GetChannel(ch_name));
    xls::ChannelQueue& ch_out_queue = queue_manager.GetQueue(ch_out);

    EXPECT_EQ(ch_out_queue.size(), 0);
  }

  EXPECT_GE(tick, min_ticks);
  EXPECT_LT(tick, max_ticks);
}

absl::StatusOr<uint64_t> XlsccTestBase::GetStateBitsForProcNameContains(
    std::string_view name_cont) {
  XLS_CHECK_NE(nullptr, package_.get());
  uint64_t ret = 0;
  bool already_found = false;
  for (std::unique_ptr<xls::Proc>& proc : package_->procs()) {
    if (absl::StrContains(proc->name(), name_cont)) {
      if (already_found) {
        return absl::NotFoundError(absl::StrFormat(
            "Proc with name containing %s already found", name_cont));
      }
      ret = proc->StateType()->GetFlatBitCount();
      already_found = true;
    }
  }
  return ret;
}
