# zterm
A single-file low-level terminal manipulation library written in Zig. Built as a learning exercise.

If you find any bugs or other issues, please let me know. If you think there's features that I should add, suggestions and PRs are always appreciated!

> Tested with zig 0.14.1 (plans to update to 0.15.2 soon)

> Tested on MacOS, Linux and Windows

## Features

- Style (bold, italic, underline, etc)
- 8-16 colors
- True Color (24-bit RGB)
- Cursor manipulation (position, hide, show)
- Enable/disable raw mode
- Clear screen
- Alternate Screen Support
- Abstractions for mouse and keyboard input handling

## How to use

Because this is a single-file library, you can just add the file "zterm.zig" to your project. You can also use `zig fetch`.

### Zig fetch

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
- clear_screen
- game_base
- alt_screen
- mouse_input

## Credits

I got the idea to build this library from [mibu](https://github.com/xyaman/mibu).
