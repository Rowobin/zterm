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

    zterm.styles.print.blinking.set();
    std.debug.print("Hello, world! (blinking)\n", .{});
    zterm.styles.print.blinking.reset();

    zterm.styles.print.bold.set();
    std.debug.print("Hello, world! (bold)\n", .{});
    zterm.utils.print.resetAll();

    zterm.styles.print.dim.set();
    std.debug.print("Hello, world! (dim)\n", .{});
    zterm.utils.print.resetAll();

    zterm.styles.print.hidden.set();
    std.debug.print("Hello, world! (hidden)\n", .{});
    zterm.utils.print.resetAll();

    std.debug.print("{s}Hello, world! (italic){s}\n", .{
        zterm.styles.italic.set(),
        zterm.styles.italic.reset()
    });

    std.debug.print("{s}Hello, world! (reverse){s}\n", .{
        zterm.styles.reverse.set(),
        zterm.utils.resetAll()
    });

    std.debug.print("{s}Hello, world! (strikethrough){s}\n", .{
        zterm.styles.strikethrough.set(),
        zterm.utils.resetAll()
    });

    std.debug.print("{s}Hello, world! (underline){s}\n", .{
        zterm.styles.underline.set(),
        zterm.utils.resetAll()
    });
}
