const std = @import("std");
const zterm = @import("zterm");

//
// [TEXT_EFFECTS]
// This examples shows how to style text with colors and styles
//

pub fn main() !void {
    // Title
    //
    std.debug.print("{s}{s}{s}{s}Welcome to the text effects example.{s}\n\n", .{
        zterm.color.fg(.black),
        zterm.color.bg(.white),
        zterm.styles.bold.set(),
        zterm.styles.underline.set(),
        zterm.utils.resetAll() // use resetAll to reset all colors and styles
    });

    // Using color codes
    //
    std.debug.print("{s}{s}{s}You can use pre-determined colors to customize your text.{s}\n\n", .{
        zterm.color.fg(.white),
        zterm.color.bg(.red),
        zterm.styles.underline.set(),
        zterm.utils.resetAll()
    });

    std.debug.print("{s}{s}This is black{s}\n", .{
        zterm.color.fg(.black),
        zterm.color.bg(.white),
        zterm.utils.resetAll()
    });

    std.debug.print("{s}This is red\n", .{zterm.color.fg(.red)});
    std.debug.print("{s}This is green\n", .{zterm.color.fg(.green)});
    std.debug.print("{s}This is yellow\n", .{zterm.color.fg(.yellow)});
    std.debug.print("{s}This is blue\n", .{zterm.color.fg(.blue)});
    std.debug.print("{s}This is magenta\n", .{zterm.color.fg(.magenta)});
    std.debug.print("{s}This is cyan\n", .{zterm.color.fg(.cyan)});
    std.debug.print("{s}This is white\n", .{zterm.color.fg(.white)});
    std.debug.print("{s}This is default{s}\n", .{zterm.color.fg(.white), zterm.utils.resetAll()});

    // Using RGB and 256
    //
    std.debug.print("\n{s}{s}{s}You can use RGB/256 colors to customize your text.{s}\n\n", .{
        zterm.color.fg(.white),
        zterm.color.bg(.blue),
        zterm.styles.underline.set(),
        zterm.utils.resetAll()
    });

    std.debug.print("{s}{s}RGB(003, 004, 094){s}RGB(000, 119, 182){s}RGB(000, 180, 216){s}RGB(144, 224, 239){s}RGB(202, 240, 248){s}\n", .{
        zterm.color.fg(.white),
        zterm.color.bgRGB(3, 4, 94),
        zterm.color.bgRGB(0, 119, 182),
        zterm.color.bgRGB(0, 180, 216),
        zterm.color.bgRGB(144, 224, 239),
        zterm.color.bgRGB(202, 240, 248),
        zterm.utils.resetAll()
    });

    std.debug.print("{s}{s}RGB(047, 062, 070){s}RGB(053, 079, 082){s}RGB(082, 121, 111){s}RGB(132, 169, 140){s}RGB(202, 210, 197){s}\n", .{
        zterm.color.fg(.white),
        zterm.color.bgRGB(47, 62, 70),
        zterm.color.bgRGB(53, 79, 82),
        zterm.color.bgRGB(82, 121, 111),
        zterm.color.bgRGB(132, 169, 140),
        zterm.color.bgRGB(202, 210, 197),
        zterm.utils.resetAll()
    });

    std.debug.print("{s}{s}RGB(069, 009, 002){s}RGB(165, 056, 096){s}RGB(218, 098, 125){s}RGB(255, 165, 171){s}RGB(249, 219, 189){s}\n", .{
        zterm.color.fg(.white),
        zterm.color.bgRGB(69, 9, 32),
        zterm.color.bgRGB(165, 56, 96),
        zterm.color.bgRGB(218, 98, 125),
        zterm.color.bgRGB(255, 165, 171),
        zterm.color.bgRGB(249, 219, 189),
        zterm.utils.resetAll()
    });

    std.debug.print("{s}{s}RGB(053, 080, 112){s}RGB(109, 089, 122){s}RGB(181, 101, 118){s}RGB(229, 107, 111){s}RGB(234, 172, 139){s}\n\n", .{
        zterm.color.fg(.white),
        zterm.color.bgRGB(53, 80, 112),
        zterm.color.bgRGB(109, 89, 122),
        zterm.color.bgRGB(181, 101, 118),
        zterm.color.bgRGB(229, 107, 111),
        zterm.color.bgRGB(234, 172, 139),
        zterm.utils.resetAll()
    });

    var n: u8 = 0;
    while(n <= 255) : (n+=1){
        std.debug.print("{s}{d:0>3}|", .{zterm.color.fg256(n), n});
        if(n == 255) break;
    }
    std.debug.print("{s}\n\n", .{zterm.utils.resetAll()});

    // Using styles
    //
    std.debug.print("{s}{s}{s}You can use styles to customize your text.{s}\n\n", .{
        zterm.color.bg(.yellow),
        zterm.color.fg(.white),
        zterm.styles.underline.set(),
        zterm.utils.resetAll()
    });

    std.debug.print("{s}This is bold{s}\n", .{
        zterm.styles.bold.set(),
        zterm.styles.bold.reset(),
    });

    std.debug.print("{s}This is dim{s}\n", .{
        zterm.styles.dim.set(),
        zterm.styles.dim.reset(),
    });

    std.debug.print("{s}This is italic{s}\n", .{
        zterm.styles.italic.set(),
        zterm.styles.italic.reset(),
    });

    std.debug.print("{s}This is underline{s}\n", .{
        zterm.styles.underline.set(),
        zterm.styles.underline.reset(),
    });

    std.debug.print("{s}This is blinking{s}\n", .{
        zterm.styles.blinking.set(),
        zterm.styles.blinking.reset(),
    });

    std.debug.print("{s}This is reverse{s}\n", .{
        zterm.styles.reverse.set(),
        zterm.styles.reverse.reset(),
    });

    std.debug.print("{s}This is hidden{s}\n", .{
        zterm.styles.hidden.set(),
        zterm.styles.hidden.reset(),
    });

    std.debug.print("{s}This is strikethrough{s}\n", .{
        zterm.styles.strikethrough.set(),
        zterm.styles.strikethrough.reset(),
    });
}
