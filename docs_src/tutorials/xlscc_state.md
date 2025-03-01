# Tutorial: XLS[cc] state.

[TOC]

This tutorial is aimed at walking you through the implementation and synthesis
into Verilog of a C++ function containing state.

XLS[cc] may infer that in order to achieve a particular implementation of a C++
function, operations may occur over multiple cycles and require additional proc
state to be kept. Common constructs that may require this are static variables,
or loops that aren't unrolled. In this tutorial we give an example using static
variables.

## C++ Source

Create a file named `test_state.cc` with the following contents.

```c
#include "/xls_builtin.h"

#pragma hls_top
void test_state(__xls_channel<int>& out) {
  static int count = 0;
  out.write(count);
  ++count;
}
```

As the above function uses channels, a proto detailing the type of interface is
required. Create a a file named `test_state.textproto` with the following
contents to configure `out` as an output FIFO (ready/valid) interface.

```
channels {
  name: "out"
  is_input: false
  type: FIFO
}
name: "xls_test_state"
```

## Generate optimized XLS IR.

Use a combination of `proto2bin`, `xlscc` and `xls_opt` to generate optimized
XLS IR.

```
$ ./bazel-bin/xls/tools/proto2bin test_state.textproto --message xlscc.HLSBlock --output test_state.pb
$ ./bazel-bin/xls/contrib/xlscc/xlscc test_state.cc \
  --block_pb test_state.pb \
  --dump_ir_only test_channels.ir
$ ./bazel-bin/xls/tools/xls_opt test_state.ir > test_state.opt.ir
```

## Perform code-generation into a pipelined Verilog block.

In this case, we will generate a single-stage pipeline without input and output
flops. This will result in a module with a 32-bit increment adder along with
32-bit of state.

```
$ ./bazel-bin/xls/tools/codegen_main test_state.opt.ir \
  --generator=pipeline \
  --delay_model="sky130" \
  --output_verilog_path=xls_counter.v \
  --module_name=xls_counter \
  --top_level_proc=xls_test_state_proc \
  --reset=rst \
  --reset_active_low=false \
  --reset_asynchronous=false \
  --reset_data_path=true \
  --pipeline_stages=1  \
  --flop_inputs=false \
  --flop_outputs=false
```

After running codegen, you should see a file named `xls_counter.v` with contents
similar to the following.

```
module xls_counter(
  input wire clk,
  input wire rst,
  input wire out_rdy,
  output wire [31:0] out,
  output wire out_vld
);
  wire [31:0] __st_init;
  assign __st_init = {32'h0000_0000};
  reg [31:0] __st;
  wire [31:0] tuple_index_28;
  wire [31:0] add_30;
  wire literal_36;
  wire [31:0] tuple_32;
  wire pipeline_enable;
  assign tuple_index_28 = __st[31:0];
  assign add_30 = tuple_index_28 + 32'h0000_0001;
  assign literal_36 = 1'h1;
  assign tuple_32 = {add_30};
  assign pipeline_enable = out_rdy & literal_36;
  always_ff @ (posedge clk) begin
    if (rst) begin
      __st <= __st_init;
    end else begin
      __st <= pipeline_enable ? tuple_32 : __st;
    end
  end
  assign out = tuple_index_28;
  assign out_vld = literal_36;
endmodule
```

## Additional XLS[cc] examples.

The above tutorials only touches upon the capabilities of XLS[cc]. XLS[cc] is
based on libclang and supports many C++17 features. Notable *unsupported*
features include pointers, function pointers, and virtual methods.

For developers, it is possible to check if a specific feature is supported by
checking
[translator_test.cc](https://github.com/google/xls/tree/main/xls/contrib/xlscc/translator_test.cc)
for unit tests.
