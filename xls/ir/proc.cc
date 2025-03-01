// Copyright 2020 The XLS Authors
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

#include "xls/ir/proc.h"

#include "absl/strings/str_cat.h"
#include "absl/strings/str_format.h"
#include "xls/ir/channel.h"
#include "xls/ir/function.h"
#include "xls/ir/node.h"
#include "xls/ir/node_iterator.h"
#include "xls/ir/value_helpers.h"

namespace xls {

std::string Proc::DumpIr() const {
  std::string res = absl::StrFormat(
      "proc %s(%s: %s, %s: %s, init=%s) {\n", name(), TokenParam()->GetName(),
      TokenParam()->GetType()->ToString(), StateParam()->GetName(),
      StateParam()->GetType()->ToString(), InitValue().ToHumanString());

  for (Node* node : TopoSort(const_cast<Proc*>(this))) {
    if (node->op() == Op::kParam) {
      continue;
    }
    absl::StrAppend(&res, "  ", node->ToString(), "\n");
  }
  absl::StrAppend(&res, "  next (", NextToken()->GetName(), ", ",
                  NextState()->GetName(), ")\n");

  absl::StrAppend(&res, "}\n");
  return res;
}

absl::Status Proc::SetNextToken(Node* next) {
  if (!next->GetType()->IsToken()) {
    return absl::InvalidArgumentError(absl::StrFormat(
        "Cannot set next token to \"%s\", expected token type but has type %s",
        next->GetName(), next->GetType()->ToString()));
  }
  next_token_ = next;
  return absl::OkStatus();
}

absl::Status Proc::SetNextState(Node* next) {
  if (next->GetType() != StateType()) {
    return absl::InvalidArgumentError(absl::StrFormat(
        "Cannot set next state to \"%s\"; type %s does not match "
        "proc state type %s",
        next->GetName(), next->GetType()->ToString(), StateType()->ToString()));
  }
  next_state_ = next;
  return absl::OkStatus();
}

absl::Status Proc::ReplaceState(absl::string_view state_param_name,
                                Node* next_state, const Value& init_value) {
  Param* old_state_param = StateParam();
  if (!old_state_param->users().empty()) {
    return absl::InvalidArgumentError(
        absl::StrFormat("Existing state param \"%s\" still has uses",
                        old_state_param->GetName()));
  }
  if (!ValueConformsToType(init_value, next_state->GetType())) {
    return absl::InvalidArgumentError(absl::StrFormat(
        "New initial value %s does not match type %s of next state %s",
        init_value.ToString(), next_state->GetType()->ToString(),
        next_state->GetName()));
  }

  // Add a new state param node.
  XLS_ASSIGN_OR_RETURN(
      state_param_,
      MakeNodeWithName<Param>(/*loc=*/absl::nullopt, state_param_name,
                              next_state->GetType()));
  next_state_ = next_state;
  init_value_ = init_value;

  XLS_RET_CHECK(!HasImplicitUse(old_state_param));
  XLS_RETURN_IF_ERROR(RemoveNode(old_state_param));
  return absl::OkStatus();
}

absl::StatusOr<Proc*> Proc::Clone(
    absl::string_view new_name, Package* target_package,
    absl::flat_hash_map<int64_t, int64_t> channel_remapping) const {
  absl::flat_hash_map<Node*, Node*> original_to_clone;
  if (target_package == nullptr) {
    target_package = package();
  }
  Proc* cloned_proc = target_package->AddProc(
      std::make_unique<Proc>(new_name, InitValue(), TokenParam()->name(),
                             StateParam()->name(), target_package));
  for (Node* node : TopoSort(const_cast<Proc*>(this))) {
    std::vector<Node*> cloned_operands;
    for (Node* operand : node->operands()) {
      cloned_operands.push_back(original_to_clone.at(operand));
    }

    if (node == StateParam()) {
      original_to_clone[node] = cloned_proc->StateParam();
    } else if (node == TokenParam()) {
      original_to_clone[node] = cloned_proc->TokenParam();
    } else if (node->Is<Receive>()) {
      Receive* src = node->As<Receive>();
      int64_t channel_id = channel_remapping.contains(src->channel_id())
                               ? channel_remapping.at(src->channel_id())
                               : src->channel_id();
      XLS_ASSIGN_OR_RETURN(original_to_clone[node],
                           cloned_proc->MakeNodeWithName<Receive>(
                               src->loc(), cloned_operands[0],
                               cloned_operands.size() == 2
                                   ? absl::optional<Node*>(cloned_operands[1])
                                   : absl::nullopt,
                               channel_id, src->GetName()));
    } else if (node->Is<Send>()) {
      Send* src = node->As<Send>();
      int64_t channel_id = channel_remapping.contains(src->channel_id())
                               ? channel_remapping.at(src->channel_id())
                               : src->channel_id();
      XLS_ASSIGN_OR_RETURN(
          original_to_clone[node],
          cloned_proc->MakeNodeWithName<Send>(
              src->loc(), cloned_operands[0], cloned_operands[1],
              cloned_operands.size() == 3
                  ? absl::optional<Node*>(cloned_operands[2])
                  : absl::nullopt,
              channel_id, src->GetName()));
    } else {
      XLS_ASSIGN_OR_RETURN(
          original_to_clone[node],
          node->CloneInNewFunction(cloned_operands, cloned_proc));
    }
  }
  XLS_RETURN_IF_ERROR(
      cloned_proc->SetNextToken(original_to_clone.at(NextToken())));
  XLS_RETURN_IF_ERROR(
      cloned_proc->SetNextState(original_to_clone.at(NextState())));
  return cloned_proc;
}

}  // namespace xls
