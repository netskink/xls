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

"""This module contains helpers for XLS build rules."""

def append_default_to_args(arguments, default_arguments):
    """Returns a dictionary with the default arguments appended to the arguments.

    Example:
      1) All default arguments are appended.
        Input:
          arguments = {"argument1": "42", "argument2": "binary"}
          default_arguments = {"argument3": "hello", "argument4": "world"}
          append_default_to_args(arguments, default_arguments)

        Output:
            {"argument1": "42", "argument2": "binary", "argument3": "hello",
             "argument4": "world"}
      2) Some default arguments are appended.
        Input:
          arguments = {"argument1": "42", "argument2": "binary"}
          default_arguments = {"argument2": "hello", "argument3": "world"}
          append_default_to_args(arguments, default_arguments)

        Output:
            {"argument1": "42", "argument2": "binary", "argument3": "world"}
      3) No default arguments are appended.
        Input:
          arguments = {"argument1": "42", "argument2": "binary"}
          default_arguments = {"argument1": "hello", "argument2": "world"}
          append_default_to_args(arguments, default_arguments)

        Output:
            {"argument1": "42", "argument2": "binary"}

    Args:
      arguments: A dictionary of arguments where the key is the argument name
        and the value is the value of the argument.
      default_arguments: A dictionary of arguments where the key is the argument
        name and the value is the value of the argument.
    Returns:
      A newly created dictionary with the default_arguments append to the
      arguments.
    """

    # Append to arguments
    my_args = dict(arguments)
    for key in default_arguments.keys():
        my_args.setdefault(key, default_arguments[key])
    return my_args

def is_args_valid(arguments, valid_arguments):
    """Validates a dictionary of arguments with a list of valid arguments.

    If an argument has a key that is not a valid argument, an error is thrown.
    Otherwise, the function returns True.

    Example:
      1) Simple use case.
        Input:
          arguments = {"argument1": "42", "argument2": "binary"}
          valid_arguments = {"argument1", "argument2", "arguments3"}
          is_args_valid(arguments, valid_arguments)

        Output:
            True
      2) An invalid argument.
        Input:
          arguments = {"argument1": "42", "argument2": "binary"}
          valid_arguments = {"argument1"}
          is_args_valid(arguments, valid_arguments)

        Output (error with message):
            Unrecognized argument: argument2.

    Args:
      arguments: A dictionary of arguments where the key is the argument name
        and the value is the value of the argument.
      valid_arguments: A list of valid arguments names.

    Returns:
      If an argument has a key that is not a valid argument, an error is thrown.
      Otherwise, the function returns True.
    """
    for flag_name in arguments:
        if flag_name not in valid_arguments:
            fail("Unrecognized argument: %s." % flag_name)
    return True

def args_to_string(arguments):
    """Returns a string representation of the arguments.

    The macro builds a string representation of the arguments.

    Example:
      1) Simple use case.
        Input:
          arguments = {"argument1": "42", "argument2": "binary"}
          args_to_string(arguments)

        Output:
            --argument1=42 --argument2=binary

    Args:
      arguments: A dictionary of arguments where the key is the argument name
        and the value is the value of the argument.
    Returns:
      A string representation of the arguments.
    """

    # Add arguments
    my_args = ""
    for flag_name in arguments:
        my_args += " --%s=%s" % (flag_name, arguments[flag_name])
    return my_args

def append_cmd_line_args_to(cmd):
    """Appends the syntax for command line arguments ("$*") to the cmd

    Args:
      cmd: A string representing the command.

    Returns:
      'cmd' with the syntax for command line arguments ("$*") appended
    """
    return cmd + " $*"

def get_output_filename_value(ctx, output_attr_name, default_filename):
    """Returns the filename for an output attribute within the context.

    If the output_attr_name is defined in the context, the function returns
    the value of the output_attr_name. Otherwise, the function returns the
    default_filename.

    Args:
      ctx: The current rule's context object.
      output_attr_name: The name of the output attribute.
      default_filename: The default filename.

    Returns:
      The filename for an output attribute within the context.
    """
    attribute_value = getattr(ctx.attr, output_attr_name)
    if attribute_value:
        return attribute_value.name
    else:
        return default_filename

def split_filename(filename):
    """Returns the basename and extension of a given filename.

    The basename and extension are distinguished using the rightmost dot (.).
    For example, "a.file.name.ext" the basename is equivalent to "a.file.name"
    and the extension is equivalent to "ext". If there is no dot in the
    filename, the basename is equivalent to the filename, and the extension is
    equivalent to 'None'.

    Args:
      filename: The filename.

    Returns:
      The filename for an output attribute within the context.
    """
    if "." not in filename:
        return [filename, None]
    return filename.rsplit(".", 1)
