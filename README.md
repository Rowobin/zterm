> [!WARNING]
> This library is a work in progress, bugs and incomplete features are to be expected.

# zterm
A low-level terminal manipulation library for Unix systems written in Zig. Built as a learning exercise, taking inspiration from [mibu](https://github.com/xyaman/mibu).

> Tested with zig 0.14.1

## Features

- Style (bold, italic, underline, etc)
- 8-16 colors
- True Color (24-bit RGB)
- Cursor manipulation (position, hide, show)
- Enable/disable raw mode
- Clear screen

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
- cursor
- raw_mode