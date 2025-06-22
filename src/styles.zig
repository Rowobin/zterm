const std = @import("std");
const utils = @import("main.zig").utils;

// these methods print the escape codes, executing them

pub const print = struct {
    pub const bold = struct {
        pub inline fn set() void{
            utils.printEscapeCode("1m", .{});
        }
        pub inline fn reset() void{
            utils.printEscapeCode("22m", .{});
        }
    };

    pub const dim = struct {
        pub inline fn set() void{
            utils.printEscapeCode("2m", .{});
        }
        pub inline fn reset() void{
            utils.printEscapeCode("22m", .{});
        }
    };

    pub const italic = struct {
        pub inline fn set() void{
            utils.printEscapeCode("3m", .{});
        }
        pub inline fn reset() void{
            utils.printEscapeCode("23m", .{});
        }
    };

    pub const underline = struct {
        pub inline fn set() void{
            utils.printEscapeCode("4m", .{});
        }
        pub inline fn reset() void{
            utils.printEscapeCode("24m", .{});
        }
    };

    pub const blinking = struct {
        pub inline fn set() void{
            utils.printEscapeCode("5m", .{});
        }
        pub inline fn reset() void{
            utils.printEscapeCode("25m", .{});
        }
    };

    pub const reverse = struct {
        pub inline fn set() void{
            utils.printEscapeCode("7m", .{});
        }
        pub inline fn reset() void{
            utils.printEscapeCode("27m", .{});
        }
    };

    pub const hidden = struct {
        pub inline fn set() void{
            utils.printEscapeCode("8m", .{});
        }
        pub inline fn reset() void{
            utils.printEscapeCode("28m", .{});
        }
    };

    pub const strikethrough = struct {
        pub inline fn set() void{
            utils.printEscapeCode("9m", .{});
        }
        pub inline fn reset() void{
            utils.printEscapeCode("29m", .{});
        }
    };
};

// these methods return the escape codes

pub const bold = struct {
    pub inline fn set() []const u8{
        return utils.returnEscapeCode("1m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.returnEscapeCode("22m", .{});
    }
};

pub const dim = struct {
    pub inline fn set() []const u8{
        return utils.returnEscapeCode("2m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.returnEscapeCode("22m", .{});
    }
};

pub const italic = struct {
    pub inline fn set() []const u8{
        return utils.returnEscapeCode("3m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.returnEscapeCode("23m", .{});
    }
};

pub const underline = struct {
    pub inline fn set() []const u8{
        return utils.returnEscapeCode("4m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.returnEscapeCode("24m", .{});
    }
};

pub const blinking = struct {
    pub inline fn set() []const u8{
        return utils.returnEscapeCode("5m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.returnEscapeCode("25m", .{});
    }
};

pub const reverse = struct {
    pub inline fn set() []const u8{
        return utils.returnEscapeCode("7m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.returnEscapeCode("27m", .{});
    }
};

pub const hidden = struct {
    pub inline fn set() []const u8{
        return utils.returnEscapeCode("8m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.returnEscapeCode("28m", .{});
    }
};

pub const strikethrough = struct {
    pub inline fn set() []const u8{
        return utils.returnEscapeCode("9m", .{});
    }
    pub inline fn reset() []const u8{
        return utils.returnEscapeCode("29m", .{});
    }
};