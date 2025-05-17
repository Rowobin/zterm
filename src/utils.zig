const std = @import("std");

// execute ANSI escape codes
// https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797?permalink_comment_id=3857871
pub inline fn escapeCode(fmt: []const u8, args: anytype) []const u8{
    const str = "\x1b[" ++ fmt;
    var buf: [32]u8 = undefined;
    return std.fmt.bufPrint(&buf, str, args) catch unreachable;
}

// reset text color and styles
pub inline fn resetAll() []const u8 {
    return escapeCode("0m", .{});
}