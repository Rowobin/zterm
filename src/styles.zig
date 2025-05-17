const std = @import("std");
const utils = @import("main.zig").utils;

pub const bold = struct {
    pub inline fn set() []const u8{
        return utils.escapeCode("1m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.escapeCode("22m", .{});
    }
};

pub const dim = struct {
    pub inline fn set() []const u8{
        return utils.escapeCode("2m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.escapeCode("22m", .{});
    }
};

pub const italic = struct {
    pub inline fn set() []const u8{
        return utils.escapeCode("3m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.escapeCode("23m", .{});
    }
};

pub const underline = struct {
    pub inline fn set() []const u8{
        return utils.escapeCode("4m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.escapeCode("24m", .{});
    }
};

pub const blinking = struct {
    pub inline fn set() []const u8{
        return utils.escapeCode("5m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.escapeCode("25m", .{});
    }
};

pub const reverse = struct {
    pub inline fn set() []const u8{
        return utils.escapeCode("7m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.escapeCode("27m", .{});
    }
};

pub const hidden = struct {
    pub inline fn set() []const u8{
        return utils.escapeCode("8m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.escapeCode("28m", .{});
    }
};

pub const strikethrough = struct {
    pub inline fn set() []const u8{
        return utils.escapeCode("9m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.escapeCode("29m", .{});
    }
};