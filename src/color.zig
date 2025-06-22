const std = @import("std");
const utils = @import("main.zig").utils;

// default terminal colors, should be supported in pretty much any terminal
pub const codes = enum(u8) {
    black = 0, 
    red, 
    green, 
    yellow, 
    blue, 
    magenta, 
    cyan, 
    white,
    default
};

// these methods print the escape codes, executing them
pub const print = struct {
    // set color foreground based on color code enum
    pub fn fg(code: codes) void {
       utils.printEscapeCode("38;5;{d}m", .{@intFromEnum(code)});
    }
    
    // set color background based on color code enum
    pub fn bg(code: codes) void {
       utils.printEscapeCode("48;5;{d}m", .{@intFromEnum(code)});
    }

    // set color foreground based on RGB (0-255) inputs
    pub fn fgRGB(r: u8, g: u8, b: u8) void {
        utils.printEscapeCode("38;2;{d};{d};{d}m", .{ r, g, b });
    }

    // set color background based on RGB (0-255) inputs
    pub fn bgRGB(r: u8, g: u8, b: u8) void {
        utils.printEscapeCode("48;2;{d};{d};{d}m", .{ r, g, b });
    }

    // set color foreround based on the 256 color system
    pub fn fg256(color: u8) void {
        utils.printEscapeCode("38;5;{d}m", .{color});
    }

    // set color background based on the 256 color system
    pub fn bg256(color: u8) void {
        utils.printEscapeCode("48;5;{d}m", .{color});
    }
};

// these methods return the escape codes

// set color foreground based on color code enum
pub inline fn fg(code: codes) []const u8 {
    return utils.returnEscapeCode("38;5;{d}m", .{@intFromEnum(code)});
}

// set color background based on color code enum
pub inline fn bg(code: codes) []const u8 {
    return utils.returnEscapeCode("48;5;{d}m", .{@intFromEnum(code)});
}

// set color foreground based on RGB (0-255) inputs
pub inline fn fgRGB(r: u8, g: u8, b: u8) []const u8 {
    return utils.returnEscapeCode("38;2;{d};{d};{d}m", .{ r, g, b });
}

// set color background based on RGB (0-255) inputs
pub inline fn bgRGB(r: u8, g: u8, b: u8) []const u8 {
    return utils.returnEscapeCode("48;2;{d};{d};{d}m", .{ r, g, b });
}

// set color foreround based on the 256 color system
pub inline fn fg256(color: u8) []const u8 {
     return utils.returnEscapeCode("38;5;{d}m", .{color});
}

// set color background based on the 256 color system
pub inline fn bg256(color: u8) []const u8 {
    return utils.returnEscapeCode("48;5;{d}m", .{color});
}