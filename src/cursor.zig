const std = @import("std");
const utils = @import("main.zig").utils;

// these methods print the escape codes, executing them

pub const print = struct {
    // reset cursor position to 0,0
    pub fn reset() void {
        utils.printEscapeCode("H", .{});
    }

    // move cursor to line x column y
    pub fn moveTo(x: u16, y: u16) void {
        utils.printEscapeCode("{};{}H", .{x, y});
    }

    // move cursor up y lines
    pub fn moveUp(y: u16) void {
        utils.printEscapeCode("{}A", .{y});
    }

    // move cursor down y lines
    pub fn moveDown(y: u16) void {
        utils.printEscapeCode("{}B", .{y});
    }

    // move cursor right x lines
    pub fn moveRight(x: u16) void {
        utils.printEscapeCode("{}C", .{x});
    }

    // move cursor left x lines
    pub fn moveLeft(x: u16) void {
        utils.printEscapeCode("{}D", .{x});
    }

    // move cursor to the beginning of next line, y lines down
    pub fn moveDownStart(y: u16) void {
        utils.printEscapeCode("{}E", .{y});
    }

    // move cursor to the beginning of previous line, y lines up
    pub fn moveUpStart(y: u16) void {
        utils.printEscapeCode("{}F", .{y});
    }

    // move cursor to column x
    pub fn moveToCol(x: u16) void {
        utils.printEscapeCode("{}G", .{x});
    }

    // hide cursor
    pub fn hide() void {
        utils.printEscapeCode("?25l", .{});
    }

    // show cursor
    pub fn show() void {
        utils.printEscapeCode("?25h", .{});
    }
};

// these methods return the escape codes

// reset cursor position to 0,0
pub inline fn reset() []const u8 {
    return utils.returnEscapeCode("H", .{});
}

// move cursor to line x column y
pub inline fn moveTo(x: u16, y: u16) []const u8 {
    return utils.returnEscapeCode("{};{}H", .{x, y});
}

// move cursor up y lines
pub inline fn moveUp(y: u16) []const u8 {
    return utils.returnEscapeCode("{}A", .{y});
}

// move cursor down y lines
pub inline fn moveDown(y: u16) []const u8 {
    return utils.returnEscapeCode("{}B", .{y});
}

// move cursor right x lines
pub inline fn moveRight(x: u16) []const u8 {
    return utils.returnEscapeCode("{}C", .{x});
}

// move cursor left x lines
pub inline fn moveLeft(x: u16) []const u8 {
    return utils.returnEscapeCode("{}D", .{x});
}

// move cursor to the beginning of next line, y lines down
pub inline fn moveDownStart(y: u16) []const u8 {
    return utils.returnEscapeCode("{}E", .{y});
}

// move cursor to the beginning of previous line, y lines up
pub inline fn moveUpStart(y: u16) []const u8 {
    return utils.returnEscapeCode("{}F", .{y});
}

// move cursor to column x
pub inline fn moveToCol(x: u16) []const u8 {
    return utils.returnEscapeCode("{}G", .{x});
}

// hide cursor
pub inline fn hide() []const u8 {
    return utils.returnEscapeCode("?25l", .{});
}

// show cursor
pub inline fn show() []const u8 {
    return utils.returnEscapeCode("?25h", .{});
}

// get cursor position in the format [row; column]
// requires raw mode to be enabled
pub fn getPosition() ![2]u16 {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    try stdout.writeAll(utils.returnEscapeCode("6n", .{}));

    var pos = [2]u16{0,0};
    var buffer: [32]u8 = undefined;
    var index: usize = 0;
    var pos_i: u8 = 0;

    while(index < buffer.len-1) : (index += 1){
        buffer[index] = try stdin.readByte();

        if(std.ascii.isDigit(buffer[index])){
            pos[pos_i] = pos[pos_i] * 10 + (buffer[index] - '0');
        }

        if(buffer[index] == 'R'){
            index += 1;
            break;
        }
        if(buffer[index] == ';') pos_i += 1;
    }
    buffer[index] = 0;

    return pos;
}