const std = @import("std");
const zterm = @import("zterm");

pub fn main() !void {
    std.debug.print("This text is being printed at position (0,0)!", .{});

    zterm.cursor.print.moveTo(5,20);
    std.debug.print("This text is being printed at line 5, column 20!", .{});
    std.debug.print("{s}This text is being printed at line 10, column 20!", .{
        zterm.cursor.moveTo(10, 20)
    });

    zterm.cursor.print.moveDown(3);
    std.debug.print("This text is printed at line 13!", .{});

    std.debug.print("{s}{s}This text is printed at line 14!", .{
        zterm.cursor.moveDown(1),
        zterm.cursor.moveLeft(32)
    });

    zterm.cursor.print.moveDownStart(1);
    std.debug.print("This text is printed at line 15!", .{});

    zterm.cursor.print.moveToCol(40);
    std.debug.print("This text starts at column 40!\n", .{});
}