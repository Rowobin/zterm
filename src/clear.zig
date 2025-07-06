const std = @import("std");
const utils = @import("main.zig").utils;

// these methods print the escape codes, executing them

pub const print = struct {
    // clear from cursor to end of screen
    pub fn cursorToEnd() void {
        utils.printEscapeCode("0J", .{});
    }

    // clear from from cursor to beginning of screen
    pub fn cursorToBeginning() void {
        utils.printEscapeCode("1J", .{});
    }
    
    // clear entire screen
    pub fn screen() void{
        utils.printEscapeCode("2J", .{});
    }

    // clear from cursor to end of line
    pub fn cursorToEndLine() void {
        utils.printEscapeCode("0K", .{});
    }

    // clear from cursor to beginning of line
    pub fn cursorToBeginningLine() void {
        utils.printEscapeCode("1K", .{});
    }

    // clear entire line
    pub fn line() void {
        utils.printEscapeCode("2K", .{});
    }
};

// these methods return the escape codes

// clear from cursor to end of screen
pub inline fn cursorToEnd() []const u8 {
    return utils.returnEscapeCode("0J", .{});
}

// clear from from cursor to beginning of screen
pub inline fn cursorToBeginning() []const u8{
    return utils.returnEscapeCode("1J", .{});
}

// clear entire screen
pub inline fn screen() []const u8{
    return utils.returnEscapeCode("2J", .{});
}

// clear from cursor to end of line
pub inline fn cursorToEndLine() []const u8{
    return utils.returnEscapeCode("0K", .{});
}

// clear from cursor to end of line
pub inline fn cursorToBeginningLine() []const u8{
    return utils.returnEscapeCode("1K", .{});
}

// clear entire line
pub inline fn line() []const u8{
    return utils.returnEscapeCode("2K", .{});
}