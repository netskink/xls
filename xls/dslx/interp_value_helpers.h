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
#ifndef XLS_DSLX_INTERP_VALUE_HELPERS_H_
#define XLS_DSLX_INTERP_VALUE_HELPERS_H_

#include "absl/status/statusor.h"
#include "xls/dslx/concrete_type.h"
#include "xls/dslx/interp_value.h"

namespace xls::dslx {

// Converts the given (Bits-typed) InterpValue to an array of equal- or
// smaller-sized Bits-typed values.
absl::StatusOr<InterpValue> CastBitsToArray(const InterpValue& bits_value,
                                            const ArrayType& array_type);

// Converts the given Bits-typed value into an enum-typed value.
absl::StatusOr<InterpValue> CastBitsToEnum(const InterpValue& bits_value,
                                           const EnumType& enum_type);

// Creates a zero-valued InterpValue with the same structure as the input.
absl::StatusOr<InterpValue> CreateZeroValue(const InterpValue& value);

// Places a "flat" representation of the input value (if it's a tuple) in
// `result`. Converts, e.g., (a, (b, c), d) into {a, b, c, d}.
absl::Status FlattenTuple(const InterpValue& value,
                          std::vector<InterpValue>* result);

// Finds the first index in the LHS and RHS sequences at which values differ or
// nullopt if the two are equal.
absl::StatusOr<absl::optional<int64_t>> FindFirstDifferingIndex(
    absl::Span<const InterpValue> lhs, absl::Span<const InterpValue> rhs);

}  // namespace xls::dslx

#endif  // XLS_DSLX_INTERP_VALUE_HELPERS_H_
