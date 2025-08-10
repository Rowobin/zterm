const std = @import("std");
const zterm = @import("zterm");

//
// [CLEAR_SCREEN]
// This example shows how to the clear screen function
//

pub fn main() void {
    // basically a copy of the "clear" command
    std.debug.print("{s}", .{zterm.clear.screen()});
    zterm.cursor.print.reset(); // place cursor at the top
}