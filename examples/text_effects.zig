const std = @import("std");
const zterm = @import("zterm");

//
// [TEXT_EFFECTS]
// This examples shows how to style text with colors and styles
//

pub fn main() !void {
    zterm.color.print.fg(.red);
    std.debug.print("Hello, world! (red text)\n", .{});
    zterm.utils.print.resetAll();

    zterm.color.print.bg(.blue);
    std.debug.print("Hello, world! (blue background)\n\n", .{});
    zterm.utils.print.resetAll();

    std.debug.print("{s}Hello, world! (red text){s}\n", .{
        zterm.color.fg(.red),
        zterm.utils.resetAll()
    });

    std.debug.print("{s}Hello, world! (blue background){s}\n\n", .{
        zterm.color.bg(.blue),
        zterm.utils.resetAll()
    });

    zterm.color.print.fgRGB(69, 123, 157);
    std.debug.print("Hello, world! (RGB(169, 123, 157) text)\n", .{});
    zterm.utils.print.resetAll();

    std.debug.print("{s}Hello, world! (RGB(230, 57, 70) background){s}\n\n", .{
        zterm.color.bgRGB(230, 57, 70),
        zterm.utils.resetAll()
    });

    zterm.style.print.blinking.set();
    std.debug.print("Hello, world! (blinking)\n", .{});
    zterm.style.print.blinking.reset();

    zterm.style.print.bold.set();
    std.debug.print("Hello, world! (bold)\n", .{});
    zterm.utils.print.resetAll();

    zterm.style.print.dim.set();
    std.debug.print("Hello, world! (dim)\n", .{});
    zterm.utils.print.resetAll();

    zterm.style.print.hidden.set();
    std.debug.print("Hello, world! (hidden)\n", .{});
    zterm.utils.print.resetAll();

    std.debug.print("{s}Hello, world! (italic){s}\n", .{
        zterm.style.italic.set(),
        zterm.style.italic.reset()
    });

    std.debug.print("{s}Hello, world! (reverse){s}\n", .{
        zterm.style.reverse.set(),
        zterm.utils.resetAll()
    });

    std.debug.print("{s}Hello, world! (strikethrough){s}\n", .{
        zterm.style.strikethrough.set(),
        zterm.utils.resetAll()
    });

    std.debug.print("{s}Hello, world! (underline){s}\n", .{
        zterm.style.underline.set(),
        zterm.utils.resetAll()
    });
}
