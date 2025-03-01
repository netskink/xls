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
#include "xls/dslx/interp_value_helpers.h"

#include <vector>

#include "xls/ir/bits_ops.h"

namespace xls::dslx {

absl::StatusOr<InterpValue> CastBitsToArray(const InterpValue& bits_value,
                                            const ArrayType& array_type) {
  XLS_ASSIGN_OR_RETURN(ConcreteTypeDim element_bit_count,
                       array_type.element_type().GetTotalBitCount());
  XLS_ASSIGN_OR_RETURN(int64_t bits_per_element,
                       element_bit_count.GetAsInt64());
  XLS_ASSIGN_OR_RETURN(Bits bits, bits_value.GetBits());

  auto bit_slice_value_at_index = [&](int64_t i) -> InterpValue {
    int64_t lo = i * bits_per_element;
    Bits rev = bits_ops::Reverse(bits);
    Bits slice = rev.Slice(lo, bits_per_element);
    Bits result = bits_ops::Reverse(slice);
    return InterpValue::MakeBits(InterpValueTag::kUBits, result).value();
  };

  std::vector<InterpValue> values;
  XLS_ASSIGN_OR_RETURN(int64_t array_size, array_type.size().GetAsInt64());
  for (int64_t i = 0; i < array_size; ++i) {
    values.push_back(bit_slice_value_at_index(i));
  }

  return InterpValue::MakeArray(values);
}

absl::StatusOr<InterpValue> CastBitsToEnum(const InterpValue& bits_value,
                                           const EnumType& enum_type) {
  const EnumDef& enum_def = enum_type.nominal_type();
  bool found = false;
  for (const InterpValue& member_value : enum_type.members()) {
    if (bits_value.GetBitsOrDie() == member_value.GetBitsOrDie()) {
      found = true;
      break;
    }
  }

  if (!found) {
    return absl::InternalError(
        absl::StrFormat("FailureError: Value is not valid for enum %s: %s",
                        enum_def.identifier(), bits_value.ToString()));
  }
  return InterpValue::MakeEnum(bits_value.GetBitsOrDie(), &enum_def);
}

absl::StatusOr<InterpValue> CreateZeroValue(const InterpValue& value) {
  switch (value.tag()) {
    case InterpValueTag::kSBits: {
      XLS_ASSIGN_OR_RETURN(int64_t bit_count, value.GetBitCount());
      return InterpValue::MakeSBits(bit_count, /*value=*/0);
    }
    case InterpValueTag::kUBits: {
      XLS_ASSIGN_OR_RETURN(int64_t bit_count, value.GetBitCount());
      return InterpValue::MakeUBits(bit_count, /*value=*/0);
    }
    case InterpValueTag::kTuple: {
      XLS_ASSIGN_OR_RETURN(const std::vector<InterpValue>* elements,
                           value.GetValues());
      std::vector<InterpValue> zero_elements;
      zero_elements.reserve(elements->size());
      for (const auto& element : *elements) {
        XLS_ASSIGN_OR_RETURN(InterpValue zero_element,
                             CreateZeroValue(element));
        zero_elements.push_back(zero_element);
      }
      return InterpValue::MakeTuple(zero_elements);
    }
    case InterpValueTag::kArray: {
      XLS_ASSIGN_OR_RETURN(const std::vector<InterpValue>* elements,
                           value.GetValues());
      if (elements->empty()) {
        return InterpValue::MakeArray({});
      }
      XLS_ASSIGN_OR_RETURN(InterpValue zero_element,
                           CreateZeroValue(elements->at(0)));
      std::vector<InterpValue> zero_elements(elements->size(), zero_element);
      return InterpValue::MakeArray(zero_elements);
    }
    default:
      return absl::InvalidArgumentError(
          absl::StrCat("Invalid InterpValueTag for zero-value generation: ",
                       TagToString(value.tag())));
  }
}

absl::Status FlattenTuple(const InterpValue& value,
                          std::vector<InterpValue>* result) {
  if (!value.IsTuple()) {
    result->push_back(value);
    return absl::OkStatus();
  }

  XLS_ASSIGN_OR_RETURN(const std::vector<InterpValue>* values,
                       value.GetValues());
  for (const auto& value : *values) {
    XLS_RETURN_IF_ERROR(FlattenTuple(value, result));
  }

  return absl::OkStatus();
}

absl::StatusOr<absl::optional<int64_t>> FindFirstDifferingIndex(
    absl::Span<const InterpValue> lhs, absl::Span<const InterpValue> rhs) {
  if (lhs.size() != rhs.size()) {
    return absl::InvalidArgumentError(
        absl::StrFormat("LHS and RHS must have the same size: %d vs. %d.",
                        lhs.size(), rhs.size()));
  }

  for (int64_t i = 0; i < lhs.size(); ++i) {
    if (lhs[i].Ne(rhs[i])) {
      return i;
    }
  }

  return absl::nullopt;
}

}  // namespace xls::dslx
