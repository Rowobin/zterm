const std = @import("std");

// *******************************
// CUSTOMIZE TEXT COLOR
// *******************************

pub const color = struct {
    pub const codes = enum(u8) { black = 0, red, green, yellow, blue, magenta, cyan, white, default };

    pub const print = struct {
        pub fn fg(code: codes) void {
            utils.printEscapeCode("38;5;{d}m", .{@intFromEnum(code)});
        }

        pub fn bg(code: codes) void {
            utils.printEscapeCode("48;5;{d}m", .{@intFromEnum(code)});
        }

        pub fn fgRGB(r: u8, g: u8, b: u8) void {
            utils.printEscapeCode("38;2;{d};{d};{d}m", .{ r, g, b });
        }

        pub fn bgRGB(r: u8, g: u8, b: u8) void {
            utils.printEscapeCode("48;2;{d};{d};{d}m", .{ r, g, b });
        }

        pub fn fg256(color256: u8) void {
            utils.printEscapeCode("38;5;{d}m", .{color256});
        }

        pub fn bg256(color256: u8) void {
            utils.printEscapeCode("48;5;{d}m", .{color256});
        }
    };

    pub inline fn fg(code: codes) []const u8 {
        return utils.returnEscapeCode("38;5;{d}m", .{@intFromEnum(code)});
    }

    pub inline fn bg(code: codes) []const u8 {
        return utils.returnEscapeCode("48;5;{d}m", .{@intFromEnum(code)});
    }

    pub inline fn fgRGB(r: u8, g: u8, b: u8) []const u8 {
        return utils.returnEscapeCode("38;2;{d};{d};{d}m", .{ r, g, b });
    }

    pub inline fn bgRGB(r: u8, g: u8, b: u8) []const u8 {
        return utils.returnEscapeCode("48;2;{d};{d};{d}m", .{ r, g, b });
    }

    pub inline fn fg256(color256: u8) []const u8 {
        return utils.returnEscapeCode("38;5;{d}m", .{color256});
    }

    pub inline fn bg256(color256: u8) []const u8 {
        return utils.returnEscapeCode("48;5;{d}m", .{color256});
    }
};

// *******************************
// CUSTOMIZE TEXT STYLE
// *******************************

pub const style = struct {
    pub const print = struct {
        pub const bold = struct {
            pub inline fn set() void {
                utils.printEscapeCode("1m", .{});
            }
            pub inline fn reset() void {
                utils.printEscapeCode("22m", .{});
            }
        };

        pub const dim = struct {
            pub inline fn set() void {
                utils.printEscapeCode("2m", .{});
            }
            pub inline fn reset() void {
                utils.printEscapeCode("22m", .{});
            }
        };

        pub const italic = struct {
            pub inline fn set() void {
                utils.printEscapeCode("3m", .{});
            }
            pub inline fn reset() void {
                utils.printEscapeCode("23m", .{});
            }
        };

        pub const underline = struct {
            pub inline fn set() void {
                utils.printEscapeCode("4m", .{});
            }
            pub inline fn reset() void {
                utils.printEscapeCode("24m", .{});
            }
        };

        pub const blinking = struct {
            pub inline fn set() void {
                utils.printEscapeCode("5m", .{});
            }
            pub inline fn reset() void {
                utils.printEscapeCode("25m", .{});
            }
        };

        pub const reverse = struct {
            pub inline fn set() void {
                utils.printEscapeCode("7m", .{});
            }
            pub inline fn reset() void {
                utils.printEscapeCode("27m", .{});
            }
        };

        pub const hidden = struct {
            pub inline fn set() void {
                utils.printEscapeCode("8m", .{});
            }
            pub inline fn reset() void {
                utils.printEscapeCode("28m", .{});
            }
        };

        pub const strikethrough = struct {
            pub inline fn set() void {
                utils.printEscapeCode("9m", .{});
            }
            pub inline fn reset() void {
                utils.printEscapeCode("29m", .{});
            }
        };
    };

    pub const bold = struct {
        pub inline fn set() []const u8 {
            return utils.returnEscapeCode("1m", .{});
        }
        pub inline fn reset() []const u8 {
            return utils.returnEscapeCode("22m", .{});
        }
    };

    pub const dim = struct {
        pub inline fn set() []const u8 {
            return utils.returnEscapeCode("2m", .{});
        }
        pub inline fn reset() []const u8 {
            return utils.returnEscapeCode("22m", .{});
        }
    };

    pub const italic = struct {
        pub inline fn set() []const u8 {
            return utils.returnEscapeCode("3m", .{});
        }
        pub inline fn reset() []const u8 {
            return utils.returnEscapeCode("23m", .{});
        }
    };

    pub const underline = struct {
        pub inline fn set() []const u8 {
            return utils.returnEscapeCode("4m", .{});
        }
        pub inline fn reset() []const u8 {
            return utils.returnEscapeCode("24m", .{});
        }
    };

    pub const blinking = struct {
        pub inline fn set() []const u8 {
            return utils.returnEscapeCode("5m", .{});
        }
        pub inline fn reset() []const u8 {
            return utils.returnEscapeCode("25m", .{});
        }
    };

    pub const reverse = struct {
        pub inline fn set() []const u8 {
            return utils.returnEscapeCode("7m", .{});
        }
        pub inline fn reset() []const u8 {
            return utils.returnEscapeCode("27m", .{});
        }
    };

    pub const hidden = struct {
        pub inline fn set() []const u8 {
            return utils.returnEscapeCode("8m", .{});
        }
        pub inline fn reset() []const u8 {
            return utils.returnEscapeCode("28m", .{});
        }
    };

    pub const strikethrough = struct {
        pub inline fn set() []const u8 {
            return utils.returnEscapeCode("9m", .{});
        }
        pub inline fn reset() []const u8 {
            return utils.returnEscapeCode("29m", .{});
        }
    };
};

// *******************************
// CLEAR METHODS
// *******************************

pub const clear = struct {
    pub const print = struct {
        pub fn cursorToEnd() void {
            utils.printEscapeCode("0J", .{});
        }

        pub fn cursorToBeginning() void {
            utils.printEscapeCode("1J", .{});
        }

        pub fn screen() void {
            utils.printEscapeCode("2J", .{});
        }

        pub fn cursorToEndLine() void {
            utils.printEscapeCode("0K", .{});
        }

        pub fn cursorToBeginningLine() void {
            utils.printEscapeCode("1K", .{});
        }

        pub fn line() void {
            utils.printEscapeCode("2K", .{});
        }
    };

    pub inline fn cursorToEnd() []const u8 {
        return utils.returnEscapeCode("0J", .{});
    }

    pub inline fn cursorToBeginning() []const u8 {
        return utils.returnEscapeCode("1J", .{});
    }

    pub inline fn screen() []const u8 {
        return utils.returnEscapeCode("2J", .{});
    }

    pub inline fn cursorToEndLine() []const u8 {
        return utils.returnEscapeCode("0K", .{});
    }

    pub inline fn cursorToBeginningLine() []const u8 {
        return utils.returnEscapeCode("1K", .{});
    }

    pub inline fn line() []const u8 {
        return utils.returnEscapeCode("2K", .{});
    }
};

// *******************************
// CURSOR METHODS
// *******************************

pub const cursor = struct {
    pub const print = struct {
        pub fn reset() void {
            utils.printEscapeCode("H", .{});
        }

        pub fn moveTo(x: u16, y: u16) void {
            utils.printEscapeCode("{};{}H", .{ x, y });
        }

        pub fn moveUp(y: u16) void {
            utils.printEscapeCode("{}A", .{y});
        }

        pub fn moveDown(y: u16) void {
            utils.printEscapeCode("{}B", .{y});
        }

        pub fn moveRight(x: u16) void {
            utils.printEscapeCode("{}C", .{x});
        }

        pub fn moveLeft(x: u16) void {
            utils.printEscapeCode("{}D", .{x});
        }

        pub fn moveDownStart(y: u16) void {
            utils.printEscapeCode("{}E", .{y});
        }

        pub fn moveUpStart(y: u16) void {
            utils.printEscapeCode("{}F", .{y});
        }

        pub fn moveToCol(x: u16) void {
            utils.printEscapeCode("{}G", .{x});
        }

        pub fn hide() void {
            utils.printEscapeCode("?25l", .{});
        }

        pub fn show() void {
            utils.printEscapeCode("?25h", .{});
        }
    };

    pub inline fn reset() []const u8 {
        return utils.returnEscapeCode("H", .{});
    }

    pub inline fn moveTo(x: u16, y: u16) []const u8 {
        return utils.returnEscapeCode("{};{}H", .{ x, y });
    }

    pub inline fn moveUp(y: u16) []const u8 {
        return utils.returnEscapeCode("{}A", .{y});
    }

    pub inline fn moveDown(y: u16) []const u8 {
        return utils.returnEscapeCode("{}B", .{y});
    }

    pub inline fn moveRight(x: u16) []const u8 {
        return utils.returnEscapeCode("{}C", .{x});
    }

    pub inline fn moveLeft(x: u16) []const u8 {
        return utils.returnEscapeCode("{}D", .{x});
    }

    pub inline fn moveDownStart(y: u16) []const u8 {
        return utils.returnEscapeCode("{}E", .{y});
    }

    pub inline fn moveUpStart(y: u16) []const u8 {
        return utils.returnEscapeCode("{}F", .{y});
    }

    pub inline fn moveToCol(x: u16) []const u8 {
        return utils.returnEscapeCode("{}G", .{x});
    }

    pub inline fn hide() []const u8 {
        return utils.returnEscapeCode("?25l", .{});
    }

    pub inline fn show() []const u8 {
        return utils.returnEscapeCode("?25h", .{});
    }

    // get cursor position in the format [row; column]
    // requires raw mode to be enabled
    pub fn getPosition() ![2]u16 {
        const stdin = std.io.getStdIn().reader();
        const stdout = std.io.getStdOut().writer();

        try stdout.writeAll(utils.returnEscapeCode("6n", .{}));

        var pos = [2]u16{ 0, 0 };
        var buffer: [32]u8 = undefined;
        var index: usize = 0;
        var pos_i: u8 = 0;

        while (index < buffer.len - 1) : (index += 1) {
            buffer[index] = try stdin.readByte();

            if (std.ascii.isDigit(buffer[index])) {
                pos[pos_i] = pos[pos_i] * 10 + (buffer[index] - '0');
            }

            if (buffer[index] == 'R') {
                index += 1;
                break;
            }
            if (buffer[index] == ';') pos_i += 1;
        }
        buffer[index] = 0;

        return pos;
    }
};

// *********************
// ALT SCREEN
// *********************

pub const altScreen = struct {
    pub var enabled: bool = false;
    pub const print = struct {
        pub fn enable() void {
            utils.printEscapeCode("?1049h", .{});
            altScreen.enabled = true;
        }

        pub fn disable() void {
            utils.printEscapeCode("?1049l", .{});
            altScreen.enabled = false;
        }
    };

    pub inline fn enable() []const u8 {
        altScreen.enabled = true;
        return utils.returnEscapeCode("?1049h", .{});
    }

    pub inline fn disable() []const u8 {
        altScreen.enabled = false;
        return utils.returnEscapeCode("?1049l", .{});
    }

    pub inline fn isEnabled() bool {
        return altScreen.enabled;
    }
};
// *******************************
// RAW INPUT MODE
// *******************************

pub const rawMode = struct {
    pub fn enable() !std.posix.termios {
        const orig_termios: std.posix.termios = try std.posix.tcgetattr(std.posix.STDIN_FILENO);

        var raw: std.posix.termios = orig_termios;

        // terminal flags
        raw.lflag.ECHO = false; // echo user input
        raw.lflag.ICANON = false; // read user input byte by byte
        raw.lflag.ISIG = false; // disable SIGINT and SIGSTP signals
        raw.lflag.IEXTEN = false; // disable CTRL-V
        raw.iflag.IXON = false; // disable CTRL-Q and CTRL-S
        raw.iflag.ICRNL = false; // convert carriage returns into new lines
        raw.iflag.BRKINT = false; // disable break condition from sending SIGINT
        raw.iflag.INPCK = false; // parity checking
        raw.iflag.ISTRIP = false; // strips the 8th bit of each byte
        raw.oflag.OPOST = false; // output processing
        raw.cflag.CSIZE = .CS8; // set character size to 8bits per byte

        raw.cc[@intFromEnum(std.posix.V.MIN)] = 0; // read can return after reading 0 bytes
        raw.cc[@intFromEnum(std.posix.V.TIME)] = 1; // read waits 1/10 of a second before returning

        try std.posix.tcsetattr(std.posix.STDIN_FILENO, std.posix.TCSA.FLUSH, raw);
        return orig_termios;
    }

    pub fn disable(orig_termios: std.posix.termios) !void {
        try std.posix.tcsetattr(std.posix.STDIN_FILENO, std.posix.TCSA.FLUSH, orig_termios);
    }

    pub fn getNextInput() input {
        var c: [32]u8 = undefined;
        c[0] = 0;
        const bytes_read = std.posix.read(std.posix.STDIN_FILENO, &c) catch unreachable;

        var ret: input = .{
            .value = c[0],
            .key = .NONE,
        };

        if (bytes_read == 0) return ret;

        if (bytes_read == 1) {
            // printable characters
            if (std.ascii.isPrint(c[0])) {
                ret.key = .PRINTABLE;
                if (std.ascii.isAlphanumeric(c[0])) {
                    ret.key = .ALPHANUM;
                }
            }

            // CTRL inputs
            if (c[0] >= 1 and c[0] <= 26) ret.key = @enumFromInt(c[0]);

            // control characters
            switch (c[0]) {
                std.ascii.control_code.cr => ret.key = .ENTER,
                std.ascii.control_code.ht => ret.key = .TAB,
                std.ascii.control_code.bs => ret.key = .BACKSPACE,
                std.ascii.control_code.del => ret.key = .DELETE,
                else => {},
            }
        } else if (c[0] == 27 and c[1] == '[') {
            if (bytes_read == 3) {
                switch (c[2]) {
                    'A' => ret.key = .ARROW_UP,
                    'B' => ret.key = .ARROW_DOWN,
                    'C' => ret.key = .ARROW_RIGHT,
                    'D' => ret.key = .ARROW_LEFT,
                    'H' => ret.key = .HOME,
                    'F' => ret.key = .END,
                    else => {},
                }
            } else if (bytes_read == 4 and c[3] == '~') {
                switch (c[2]) {
                    '1' => ret.key = .HOME,
                    '3' => ret.key = .DELETE,
                    '4' => ret.key = .END,
                    '5' => ret.key = .PAGE_UP,
                    '6' => ret.key = .PAGE_DOWN,
                    '7' => ret.key = .HOME,
                    '8' => ret.key = .END,
                    else => {},
                }
            }
        }

        return ret;
    }

    pub const input = struct {
        value: u8,
        key: key_type,
    };

    pub const key_type = enum(u8) {
        NONE = 0,

        CTRL_A = 1,
        CTRL_B = 2,
        CTRL_C = 3,
        CTRL_D = 4,
        CTRL_E = 5,
        CTRL_F = 6,
        CTRL_G = 7,
        CTRL_H = 8,
        CTRL_I = 9, // is TAB
        CTRL_J = 10,
        CTRL_K = 11,
        CTRL_L = 12,
        CTRL_M = 13, // is ENTER
        CTRL_N = 14,
        CTRL_O = 15,
        CTRL_P = 16,
        CTRL_Q = 17,
        CTRL_R = 18,
        CTRL_S = 19,
        CTRL_T = 20,
        CTRL_U = 21,
        CTRL_V = 22,
        CTRL_W = 23,
        CTRL_X = 24,
        CTRL_Y = 25,
        CTRL_Z = 26,

        TAB,
        ENTER,
        BACKSPACE,
        DELETE,

        ARROW_UP,
        ARROW_DOWN,
        ARROW_RIGHT,
        ARROW_LEFT,

        HOME,
        END,
        PAGE_UP,
        PAGE_DOWN,

        ALPHANUM,
        PRINTABLE,
    };
};

// *******************************
// UTILS
// *******************************

pub const utils = struct {
    // https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797?permalink_comment_id=3857871
    pub inline fn returnEscapeCode(fmt: []const u8, args: anytype) []const u8 {
        const str = "\x1b[" ++ fmt;
        var buf: [32]u8 = undefined;
        return std.fmt.bufPrint(&buf, str, args) catch unreachable;
    }

    pub inline fn printEscapeCode(fmt: []const u8, args: anytype) void {
        const str = "\x1b[" ++ fmt;
        std.debug.print(str, args);
    }

    pub const print = struct {
        pub fn resetAll() void {
            printEscapeCode("0m", .{});
        }
    };

    pub inline fn resetAll() []const u8 {
        return returnEscapeCode("0m", .{});
    }

    // get terminal size in the format [rows_num; columns_num]
    // requires raw mode to be enabled
    pub fn getTerminalSize() ![2]u16 {
        var winsizestruct: std.posix.winsize = .{ .row = 0, .col = 0, .xpixel = 0, .ypixel = 0 };

        var winsize = [2]u16{ 0, 0 };

        const err = std.posix.system.ioctl(std.io.getStdOut().handle, std.posix.T.IOCGWINSZ, @intFromPtr(&winsizestruct));
        if (std.posix.errno(err) == .SUCCESS) {
            winsize[0] = winsizestruct.row;
            winsize[1] = winsizestruct.col;
        }

        return winsize;
    }
};
