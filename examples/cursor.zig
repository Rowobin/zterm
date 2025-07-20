const std = @import("std");
const zterm = @import("zterm");

pub fn main() !void {
    zterm.clear.print.screen();

    zterm.cursor.print.reset();
    std.debug.print("This cursor position was reset to the top-left of the screen!", .{});

    zterm.cursor.print.moveTo(2,20);
    std.debug.print("This text is being printed at line 2, column 20!", .{});
    std.debug.print("{s}This text is being printed at line 5, column 20!", .{
        zterm.cursor.moveTo(5, 20)
    });

    zterm.cursor.print.moveDown(3);
    std.debug.print("This text is printed at line 8!", .{});

    std.debug.print("{s}{s}This text is printed at line 9!", .{
        zterm.cursor.moveDown(1),
        zterm.cursor.moveLeft(31)
    });

    zterm.cursor.print.moveDownStart(1);
    std.debug.print("This text is printed at line 10!", .{});

    zterm.cursor.print.moveToCol(40);
    std.debug.print("This text starts at column 40!\n", .{});
}