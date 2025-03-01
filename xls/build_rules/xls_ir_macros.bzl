# Copyright 2021 The XLS Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
This module contains IR-related build macros for XLS.
"""

load(
    "//xls/build_rules:xls_config_rules.bzl",
    "enable_generated_file_wrapper",
)
load(
    "//xls/build_rules:xls_ir_rules.bzl",
    "append_xls_dslx_ir_generated_files",
    "append_xls_ir_opt_ir_generated_files",
    "get_xls_dslx_ir_generated_files",
    "get_xls_ir_opt_ir_generated_files",
    "xls_dslx_ir",
    "xls_ir_opt_ir",
)

def xls_dslx_ir_macro(
        name,
        dslx_top,
        srcs = None,
        deps = None,
        library = None,
        ir_conv_args = {},
        enable_generated_file = True,
        enable_presubmit_generated_file = False,
        **kwargs):
    """A macro that instantiates a build rule converting a DSLX source file to an IR file.

    The macro instantiates a rule that converts a DSLX source file to an IR
    file. The macro also instantiates the 'enable_generated_file_wrapper'
    function. The generated files are listed in the outs attribute of the rule.

    Examples:

    1. A simple IR conversion.

        ```
        # Assume a xls_dslx_library target bc_dslx is present.
        xls_dslx_ir(
            name = "d_ir",
            srcs = ["d.x"],
            deps = [":bc_dslx"],
        )
        ```

    1. An IR conversion with an entry defined.

        ```
        # Assume a xls_dslx_library target bc_dslx is present.
        xls_dslx_ir(
            name = "d_ir",
            srcs = ["d.x"],
            deps = [":bc_dslx"],
            dslx_top = "d",
        )
        ```

    Args:
      name: The name of the rule.
      srcs: Top level source files for the conversion. Files must have a '.x'
        extension. There must be single source file.
      deps: Dependency targets for the files in the 'srcs' argument.
      library: A DSLX library target where the direct (non-transitive)
        files of the target are tested. This argument is mutually
        exclusive with the 'srcs' and 'deps' arguments.
      dslx_top: The entry point to perform the IR conversion.
      ir_conv_args: Arguments of the IR conversion tool. For details on the
        arguments, refer to the ir_converter_main application at
        //xls/dslx/ir_converter_main.cc. Note: the 'entry'
        argument is not assigned using this attribute.
      enable_generated_file: See 'enable_generated_file' from
        'enable_generated_file_wrapper' function.
      enable_presubmit_generated_file: See 'enable_presubmit_generated_file'
        from 'enable_generated_file_wrapper' function.
      **kwargs: Keyword arguments. Named arguments.
    """

    # Type check input
    if type(name) != type(""):
        fail("Argument 'name' must be of string type.")
    if srcs and type(srcs) != type([]):
        fail("Argument 'srcs' must be of list type.")
    if deps and type(deps) != type([]):
        fail("Argument 'deps' must be of list type.")
    if library and type(library) != type(""):
        fail("Argument 'library' must be of string type.")
    if type(dslx_top) != type(""):
        fail("Argument 'dslx_top' must be of string type.")
    if type(ir_conv_args) != type({}):
        fail("Argument 'ir_conv_args' must be of dictionary type.")
    if type(enable_generated_file) != type(True):
        fail("Argument 'enable_generated_file' must be of boolean type.")
    if type(enable_presubmit_generated_file) != type(True):
        fail("Argument 'enable_presubmit_generated_file' must be " +
             "of boolean type.")

    # Append output files to arguments.
    kwargs = append_xls_dslx_ir_generated_files(kwargs, name)

    xls_dslx_ir(
        name = name,
        srcs = srcs,
        deps = deps,
        library = library,
        dslx_top = dslx_top,
        ir_conv_args = ir_conv_args,
        outs = get_xls_dslx_ir_generated_files(kwargs),
        **kwargs
    )
    enable_generated_file_wrapper(
        wrapped_target = name,
        enable_generated_file = enable_generated_file,
        enable_presubmit_generated_file = enable_presubmit_generated_file,
        **kwargs
    )

def xls_ir_opt_ir_macro(
        name,
        src,
        opt_ir_args = {},
        enable_generated_file = True,
        enable_presubmit_generated_file = False,
        **kwargs):
    """A macro that instantiates a build rule optimizing an IR file.

    The macro instantiates a build rule that optimizes an IR file. The macro
    also instantiates the 'enable_generated_file_wrapper' function. The
    generated files are listed in the outs attribute of the rule.

    Examples:

    1. Optimizing an IR file with an entry defined.

        ```
        xls_ir_opt_ir(
            name = "a_opt_ir",
            src = "a.ir",
            opt_ir_args = {
                "entry" : "a",
            },
        )
        ```

    1. A target as the source.

        ```
        xls_dslx_ir(
            name = "a_ir",
            srcs = ["a.x"],
        )

        xls_ir_opt_ir(
            name = "a_opt_ir",
            src = ":a_ir",
        )
        ```

    Args:
      name: The name of the rule.
      src: The IR source file. A single source file must be provided. The file
        must have a '.ir' extension.
      opt_ir_args: Arguments of the IR optimizer tool. For details on the
        arguments, refer to the opt_main application at
        //xls/tools/opt_main.cc. Note: the 'entry'
        argument is not assigned using this attribute.
      enable_generated_file: See 'enable_generated_file' from
        'enable_generated_file_wrapper' function.
      enable_presubmit_generated_file: See 'enable_presubmit_generated_file'
        from 'enable_generated_file_wrapper' function.
      **kwargs: Keyword arguments. Named arguments.
    """

    # Type check input
    if type(name) != type(""):
        fail("Argument 'name' must be of string type.")
    if type(src) != type(""):
        fail("Argument 'src' must be of string type.")
    if type(opt_ir_args) != type({}):
        fail("Argument 'opt_ir_args' must be of dictionary type.")
    if type(enable_generated_file) != type(True):
        fail("Argument 'enable_generated_file' must be of boolean type.")
    if type(enable_presubmit_generated_file) != type(True):
        fail("Argument 'enable_presubmit_generated_file' must be " +
             "of boolean type.")

    # Append output files to arguments.
    kwargs = append_xls_ir_opt_ir_generated_files(kwargs, name)

    xls_ir_opt_ir(
        name = name,
        src = src,
        opt_ir_args = opt_ir_args,
        outs = get_xls_ir_opt_ir_generated_files(kwargs),
        **kwargs
    )
    enable_generated_file_wrapper(
        wrapped_target = name,
        enable_generated_file = enable_generated_file,
        enable_presubmit_generated_file = enable_presubmit_generated_file,
        **kwargs
    )
