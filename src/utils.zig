const std = @import("std");
const builtin = @import("builtin");

// execute ANSI escape codes
// https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797?permalink_comment_id=3857871
pub inline fn returnEscapeCode(fmt: []const u8, args: anytype) []const u8{
    const str = "\x1b[" ++ fmt;
    var buf: [32]u8 = undefined;
    return std.fmt.bufPrint(&buf, str, args) catch unreachable;
}

pub inline fn printEscapeCode(fmt: []const u8, args: anytype) void{
    const str = "\x1b[" ++ fmt;
    std.debug.print(str, args);
}

// reset text color and styles
pub const print = struct {
    pub fn resetAll() void {
        printEscapeCode("0m", .{});
    }
};

pub inline fn resetAll() []const u8 {
    return returnEscapeCode("0m", .{});
}