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

// options: {"input_is_dslx": true, "ir_converter_args": ["--entry=main"], "convert_to_ir": true, "optimize_ir": true, "codegen": true, "codegen_args": ["--generator=pipeline", "--pipeline_stages=3"], "simulate": false, "simulator": null}
// args: bits[18]:0x40; bits[41]:0x400000; bits[55]:0x800
// args: bits[18]:0x3ffff; bits[41]:0x20; bits[55]:0x1
// args: bits[18]:0x400; bits[41]:0x2000000; bits[55]:0x20000000000
// args: bits[18]:0x8; bits[41]:0x100000000; bits[55]:0x20000
// args: bits[18]:0x3fad; bits[41]:0x80000000; bits[55]:0x10000000000000
// args: bits[18]:0x100; bits[41]:0x20; bits[55]:0x4000000000
// args: bits[18]:0x20000; bits[41]:0x15555555555; bits[55]:0x100000
// args: bits[18]:0x8; bits[41]:0x2000; bits[55]:0x200
// args: bits[18]:0x20; bits[41]:0x2000000000; bits[55]:0x800000000
// args: bits[18]:0x3ffff; bits[41]:0x1000000; bits[55]:0x80000000000
// args: bits[18]:0x100; bits[41]:0x10000000; bits[55]:0x40000
// args: bits[18]:0x2aaaa; bits[41]:0x1; bits[55]:0x80
// args: bits[18]:0x400; bits[41]:0x2; bits[55]:0x10
// args: bits[18]:0x40; bits[41]:0x40000000; bits[55]:0x1000000000000
// args: bits[18]:0x1000; bits[41]:0x9f9f4fff7d; bits[55]:0x8000
// args: bits[18]:0x1000; bits[41]:0x8; bits[55]:0x800000
// args: bits[18]:0x8; bits[41]:0x2000000000; bits[55]:0x100000000000
// args: bits[18]:0x8; bits[41]:0x2; bits[55]:0x2
// args: bits[18]:0x4000; bits[41]:0x20; bits[55]:0x5d5b4c4bb4f427
// args: bits[18]:0x100; bits[41]:0x7d83d4f74f; bits[55]:0x40000000000000
// args: bits[18]:0x20000; bits[41]:0xdeff8c8529; bits[55]:0x8000000000
// args: bits[18]:0x0; bits[41]:0x1709a2f1afc; bits[55]:0x100000000
// args: bits[18]:0x100; bits[41]:0x1af9cd2c746; bits[55]:0x11b7e2b3385d83
// args: bits[18]:0x4; bits[41]:0x0; bits[55]:0x1000
// args: bits[18]:0x20; bits[41]:0x4000; bits[55]:0x40000000
// args: bits[18]:0x10; bits[41]:0x393112b3ca; bits[55]:0x40000000
// args: bits[18]:0x10000; bits[41]:0x5bfcb7a2ae; bits[55]:0x100000000
// args: bits[18]:0x200; bits[41]:0x10000000; bits[55]:0x3fffffffffffff
// args: bits[18]:0x1; bits[41]:0x2000; bits[55]:0x8000000000
// args: bits[18]:0x400; bits[41]:0x20; bits[55]:0x8
// args: bits[18]:0x2aaaa; bits[41]:0x200000; bits[55]:0x59cecabbc86130
// args: bits[18]:0x3ad3e; bits[41]:0xaaaaaaaaaa; bits[55]:0x3d432510119a1a
// args: bits[18]:0x1000; bits[41]:0x40; bits[55]:0x4000000000
// args: bits[18]:0x8000; bits[41]:0x100; bits[55]:0x20000
// args: bits[18]:0x0; bits[41]:0x40000; bits[55]:0x4000000
// args: bits[18]:0x2; bits[41]:0x2000000000; bits[55]:0x4000000000
// args: bits[18]:0x20000; bits[41]:0x800; bits[55]:0x7f917fec548f83
// args: bits[18]:0x4; bits[41]:0x40000; bits[55]:0x8
// args: bits[18]:0x100; bits[41]:0x80; bits[55]:0x80000000
// args: bits[18]:0x15555; bits[41]:0x100; bits[55]:0x40000000
// args: bits[18]:0x1a960; bits[41]:0x1000000000; bits[55]:0x5277ac851438fc
// args: bits[18]:0x20; bits[41]:0x80; bits[55]:0x20000000000
// args: bits[18]:0x10; bits[41]:0x1; bits[55]:0x400000
// args: bits[18]:0x200; bits[41]:0x20000; bits[55]:0x4000000
// args: bits[18]:0x800; bits[41]:0x400000000; bits[55]:0x400000000
// args: bits[18]:0x15555; bits[41]:0x2000000000; bits[55]:0x773a70ca5eb8a8
// args: bits[18]:0x20; bits[41]:0x1000000000; bits[55]:0x3fffffffffffff
// args: bits[18]:0x15555; bits[41]:0x80; bits[55]:0x2aaaaaaaaaaaaa
// args: bits[18]:0x1; bits[41]:0x8000000; bits[55]:0x4000000000
// args: bits[18]:0x1ffff; bits[41]:0x2000000; bits[55]:0x10000000000000
// args: bits[18]:0x2aaaa; bits[41]:0x0; bits[55]:0x80000000
// args: bits[18]:0x10; bits[41]:0x1000000; bits[55]:0x80
// args: bits[18]:0x10000; bits[41]:0x80; bits[55]:0x400000000
// args: bits[18]:0x800; bits[41]:0x10000000000; bits[55]:0x3fffffffffffff
// args: bits[18]:0x2000; bits[41]:0x20; bits[55]:0x800
// args: bits[18]:0x40; bits[41]:0x100; bits[55]:0x100
// args: bits[18]:0x15555; bits[41]:0x100000000; bits[55]:0x80000
// args: bits[18]:0x1; bits[41]:0x800; bits[55]:0x8000000
// args: bits[18]:0x20000; bits[41]:0x20; bits[55]:0x400
// args: bits[18]:0x20000; bits[41]:0x80; bits[55]:0x4000000
// args: bits[18]:0x1000; bits[41]:0x2000000000; bits[55]:0x40
// args: bits[18]:0x20000; bits[41]:0x1000000; bits[55]:0x80000
// args: bits[18]:0x10000; bits[41]:0x10000; bits[55]:0x20000
// args: bits[18]:0x8; bits[41]:0x1ffffffffff; bits[55]:0x1000000000
// args: bits[18]:0x2aaaa; bits[41]:0x8; bits[55]:0x40
// args: bits[18]:0x1000; bits[41]:0x20000000; bits[55]:0x40000000
// args: bits[18]:0x15555; bits[41]:0x8000; bits[55]:0x800
// args: bits[18]:0x2aaaa; bits[41]:0x1; bits[55]:0x4000000
// args: bits[18]:0x2000; bits[41]:0x4000000; bits[55]:0x40000
// args: bits[18]:0x4000; bits[41]:0x2; bits[55]:0x800000000000
// args: bits[18]:0x3ffff; bits[41]:0x8000000; bits[55]:0x80000000000
// args: bits[18]:0x200; bits[41]:0x40000; bits[55]:0x8000000000
// args: bits[18]:0x10000; bits[41]:0x40; bits[55]:0x1000000000
// args: bits[18]:0x2aaaa; bits[41]:0x400000; bits[55]:0x20000000000
// args: bits[18]:0x200; bits[41]:0xaaaaaaaaaa; bits[55]:0x10000000
// args: bits[18]:0x800; bits[41]:0x2000; bits[55]:0x1000000000
// args: bits[18]:0x1; bits[41]:0x2000000000; bits[55]:0x20000000000
// args: bits[18]:0x2000; bits[41]:0x4000000000; bits[55]:0x8000000000000
// args: bits[18]:0x1000; bits[41]:0x80000000; bits[55]:0x40
// args: bits[18]:0x8000; bits[41]:0x10000000000; bits[55]:0x4000000
// args: bits[18]:0x8000; bits[41]:0x200000000; bits[55]:0x40000000000
// args: bits[18]:0x2000; bits[41]:0x10000000000; bits[55]:0x200000
// args: bits[18]:0x400; bits[41]:0xaaaaaaaaaa; bits[55]:0x20000000000000
// args: bits[18]:0x100; bits[41]:0x10000000000; bits[55]:0x80
// args: bits[18]:0x400; bits[41]:0x800; bits[55]:0x200000000
// args: bits[18]:0x6a99; bits[41]:0xffffffffff; bits[55]:0x400000000000
// args: bits[18]:0x25e1c; bits[41]:0x4000; bits[55]:0x1
// args: bits[18]:0x8000; bits[41]:0x2000; bits[55]:0x1000000000
// args: bits[18]:0x100; bits[41]:0x0; bits[55]:0x10000000
// args: bits[18]:0x40; bits[41]:0x200000000; bits[55]:0x80
// args: bits[18]:0x8000; bits[41]:0x80000000; bits[55]:0x20
// args: bits[18]:0x10000; bits[41]:0x800000000; bits[55]:0x200000000
// args: bits[18]:0x2; bits[41]:0x1; bits[55]:0x6a0f346a708bee
// args: bits[18]:0x200; bits[41]:0x15555555555; bits[55]:0x200000000000
// args: bits[18]:0x400; bits[41]:0x100; bits[55]:0x800000
// args: bits[18]:0x1000; bits[41]:0x8; bits[55]:0x10000000
// args: bits[18]:0x400; bits[41]:0x40000000; bits[55]:0x100000
// args: bits[18]:0x3ffff; bits[41]:0x4; bits[55]:0x1000000000
// args: bits[18]:0x400; bits[41]:0x80; bits[55]:0x100000000000
// args: bits[18]:0x200; bits[41]:0xaaaaaaaaaa; bits[55]:0x100
// args: bits[18]:0x8; bits[41]:0x400000000; bits[55]:0x513a0e9e30d71c
// args: bits[18]:0x2; bits[41]:0x100000000; bits[55]:0x400000000000
// args: bits[18]:0x8000; bits[41]:0x4000000; bits[55]:0x100
// args: bits[18]:0x200; bits[41]:0x1ffffffffff; bits[55]:0x40000000000000
// args: bits[18]:0x15555; bits[41]:0x4; bits[55]:0xb65c2dd5ee875
// args: bits[18]:0x1000; bits[41]:0x1000000000; bits[55]:0x2d39c2a7a1dcff
// args: bits[18]:0x100; bits[41]:0x20; bits[55]:0x80
// args: bits[18]:0x3ffff; bits[41]:0x10000; bits[55]:0x1000000
// args: bits[18]:0x10; bits[41]:0x10; bits[55]:0x20000000000
// args: bits[18]:0x400; bits[41]:0x1000000; bits[55]:0x4000000000
// args: bits[18]:0x0; bits[41]:0x100000; bits[55]:0x400000000000
// args: bits[18]:0x100; bits[41]:0x40; bits[55]:0x40
// args: bits[18]:0x8; bits[41]:0x100000000; bits[55]:0x100
// args: bits[18]:0x8000; bits[41]:0x1000; bits[55]:0x47525425bf1fc1
// args: bits[18]:0x80; bits[41]:0x1f4729c91a7; bits[55]:0x8000000000
// args: bits[18]:0x1000; bits[41]:0x20; bits[55]:0x100000
// args: bits[18]:0x2; bits[41]:0x1000; bits[55]:0x2000
// args: bits[18]:0x1; bits[41]:0x1ffffffffff; bits[55]:0x40000000000
// args: bits[18]:0x1000; bits[41]:0x124692a4f52; bits[55]:0x4000000000
// args: bits[18]:0x20000; bits[41]:0x1c02b396716; bits[55]:0x74097a42736dc
// args: bits[18]:0x20; bits[41]:0x1ffffffffff; bits[55]:0x80000
// args: bits[18]:0x20000; bits[41]:0x200000; bits[55]:0x10000
// args: bits[18]:0x200; bits[41]:0x8000000000; bits[55]:0x20000000
// args: bits[18]:0x200; bits[41]:0x8000; bits[55]:0x100000000
// args: bits[18]:0x20000; bits[41]:0x846ac52c10; bits[55]:0x3fffffffffffff
// args: bits[18]:0x4000; bits[41]:0x1000; bits[55]:0x3fffffffffffff
// args: bits[18]:0x200; bits[41]:0x2; bits[55]:0x10000000000000
// args: bits[18]:0x1; bits[41]:0xffffffffff; bits[55]:0x800000000000
// args: bits[18]:0x0; bits[41]:0x20; bits[55]:0x4
// args: bits[18]:0x1000; bits[41]:0x15555555555; bits[55]:0x8000
// args: bits[18]:0x40; bits[41]:0xb93a7ab12b; bits[55]:0x20000000000
// args: bits[18]:0x400; bits[41]:0x0; bits[55]:0x4000000000000
// args: bits[18]:0x2aaaa; bits[41]:0x4; bits[55]:0x8000000000000
// args: bits[18]:0x800; bits[41]:0xcf43426abf; bits[55]:0x200000000
// args: bits[18]:0x4; bits[41]:0x40; bits[55]:0x2
// args: bits[18]:0x800; bits[41]:0x1c64a037f36; bits[55]:0x1
// args: bits[18]:0x10000; bits[41]:0x18a9b018c95; bits[55]:0x40000000
// args: bits[18]:0x20; bits[41]:0x2000; bits[55]:0x8000
// args: bits[18]:0x1ffff; bits[41]:0x10000; bits[55]:0x80000000000
// args: bits[18]:0x100; bits[41]:0x2; bits[55]:0x100000000000
// args: bits[18]:0x1ffff; bits[41]:0xba25e4da61; bits[55]:0x8000
// args: bits[18]:0x20000; bits[41]:0x1ffffffffff; bits[55]:0x1
// args: bits[18]:0x15555; bits[41]:0x1ffffffffff; bits[55]:0x100
// args: bits[18]:0x15555; bits[41]:0x800000000; bits[55]:0x800000
// args: bits[18]:0x20000; bits[41]:0x100000; bits[55]:0x40000000
// args: bits[18]:0x20; bits[41]:0x400000000; bits[55]:0x2a6a040283004f
// args: bits[18]:0x15555; bits[41]:0x2000000000; bits[55]:0x400000000
// args: bits[18]:0x4; bits[41]:0x1; bits[55]:0x2000
// args: bits[18]:0x8; bits[41]:0x1; bits[55]:0x4000000000
// args: bits[18]:0x3ffff; bits[41]:0x1ffffffffff; bits[55]:0x100
// args: bits[18]:0x2; bits[41]:0x4000000; bits[55]:0x15c72eaf38fcfe
// args: bits[18]:0x24298; bits[41]:0x1ffffffffff; bits[55]:0x7fffffffffffff
// args: bits[18]:0x2000; bits[41]:0x4000000; bits[55]:0x400000
// args: bits[18]:0x1ffff; bits[41]:0x800; bits[55]:0x942a1f5c6ecc8
// args: bits[18]:0x2000; bits[41]:0x10000000000; bits[55]:0x1
// args: bits[18]:0x400; bits[41]:0x400; bits[55]:0x8000000000
// args: bits[18]:0x19cb1; bits[41]:0x2000000; bits[55]:0x1000000000
// args: bits[18]:0x1a533; bits[41]:0x200; bits[55]:0x2e0cd72ce20eee
// args: bits[18]:0x40; bits[41]:0xba4abd862c; bits[55]:0x8000000000000
// args: bits[18]:0x4; bits[41]:0x800; bits[55]:0x4000
// args: bits[18]:0x2aaaa; bits[41]:0x40000000; bits[55]:0x10
// args: bits[18]:0x80; bits[41]:0x7b597fbea5; bits[55]:0x100000000
// args: bits[18]:0x1000; bits[41]:0x2000; bits[55]:0x20000
// args: bits[18]:0x1ffff; bits[41]:0x80000; bits[55]:0x5795994fdf2e35
// args: bits[18]:0x1; bits[41]:0x4; bits[55]:0x40000000
// args: bits[18]:0x200; bits[41]:0x1000; bits[55]:0x7fffffffffffff
// args: bits[18]:0x800; bits[41]:0x200; bits[55]:0x100000
// args: bits[18]:0x3ffff; bits[41]:0x80000; bits[55]:0x200000
// args: bits[18]:0x1; bits[41]:0x4000; bits[55]:0x1000000
// args: bits[18]:0x10000; bits[41]:0x10000000000; bits[55]:0x10000000000
// args: bits[18]:0x3ffff; bits[41]:0x800000; bits[55]:0x2000
// args: bits[18]:0x8; bits[41]:0x2000000; bits[55]:0x400000000
// args: bits[18]:0x37190; bits[41]:0x4000000; bits[55]:0x40000
// args: bits[18]:0x15820; bits[41]:0x15555555555; bits[55]:0x800000
// args: bits[18]:0x1000; bits[41]:0x8000000; bits[55]:0x8000
// args: bits[18]:0x20000; bits[41]:0x4000; bits[55]:0x100000
// args: bits[18]:0x2000; bits[41]:0xace30103e2; bits[55]:0x20000000000000
// args: bits[18]:0x400; bits[41]:0x8000000000; bits[55]:0x61eb9349daeab8
// args: bits[18]:0x2; bits[41]:0x71eb2246ce; bits[55]:0x55555555555555
// args: bits[18]:0x1; bits[41]:0x100000000; bits[55]:0x10000000000
// args: bits[18]:0x40; bits[41]:0x2; bits[55]:0x8000
// args: bits[18]:0x2000; bits[41]:0x8000000000; bits[55]:0x8000000
// args: bits[18]:0x1ffff; bits[41]:0x400; bits[55]:0x4
// args: bits[18]:0x3c09d; bits[41]:0x8; bits[55]:0x80000000
// args: bits[18]:0x27ec; bits[41]:0xe9f7b3e50b; bits[55]:0x400000
// args: bits[18]:0x100; bits[41]:0x2000000000; bits[55]:0x400000
// args: bits[18]:0x800; bits[41]:0x1000000000; bits[55]:0x80000000
// args: bits[18]:0x40; bits[41]:0x17dcfc26e0c; bits[55]:0x1000000
// args: bits[18]:0x1; bits[41]:0x80; bits[55]:0x2000000000000
// args: bits[18]:0x2aaaa; bits[41]:0x100000; bits[55]:0x800000000000
// args: bits[18]:0x1; bits[41]:0x1000; bits[55]:0x200000000000
// args: bits[18]:0x20000; bits[41]:0x40000000; bits[55]:0x400
// args: bits[18]:0x20000; bits[41]:0x1308e826306; bits[55]:0x400
// args: bits[18]:0x2000; bits[41]:0x100; bits[55]:0x4000000
// args: bits[18]:0x800; bits[41]:0xaaaaaaaaaa; bits[55]:0x400000000
// args: bits[18]:0x4; bits[41]:0x200000; bits[55]:0x3fffffffffffff
// args: bits[18]:0x3d96a; bits[41]:0x200000000; bits[55]:0x6a5afc554d83f1
// args: bits[18]:0x2000; bits[41]:0x0; bits[55]:0x400000
// args: bits[18]:0x0; bits[41]:0x80000; bits[55]:0x400000000
// args: bits[18]:0x15555; bits[41]:0x10000; bits[55]:0x2aaaaaaaaaaaaa
// args: bits[18]:0x4000; bits[41]:0x9c71fc9a8a; bits[55]:0x2000
// args: bits[18]:0x15555; bits[41]:0x2000000; bits[55]:0x20000000000000
// args: bits[18]:0x3ffff; bits[41]:0xffffffffff; bits[55]:0x40
// args: bits[18]:0x2000; bits[41]:0x8000; bits[55]:0x2000000000000
// args: bits[18]:0x2; bits[41]:0x1ffffffffff; bits[55]:0x400000000000
// args: bits[18]:0x20000; bits[41]:0x4000000000; bits[55]:0x4000000000
// args: bits[18]:0x400; bits[41]:0x2000000000; bits[55]:0x40000000
// args: bits[18]:0x4; bits[41]:0x20000; bits[55]:0x2f773db2bdf68b
// args: bits[18]:0x15555; bits[41]:0x10000000; bits[55]:0x2aaaaaaaaaaaaa
// args: bits[18]:0x2aaaa; bits[41]:0x400000000; bits[55]:0x4000000
// args: bits[18]:0x8000; bits[41]:0x100; bits[55]:0x100000000
// args: bits[18]:0x800; bits[41]:0x800000; bits[55]:0x20
// args: bits[18]:0x10000; bits[41]:0x1000000; bits[55]:0x40000000000000
// args: bits[18]:0x1; bits[41]:0x100000; bits[55]:0x10000
// args: bits[18]:0x1ffff; bits[41]:0x40; bits[55]:0x800000000
// args: bits[18]:0x2; bits[41]:0x80000000; bits[55]:0x55555555555555
// args: bits[18]:0x20; bits[41]:0x8000; bits[55]:0x2000
// args: bits[18]:0x800; bits[41]:0x200000000; bits[55]:0x100000
// args: bits[18]:0x15555; bits[41]:0x200; bits[55]:0x800000000000
// args: bits[18]:0x80; bits[41]:0x1000; bits[55]:0x40000
// args: bits[18]:0x2; bits[41]:0x20; bits[55]:0x8000
// args: bits[18]:0x20000; bits[41]:0x40000000; bits[55]:0x4000
// args: bits[18]:0x20000; bits[41]:0x800000; bits[55]:0x2000000000
// args: bits[18]:0x4000; bits[41]:0x8; bits[55]:0x400000000
// args: bits[18]:0x2; bits[41]:0x80000; bits[55]:0x40000
// args: bits[18]:0x3ffff; bits[41]:0x1; bits[55]:0x302fc4da604c84
// args: bits[18]:0x100; bits[41]:0x80000; bits[55]:0x40000000
// args: bits[18]:0x20000; bits[41]:0x6bbd58d62f; bits[55]:0x200000000000
// args: bits[18]:0x3ffff; bits[41]:0x8000; bits[55]:0x1000
// args: bits[18]:0x2aaaa; bits[41]:0x22049a64de; bits[55]:0x8000000000
// args: bits[18]:0x3ffff; bits[41]:0x1d9a6ba9188; bits[55]:0x400000000
// args: bits[18]:0x20000; bits[41]:0xe6a18dfb8d; bits[55]:0x4000000000000
// args: bits[18]:0x15555; bits[41]:0x1fb44a402ea; bits[55]:0x100000000000
// args: bits[18]:0x20000; bits[41]:0xffffffffff; bits[55]:0x100000000
// args: bits[18]:0x10; bits[41]:0x8000000; bits[55]:0x200000000
// args: bits[18]:0x4; bits[41]:0x0; bits[55]:0x8000000000000
// args: bits[18]:0x10000; bits[41]:0x200000000; bits[55]:0x8
// args: bits[18]:0x800; bits[41]:0x200000000; bits[55]:0x20
// args: bits[18]:0x2; bits[41]:0x100; bits[55]:0x200000
// args: bits[18]:0x2; bits[41]:0x100; bits[55]:0x800000
// args: bits[18]:0x2000; bits[41]:0x80000000; bits[55]:0x400000
// args: bits[18]:0x2aaaa; bits[41]:0x4000000000; bits[55]:0x2000000
// args: bits[18]:0x40; bits[41]:0x1; bits[55]:0x200000
// args: bits[18]:0x20000; bits[41]:0x800000000; bits[55]:0x100000000000
// args: bits[18]:0x15555; bits[41]:0x2000000; bits[55]:0x0
// args: bits[18]:0x20; bits[41]:0x200000000; bits[55]:0x1000000000
// args: bits[18]:0x100; bits[41]:0x8000000; bits[55]:0x400000
// args: bits[18]:0x2; bits[41]:0x400; bits[55]:0x40000000000000
// args: bits[18]:0x20; bits[41]:0xefdf3fb968; bits[55]:0x1000000000000
// args: bits[18]:0x20000; bits[41]:0x80; bits[55]:0x800
// args: bits[18]:0x10; bits[41]:0x1738cb984df; bits[55]:0x20000000
// args: bits[18]:0x15555; bits[41]:0x40000000; bits[55]:0x800
// args: bits[18]:0x0; bits[41]:0x1000000; bits[55]:0x20000000
// args: bits[18]:0x800; bits[41]:0x20; bits[55]:0x10000000
// args: bits[18]:0x800; bits[41]:0x85ceff6fee; bits[55]:0x40000000000000
// args: bits[18]:0x400; bits[41]:0x10000000000; bits[55]:0x20000000000000
// args: bits[18]:0x100; bits[41]:0x8000; bits[55]:0x10000000
// args: bits[18]:0x38cc0; bits[41]:0x10000000; bits[55]:0x200
// args: bits[18]:0x2aaaa; bits[41]:0x100; bits[55]:0x100000000000
// args: bits[18]:0x400; bits[41]:0x4000; bits[55]:0x4
// args: bits[18]:0x15555; bits[41]:0x800000000; bits[55]:0x2000
// args: bits[18]:0x1; bits[41]:0x31101baa27; bits[55]:0x0
// args: bits[18]:0x200; bits[41]:0x80000; bits[55]:0x400000000
// args: bits[18]:0x20000; bits[41]:0x400000; bits[55]:0x1000000
// args: bits[18]:0x4000; bits[41]:0x80000; bits[55]:0x200000
// args: bits[18]:0x400; bits[41]:0x100000; bits[55]:0x400000000
// args: bits[18]:0x80; bits[41]:0xaaaaaaaaaa; bits[55]:0x10000000
// args: bits[18]:0x2aaaa; bits[41]:0x1744318472e; bits[55]:0x8000000000
// args: bits[18]:0x800; bits[41]:0x1bc09001122; bits[55]:0x40
// args: bits[18]:0x1ffff; bits[41]:0x2; bits[55]:0x10000
// args: bits[18]:0x8000; bits[41]:0x15555555555; bits[55]:0x2cf711026d7bf3
// args: bits[18]:0x2000; bits[41]:0x20000; bits[55]:0x20000
// args: bits[18]:0x4; bits[41]:0x10; bits[55]:0x1000000000000
// args: bits[18]:0x2aaaa; bits[41]:0x2000; bits[55]:0x40000000000
// args: bits[18]:0x20000; bits[41]:0x20000000; bits[55]:0x800000000000
// args: bits[18]:0x40; bits[41]:0x200; bits[55]:0x8
// args: bits[18]:0x800; bits[41]:0xff35ebe53d; bits[55]:0x200
// args: bits[18]:0x0; bits[41]:0x1000000000; bits[55]:0x20000000
// args: bits[18]:0x2aaaa; bits[41]:0x80000000; bits[55]:0x1000
// args: bits[18]:0x10000; bits[41]:0x8000000000; bits[55]:0x16e42eab62706f
// args: bits[18]:0x19e0c; bits[41]:0x80000; bits[55]:0x8000
// args: bits[18]:0x4; bits[41]:0x1000000000; bits[55]:0x55555555555555
// args: bits[18]:0x20; bits[41]:0x8000000000; bits[55]:0x200000000000
// args: bits[18]:0x8; bits[41]:0xa8298d373c; bits[55]:0x1143c173aa5199
// args: bits[18]:0x10; bits[41]:0x10000000000; bits[55]:0x55555555555555
// args: bits[18]:0x4000; bits[41]:0xabb2d11f77; bits[55]:0x80000000000
// args: bits[18]:0x4; bits[41]:0x80000000; bits[55]:0x200000
// args: bits[18]:0x1ffff; bits[41]:0x200; bits[55]:0x2000000000000
// args: bits[18]:0x4; bits[41]:0x4000; bits[55]:0x2dc1e4f972ecd5
// args: bits[18]:0x1000; bits[41]:0x4000000000; bits[55]:0x20
// args: bits[18]:0x1ffff; bits[41]:0x2000; bits[55]:0x200000000000
// args: bits[18]:0x8; bits[41]:0x1000; bits[55]:0x41d09d1ac751ff
// args: bits[18]:0x200; bits[41]:0x4000000000; bits[55]:0x4689b330db04fd
// args: bits[18]:0x1; bits[41]:0x100; bits[55]:0x8000
// args: bits[18]:0x200; bits[41]:0x109184e74d4; bits[55]:0x1000000000
// args: bits[18]:0x800; bits[41]:0x20000000; bits[55]:0x40000000000000
// args: bits[18]:0x8; bits[41]:0x4b31f85eac; bits[55]:0x4ddd30ebb2c4d4
// args: bits[18]:0x1ffff; bits[41]:0x1000; bits[55]:0x40000000000000
// args: bits[18]:0x40; bits[41]:0x200000; bits[55]:0x40
// args: bits[18]:0x10; bits[41]:0x800; bits[55]:0x4000000000
// args: bits[18]:0x4; bits[41]:0x1f4450098b1; bits[55]:0x4000000
// args: bits[18]:0x80; bits[41]:0x100000; bits[55]:0x8000
// args: bits[18]:0x8; bits[41]:0x10000000000; bits[55]:0x2
// args: bits[18]:0x10000; bits[41]:0x80000000; bits[55]:0x10000000
// args: bits[18]:0x8000; bits[41]:0x15555555555; bits[55]:0x800
// args: bits[18]:0x3ebed; bits[41]:0x8; bits[55]:0x40
// args: bits[18]:0x31079; bits[41]:0x1000000000; bits[55]:0x100000000000
// args: bits[18]:0x2000; bits[41]:0x1000; bits[55]:0x400000000
// args: bits[18]:0x1000; bits[41]:0x8000000000; bits[55]:0x2000000000
// args: bits[18]:0x20000; bits[41]:0x40; bits[55]:0x1000
// args: bits[18]:0x10000; bits[41]:0x0; bits[55]:0x2aaaaaaaaaaaaa
// args: bits[18]:0x10000; bits[41]:0x15555555555; bits[55]:0x2d4897e63d7d44
// args: bits[18]:0x2; bits[41]:0xaaaaaaaaaa; bits[55]:0x200000000
// args: bits[18]:0x400; bits[41]:0x400000; bits[55]:0x40000000
// args: bits[18]:0x1ffff; bits[41]:0x8000000; bits[55]:0x80
// args: bits[18]:0x400; bits[41]:0x1000; bits[55]:0x8a383912be432
// args: bits[18]:0x40; bits[41]:0x400000000; bits[55]:0x2000000000000
// args: bits[18]:0x8; bits[41]:0x200000000; bits[55]:0x10000
// args: bits[18]:0x10000; bits[41]:0x8; bits[55]:0x800000000
// args: bits[18]:0x200; bits[41]:0x4000000000; bits[55]:0x3fffffffffffff
// args: bits[18]:0x1000; bits[41]:0x4000; bits[55]:0x4000000000
// args: bits[18]:0x8000; bits[41]:0x80000000; bits[55]:0x800000
// args: bits[18]:0x0; bits[41]:0x0; bits[55]:0x1000000000000
// args: bits[18]:0x1279e; bits[41]:0x10; bits[55]:0x400
// args: bits[18]:0x0; bits[41]:0x8000000; bits[55]:0x200
// args: bits[18]:0x10000; bits[41]:0x800000; bits[55]:0x200000
// args: bits[18]:0x80; bits[41]:0x10; bits[55]:0x200000000
// args: bits[18]:0x2000; bits[41]:0x200000; bits[55]:0x36ba729e3b258d
// args: bits[18]:0x40; bits[41]:0x8000000000; bits[55]:0x2000000
// args: bits[18]:0x4000; bits[41]:0x100000000; bits[55]:0x20000
// args: bits[18]:0x20; bits[41]:0x200000000; bits[55]:0x40000000000
// args: bits[18]:0x400; bits[41]:0x4000000; bits[55]:0x700b3bc523a9dd
// args: bits[18]:0x100; bits[41]:0x40000000; bits[55]:0x4000000000000
// args: bits[18]:0x1000; bits[41]:0x40000000; bits[55]:0x2000000000000
// args: bits[18]:0x0; bits[41]:0x4ba4fceadc; bits[55]:0x4
// args: bits[18]:0x10000; bits[41]:0x40000; bits[55]:0x8
// args: bits[18]:0x1; bits[41]:0x1ffffffffff; bits[55]:0x4
// args: bits[18]:0x1000; bits[41]:0x1a3047fcb02; bits[55]:0x8000
// args: bits[18]:0x200; bits[41]:0x10000000000; bits[55]:0x58d33d57c589a9
// args: bits[18]:0x10; bits[41]:0x400; bits[55]:0x400
// args: bits[18]:0x2aaaa; bits[41]:0x4000000000; bits[55]:0x8000000000
// args: bits[18]:0x800; bits[41]:0x800000000; bits[55]:0x40
// args: bits[18]:0x1ffff; bits[41]:0x800000000; bits[55]:0x40000000000
// args: bits[18]:0x1; bits[41]:0x19bc0c98973; bits[55]:0x80000000
// args: bits[18]:0x15555; bits[41]:0x80000; bits[55]:0x100000
// args: bits[18]:0x1; bits[41]:0x10000; bits[55]:0x1000000000000
// args: bits[18]:0x10; bits[41]:0x200; bits[55]:0x40000000000
// args: bits[18]:0x15555; bits[41]:0x400000; bits[55]:0x4000
// args: bits[18]:0x2aaaa; bits[41]:0x8000000; bits[55]:0x55555555555555
// args: bits[18]:0x40; bits[41]:0x4000; bits[55]:0x400
// args: bits[18]:0x800; bits[41]:0x8000; bits[55]:0x40000000000
// args: bits[18]:0x20000; bits[41]:0x100; bits[55]:0x2000000000
// args: bits[18]:0x80; bits[41]:0x80000; bits[55]:0x2000000
// args: bits[18]:0x1000; bits[41]:0x10000000; bits[55]:0x26e7f9daf44beb
// args: bits[18]:0x1a188; bits[41]:0x8; bits[55]:0x2
// args: bits[18]:0x1; bits[41]:0x4000000; bits[55]:0x72ea2b760c5371
// args: bits[18]:0xf0b4; bits[41]:0x80000; bits[55]:0x2000000000000
// args: bits[18]:0x40; bits[41]:0x80000; bits[55]:0x2
// args: bits[18]:0x1ffff; bits[41]:0x8000000000; bits[55]:0x10000000000000
// args: bits[18]:0x40; bits[41]:0x1000000; bits[55]:0x10000000
// args: bits[18]:0x20000; bits[41]:0x1; bits[55]:0x18322d81ac80d8
// args: bits[18]:0x2c4eb; bits[41]:0x400; bits[55]:0x2000
// args: bits[18]:0x2; bits[41]:0x2000; bits[55]:0x1000000000000
// args: bits[18]:0x1000; bits[41]:0xf03bd630af; bits[55]:0x0
// args: bits[18]:0x4; bits[41]:0x1ffffffffff; bits[55]:0x80000
// args: bits[18]:0x1000; bits[41]:0x10000; bits[55]:0x400000000
// args: bits[18]:0x800; bits[41]:0x0; bits[55]:0x3a80a3aebd26ed
// args: bits[18]:0x1000; bits[41]:0x8000; bits[55]:0x10000000000
// args: bits[18]:0x2000; bits[41]:0xea59fe543; bits[55]:0x2aaaaaaaaaaaaa
// args: bits[18]:0x1000; bits[41]:0x20; bits[55]:0x40000000000000
// args: bits[18]:0x1; bits[41]:0x400; bits[55]:0x7fffffffffffff
// args: bits[18]:0x800; bits[41]:0x8; bits[55]:0x7b9e3674b1f359
// args: bits[18]:0x0; bits[41]:0x100000; bits[55]:0x8000000000000
// args: bits[18]:0x1ed30; bits[41]:0x11fcdf34c2; bits[55]:0x1c4a64643f4e0f
// args: bits[18]:0x10; bits[41]:0x80; bits[55]:0x8000000
// args: bits[18]:0x1ffff; bits[41]:0x100000; bits[55]:0x40000000000
// args: bits[18]:0x800; bits[41]:0x100000000; bits[55]:0x20000000000
// args: bits[18]:0x4; bits[41]:0x8; bits[55]:0x55555555555555
// args: bits[18]:0x100; bits[41]:0x10; bits[55]:0x100000
// args: bits[18]:0x200; bits[41]:0x800000; bits[55]:0x7d351efb608b09
// args: bits[18]:0xffd8; bits[41]:0x0; bits[55]:0x100000
// args: bits[18]:0x3c635; bits[41]:0x4000; bits[55]:0x800000
// args: bits[18]:0x4; bits[41]:0x40000; bits[55]:0x682575f946e2da
// args: bits[18]:0x40; bits[41]:0x4; bits[55]:0x1
// args: bits[18]:0x2; bits[41]:0x110ecc2e343; bits[55]:0x10
// args: bits[18]:0x1ffff; bits[41]:0x2000000; bits[55]:0x100000000000
// args: bits[18]:0x154c1; bits[41]:0x80; bits[55]:0x40000000000
// args: bits[18]:0x4000; bits[41]:0x4; bits[55]:0x8000000
// args: bits[18]:0x2; bits[41]:0x1122c509b39; bits[55]:0x20
// args: bits[18]:0x1ffff; bits[41]:0x4000; bits[55]:0x1000000000000
// args: bits[18]:0x17ec4; bits[41]:0x400000000; bits[55]:0x200000
// args: bits[18]:0x10000; bits[41]:0x800000000; bits[55]:0x800000
// args: bits[18]:0x40; bits[41]:0x2000000; bits[55]:0x20000000000
// args: bits[18]:0x2; bits[41]:0x80000; bits[55]:0x10
// args: bits[18]:0x2aaaa; bits[41]:0x20; bits[55]:0x4000000000
// args: bits[18]:0x222be; bits[41]:0x8000; bits[55]:0x10000000000000
// args: bits[18]:0x800; bits[41]:0x8dd589a41e; bits[55]:0x10
// args: bits[18]:0x10000; bits[41]:0x200; bits[55]:0x200000000
// args: bits[18]:0x10000; bits[41]:0x4000000000; bits[55]:0x2000000
// args: bits[18]:0x200; bits[41]:0x10000; bits[55]:0x8000000000000
// args: bits[18]:0x3ddb9; bits[41]:0x40; bits[55]:0x100
// args: bits[18]:0x1ffff; bits[41]:0x1000000000; bits[55]:0x400
// args: bits[18]:0x8000; bits[41]:0x1; bits[55]:0x20000
// args: bits[18]:0x2000; bits[41]:0x1000000000; bits[55]:0x8000
// args: bits[18]:0x0; bits[41]:0x10000; bits[55]:0x2
// args: bits[18]:0x4; bits[41]:0x200000000; bits[55]:0x55555555555555
// args: bits[18]:0x2a423; bits[41]:0x17523f5da3; bits[55]:0x80
// args: bits[18]:0x80; bits[41]:0x100000; bits[55]:0x180ac75677e5b8
// args: bits[18]:0x40; bits[41]:0x80; bits[55]:0x10
// args: bits[18]:0x2000; bits[41]:0x10000000; bits[55]:0x1000000
// args: bits[18]:0x100; bits[41]:0x2000000000; bits[55]:0x1
// args: bits[18]:0x4; bits[41]:0x400000; bits[55]:0x10000000000
// args: bits[18]:0x2; bits[41]:0xaaaaaaaaaa; bits[55]:0x8
// args: bits[18]:0x1000; bits[41]:0x200000; bits[55]:0x40000000000
// args: bits[18]:0x800; bits[41]:0x40000000; bits[55]:0x400000
// args: bits[18]:0x3d453; bits[41]:0x800; bits[55]:0x4
// args: bits[18]:0x1ffff; bits[41]:0x4000; bits[55]:0x10000000000000
// args: bits[18]:0x1000; bits[41]:0x800000000; bits[55]:0x10000
// args: bits[18]:0x3697f; bits[41]:0x800000; bits[55]:0x400000000
// args: bits[18]:0x2000; bits[41]:0x4000000; bits[55]:0x4000000000
// args: bits[18]:0x3ffff; bits[41]:0x1000000; bits[55]:0x200000
// args: bits[18]:0x8000; bits[41]:0x80000; bits[55]:0x80
// args: bits[18]:0x1; bits[41]:0x400000; bits[55]:0x200
// args: bits[18]:0x1000; bits[41]:0x100000; bits[55]:0x80
// args: bits[18]:0x40; bits[41]:0x80; bits[55]:0x80
// args: bits[18]:0x8; bits[41]:0x15555555555; bits[55]:0x100
// args: bits[18]:0x4000; bits[41]:0x20000; bits[55]:0x2000000000
// args: bits[18]:0x4000; bits[41]:0x1ffffffffff; bits[55]:0x8000
// args: bits[18]:0x10; bits[41]:0x2000000000; bits[55]:0x20000000000
// args: bits[18]:0x200; bits[41]:0x2; bits[55]:0x1
// args: bits[18]:0x1ffff; bits[41]:0x17d5fd998f0; bits[55]:0x8
// args: bits[18]:0x2000; bits[41]:0x40000000; bits[55]:0x100000000
// args: bits[18]:0x10000; bits[41]:0x10000000000; bits[55]:0x200000
// args: bits[18]:0x3ffff; bits[41]:0x1000; bits[55]:0x1000000000000
// args: bits[18]:0x10; bits[41]:0x100; bits[55]:0x20000
// args: bits[18]:0x0; bits[41]:0x80000000; bits[55]:0x2
// args: bits[18]:0x16bd2; bits[41]:0x1; bits[55]:0x20000000
// args: bits[18]:0x15555; bits[41]:0x8; bits[55]:0x1
// args: bits[18]:0x4; bits[41]:0x1; bits[55]:0x200000000
// args: bits[18]:0x1ffff; bits[41]:0x200000; bits[55]:0x20
// args: bits[18]:0x3ffff; bits[41]:0x2000; bits[55]:0x10000000000000
// args: bits[18]:0x100; bits[41]:0x8000; bits[55]:0x8000000
// args: bits[18]:0x400; bits[41]:0x1000000; bits[55]:0x23160236681325
// args: bits[18]:0x10; bits[41]:0xffffffffff; bits[55]:0x72cc2ed6abcd38
// args: bits[18]:0x100; bits[41]:0x4; bits[55]:0x18a1c230e55bc6
// args: bits[18]:0x800; bits[41]:0x2000000000; bits[55]:0x80000000000
// args: bits[18]:0x800; bits[41]:0x8000; bits[55]:0x20000000000000
// args: bits[18]:0x8000; bits[41]:0x800000000; bits[55]:0x400000000000
// args: bits[18]:0x2aaaa; bits[41]:0x400000000; bits[55]:0x4000000000000
// args: bits[18]:0x20000; bits[41]:0x400000; bits[55]:0x200
// args: bits[18]:0x10; bits[41]:0x40000000; bits[55]:0x20000000
// args: bits[18]:0x3ffff; bits[41]:0x20000; bits[55]:0x20
// args: bits[18]:0x15555; bits[41]:0x4000000000; bits[55]:0x200000000000
// args: bits[18]:0x15555; bits[41]:0x2; bits[55]:0x800000000000
// args: bits[18]:0x14a7; bits[41]:0x2000000; bits[55]:0x20
// args: bits[18]:0x15555; bits[41]:0x20; bits[55]:0x40
// args: bits[18]:0x100; bits[41]:0x40000000; bits[55]:0x20000
// args: bits[18]:0x100; bits[41]:0x0; bits[55]:0x10000000
// args: bits[18]:0x80; bits[41]:0x1000000000; bits[55]:0x1000000
// args: bits[18]:0x400; bits[41]:0x40000000; bits[55]:0x1000000000
// args: bits[18]:0x200; bits[41]:0x0; bits[55]:0x10000000
// args: bits[18]:0x40; bits[41]:0x4000000000; bits[55]:0x4000000
// args: bits[18]:0x40; bits[41]:0x1000000; bits[55]:0x1000000000000
// args: bits[18]:0x408e; bits[41]:0x1f512c9e87b; bits[55]:0x40000000000
// args: bits[18]:0x200; bits[41]:0x100000000; bits[55]:0x3fffffffffffff
// args: bits[18]:0x200; bits[41]:0x200; bits[55]:0x200000000
// args: bits[18]:0x40; bits[41]:0x17d1639281f; bits[55]:0x40
// args: bits[18]:0x4; bits[41]:0x1ffffffffff; bits[55]:0xce12aaff27243
// args: bits[18]:0x2829; bits[41]:0x20; bits[55]:0x40000000
// args: bits[18]:0x3ffff; bits[41]:0x1ffffffffff; bits[55]:0x10000
// args: bits[18]:0x80; bits[41]:0x1ffffffffff; bits[55]:0x10000000000
// args: bits[18]:0x100; bits[41]:0xc32d7a1e08; bits[55]:0x200000
// args: bits[18]:0x8; bits[41]:0x20000; bits[55]:0x1000000000
// args: bits[18]:0x3ffff; bits[41]:0xee7edd0978; bits[55]:0x100000
// args: bits[18]:0x1ffff; bits[41]:0x100000000; bits[55]:0x20
// args: bits[18]:0x8; bits[41]:0x40000000; bits[55]:0x4
// args: bits[18]:0x2; bits[41]:0xaaaaaaaaaa; bits[55]:0x80000000000
// args: bits[18]:0x10000; bits[41]:0x8000000000; bits[55]:0x400000
// args: bits[18]:0x2aaaa; bits[41]:0x20000000; bits[55]:0x20000000
// args: bits[18]:0x8; bits[41]:0x8; bits[55]:0x1000000
// args: bits[18]:0x2aaaa; bits[41]:0x680fe420df; bits[55]:0x3cf9c628713d99
// args: bits[18]:0x15555; bits[41]:0x200; bits[55]:0x80
// args: bits[18]:0x8; bits[41]:0x0; bits[55]:0x400000000000
// args: bits[18]:0x40; bits[41]:0x1000; bits[55]:0x7fffffffffffff
// args: bits[18]:0x80; bits[41]:0x400; bits[55]:0x6f3022dcc63bad
// args: bits[18]:0x2; bits[41]:0x400; bits[55]:0x10000000000000
// args: bits[18]:0x1ffff; bits[41]:0x800000000; bits[55]:0x400000000000
// args: bits[18]:0xe81; bits[41]:0x4000000000; bits[55]:0x10000000000000
// args: bits[18]:0x20; bits[41]:0x200; bits[55]:0x8000000000000
// args: bits[18]:0x2; bits[41]:0x2000000; bits[55]:0x4000
// args: bits[18]:0x400; bits[41]:0x80; bits[55]:0x2000000000000
// args: bits[18]:0x1000; bits[41]:0x400000000; bits[55]:0x10000000
// args: bits[18]:0x2aaaa; bits[41]:0x4000000000; bits[55]:0x60b016ed0f55cc
// args: bits[18]:0x1000; bits[41]:0x0; bits[55]:0x200000
// args: bits[18]:0x1; bits[41]:0x200000000; bits[55]:0x2000000000
// args: bits[18]:0x40; bits[41]:0x0; bits[55]:0x10
// args: bits[18]:0x15555; bits[41]:0x200; bits[55]:0x10000000000
// args: bits[18]:0x2aaaa; bits[41]:0x10000000; bits[55]:0x400000
// args: bits[18]:0x20; bits[41]:0x8000; bits[55]:0x8000000000000
// args: bits[18]:0x200; bits[41]:0x10000000; bits[55]:0x200000
// args: bits[18]:0x1000; bits[41]:0x4000; bits[55]:0x800000000
// args: bits[18]:0x10; bits[41]:0x3c938040b1; bits[55]:0x20000000000
// args: bits[18]:0x1; bits[41]:0x20000; bits[55]:0xc0665bac07636
// args: bits[18]:0x2aaaa; bits[41]:0x100000000; bits[55]:0x2aaaaaaaaaaaaa
// args: bits[18]:0x800; bits[41]:0x20000; bits[55]:0x200000000000
// args: bits[18]:0x4000; bits[41]:0x1000000000; bits[55]:0x8000000000000
// args: bits[18]:0x4000; bits[41]:0x1000000000; bits[55]:0x100000000000
// args: bits[18]:0x20; bits[41]:0x80000; bits[55]:0x400000
// args: bits[18]:0x10000; bits[41]:0x800000000; bits[55]:0x20000000000
// args: bits[18]:0x20000; bits[41]:0xffffffffff; bits[55]:0x20000000000000
// args: bits[18]:0x800; bits[41]:0x40000000; bits[55]:0x80000
// args: bits[18]:0x3ffff; bits[41]:0x20000; bits[55]:0x8000
fn main(x331: u18, x332: u41, x333: u55) -> u55 {
    let x334: u55 = one_hot_sel((u4:0xf), [x333, x333, x333, x333]);
    let x335: u55 = (x334) | ((x331 as u55));
    x335
}


