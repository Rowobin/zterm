> [!WARNING]
> This library is a work in progress, bugs and incomplete feeatures are to be expected.

# zterm
A low-level terminal manipulation library written in Zig. Built as an learning exercise, taking inspiration from [mibu](https://github.com/xyaman/mibu).

> Tested with zig 0.14.0 and 0.15.0-dev.565+8e72a2528

## Features

- Style (bold, italic, underline, etc).
- 8-16 colors.
- True Color (24-bit RGB).

## How to use

Add library as a dependency in `build.zig.zon` file with the 
following command:
```bash
zig fetch --save git+https://github.com/Rowobin/zterm
```

Add the following to the`build.zig` file:
```zig
const zterm_dep = b.dependency("zterm", .{
    .target = target,
    .optimize = optimize,
});

exe.root_module.addImport("zterm", zterm_dep.module("zterm"));
```

Now the library can be used:
```zig
const std = @import("std");
const zterm = @import("zterm");

pub fn main() void {
    std.debug.print("{s}Hello World in red!\n", .{
        zterm.color.fg(.red)
    });
}
```

## Building examples

You can build any example with:
```zig
> zig build example_name
```

List of examples:
- text_effects