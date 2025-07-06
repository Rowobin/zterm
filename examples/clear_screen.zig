const std = @import("std");
const zterm = @import("zterm");

pub fn main() void {
    // basically a copy of the "clear" command
    std.debug.print("{s}", .{zterm.clear.screen()});
    zterm.cursor.print.reset(); // place cursor at the top
}