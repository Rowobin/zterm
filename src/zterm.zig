const std = @import("std");
const windows = std.os.windows;
const builtin = @import("builtin");

// *******************************
// welcome to zterm - a zig library for terminal manipulation
// *******************************

// *******************************
// error types
// *******************************

pub const ZtermError = error{
    UnsupportedPlatform,
    TerminalSetupFailed,
    InputReadFailed,
    WindowsApiError,
    InvalidTimeout,
    CursorPositionFailed,
    TerminalSizeFailed,
};

// *******************************
// configuration
// *******************************

pub const Config = struct {
    timeout_unix: u8 = 1,
    timeout_windows: u32 = 100,
};

var global_config = Config{};

pub fn setConfig(config: Config) ZtermError!void {
    global_config = config;
}

pub fn setTimeout(timeout_ms: u16) ZtermError!void {
    global_config.timeout_unix = if (timeout_ms == 256) 0 else @intCast(timeout_ms / 100);
    global_config.timeout_windows = if (timeout_ms == 256) 0xFFFFFFFF else timeout_ms;
}

pub fn getConfig() Config {
    return global_config;
}

// *******************************
// customize text color
// *******************************

pub const color = struct {
    pub const Codes = enum(u8) {
        black = 0,
        red,
        green,
        yellow,
        blue,
        magenta,
        cyan,
        white,
        default,
    };

    // print functions instantly execute a code
    // other functions return the code to the user
    pub const print = struct {
        // fg() and bg() set colors based on the enum 'Codes'
        pub fn fg(code: Codes) void {
            utils.printEscapeCode("38;5;{d}m", .{@intFromEnum(code)});
        }

        pub fn bg(code: Codes) void {
            utils.printEscapeCode("48;5;{d}m", .{@intFromEnum(code)});
        }

        // fgRgb() and bgRgb() set colors based on the rgb color system
        pub fn fgRgb(r: u8, g: u8, b: u8) void {
            utils.printEscapeCode("38;2;{d};{d};{d}m", .{ r, g, b });
        }

        pub fn bgRgb(r: u8, g: u8, b: u8) void {
            utils.printEscapeCode("48;2;{d};{d};{d}m", .{ r, g, b });
        }

        // fg256() and bg256() set colors based 'true color' system
        pub fn fg256(color256: u8) void {
            utils.printEscapeCode("38;5;{d}m", .{color256});
        }

        pub fn bg256(color256: u8) void {
            utils.printEscapeCode("48;5;{d}m", .{color256});
        }
    };

    // fg() and bg() set colors based on the enum 'Codes'
    // these color codes should be supported in most terminals
    pub inline fn fg(code: Codes) []const u8 {
        return utils.returnEscapeCode("38;5;{d}m", .{@intFromEnum(code)});
    }

    pub inline fn bg(code: Codes) []const u8 {
        return utils.returnEscapeCode("48;5;{d}m", .{@intFromEnum(code)});
    }

    // fgRgb() and bgRgb() set colors based on the rgb color system
    // these color codes should be supported in some (modern) terminals
    pub inline fn fgRgb(r: u8, g: u8, b: u8) []const u8 {
        return utils.returnEscapeCode("38;2;{d};{d};{d}m", .{ r, g, b });
    }

    pub inline fn bgRgb(r: u8, g: u8, b: u8) []const u8 {
        return utils.returnEscapeCode("48;2;{d};{d};{d}m", .{ r, g, b });
    }

    // fg256() and bg256() set colors based 'true color' system
    // these color codes should be supported in most terminals
    pub inline fn fg256(color256: u8) []const u8 {
        return utils.returnEscapeCode("38;5;{d}m", .{color256});
    }

    pub inline fn bg256(color256: u8) []const u8 {
        return utils.returnEscapeCode("48;5;{d}m", .{color256});
    }
};

// *******************************
// customize text style
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
// clear methods
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
// cursor methods
// *******************************

pub const cursor = struct {
    pub const print = struct {
        pub fn reset() void {
            utils.printEscapeCode("H", .{});
        }

        pub fn moveTo(row: u16, col: u16) void {
            utils.printEscapeCode("{};{}H", .{ row, col });
        }

        pub fn moveUp(rows: u16) void {
            utils.printEscapeCode("{}A", .{rows});
        }

        pub fn moveDown(rows: u16) void {
            utils.printEscapeCode("{}B", .{rows});
        }

        pub fn moveRight(cols: u16) void {
            utils.printEscapeCode("{}C", .{cols});
        }

        pub fn moveLeft(cols: u16) void {
            utils.printEscapeCode("{}D", .{cols});
        }

        pub fn moveDownStart(rows: u16) void {
            utils.printEscapeCode("{}E", .{rows});
        }

        pub fn moveUpStart(rows: u16) void {
            utils.printEscapeCode("{}F", .{rows});
        }

        pub fn moveToCol(col: u16) void {
            utils.printEscapeCode("{}G", .{col});
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

    pub inline fn moveTo(row: u16, col: u16) []const u8 {
        return utils.returnEscapeCode("{};{}H", .{ row, col });
    }

    pub inline fn moveUp(rows: u16) []const u8 {
        return utils.returnEscapeCode("{}A", .{rows});
    }

    pub inline fn moveDown(rows: u16) []const u8 {
        return utils.returnEscapeCode("{}B", .{rows});
    }

    pub inline fn moveRight(cols: u16) []const u8 {
        return utils.returnEscapeCode("{}C", .{cols});
    }

    pub inline fn moveLeft(cols: u16) []const u8 {
        return utils.returnEscapeCode("{}D", .{cols});
    }

    pub inline fn moveDownStart(rows: u16) []const u8 {
        return utils.returnEscapeCode("{}E", .{rows});
    }

    pub inline fn moveUpStart(row: u16) []const u8 {
        return utils.returnEscapeCode("{}F", .{row});
    }

    pub inline fn moveToCol(col: u16) []const u8 {
        return utils.returnEscapeCode("{}G", .{col});
    }

    pub inline fn hide() []const u8 {
        return utils.returnEscapeCode("?25l", .{});
    }

    pub inline fn show() []const u8 {
        return utils.returnEscapeCode("?25h", .{});
    }

    pub const CursorPos = struct {
        rows: u16,
        cols: u16,
    };

    // get cursor position
    // requires raw mode to be enabled
    pub fn getPosition() ZtermError!CursorPos {
        const stdout_file = std.fs.File{ .handle = std.posix.STDOUT_FILENO };

        stdout_file.writeAll(utils.returnEscapeCode("6n", .{})) catch return ZtermError.CursorPositionFailed;

        var pos = [2]u16{ 0, 0 };
        var buffer: [32]u8 = undefined;
        var index: usize = 0;
        var pos_i: u8 = 0;

        while (index < buffer.len - 1) : (index += 1) {
            var buf: [1]u8 = undefined;
            const n = std.posix.read(std.posix.STDIN_FILENO, &buf) catch return ZtermError.CursorPositionFailed;
            if (n == 0) return ZtermError.CursorPositionFailed;
            buffer[index] = buf[0];

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

        const ret: CursorPos = .{
            .rows = pos[0],
            .cols = pos[1],
        };
        return ret;
    }
};

// *********************
// alt screen
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
// raw input mode
// *******************************

pub const rawMode = struct {
    pub const TerminalData = union(enum) {
        orig_termios: std.posix.termios,
        orig_terminal: windows.DWORD,
    };

    pub fn enable() ZtermError!TerminalData {
        return switch (builtin.target.os.tag) {
            .macos, .linux => TerminalData{ .orig_termios = try enableUnix() },
            .windows => TerminalData{ .orig_terminal = try enableWindows() },
            else => ZtermError.UnsupportedPlatform,
        };
    }

    pub fn enableUnix() ZtermError!std.posix.termios {
        const orig_termios: std.posix.termios = std.posix.tcgetattr(std.posix.STDIN_FILENO) catch
            return ZtermError.TerminalSetupFailed;

        var raw: std.posix.termios = orig_termios;

        // terminal flags
        raw.lflag.ECHO = false; // echo user input
        raw.lflag.ICANON = false; // read user input byte by byte
        raw.lflag.ISIG = false; // disable sigint and sigstp signals
        raw.lflag.IEXTEN = false; // disable ctrl-v
        raw.iflag.IXON = false; // disable ctrl-q and ctrl-s
        raw.iflag.ICRNL = false; // convert carriage returns into new lines
        raw.iflag.BRKINT = false; // disable break condition from sending sigint
        raw.iflag.INPCK = false; // parity checking
        raw.iflag.ISTRIP = false; // strips the 8th bit of each byte
        raw.oflag.OPOST = false; // output processing
        raw.cflag.CSIZE = .CS8; // set character size to 8bits per byte

        raw.cc[6] = if (global_config.timeout_unix == 0) 1 else 0;
        raw.cc[5] = global_config.timeout_unix;

        std.posix.tcsetattr(std.posix.STDIN_FILENO, .FLUSH, raw) catch
            return ZtermError.TerminalSetupFailed;

        return orig_termios;
    }

    pub fn enableWindows() ZtermError!windows.DWORD {
        const std_handle: windows.HANDLE = windows.GetStdHandle(windows.STD_INPUT_HANDLE) catch
            return ZtermError.WindowsApiError;

        var orig_term: windows.DWORD = undefined;
        if (windows.kernel32.GetConsoleMode(std_handle, &orig_term) == 0) {
            return ZtermError.WindowsApiError;
        }

        var raw: windows.DWORD = orig_term;

        const ENABLE_ECHO_INPUT: u32 = 0x0004;
        const ENABLE_LINE_INPUT: u32 = 0x0002;
        const ENABLE_PROCESSED_INPUT: u32 = 0x0001;
        const ENABLE_MOUSE_INPUT: u32 = 0x0010;
        const ENABLE_INSERT_MODE: u32 = 0x0020;
        const ENABLE_QUICK_EDIT_MODE: u32 = 0x0040;
        const ENABLE_VIRTUAL_TERMINAL_INPUT: u32 = 0x0200;

        raw &= ~(ENABLE_ECHO_INPUT | ENABLE_LINE_INPUT | ENABLE_PROCESSED_INPUT |
            ENABLE_INSERT_MODE | ENABLE_MOUSE_INPUT | ENABLE_QUICK_EDIT_MODE);
        raw |= ENABLE_VIRTUAL_TERMINAL_INPUT;

        if (windows.kernel32.SetConsoleMode(std_handle, raw) == 0) {
            return ZtermError.WindowsApiError;
        }

        if (windows.kernel32.FlushFileBuffers(std_handle) == 0) {
            return ZtermError.WindowsApiError;
        }

        return orig_term;
    }

    pub fn disable(term: TerminalData) ZtermError!void {
        return switch (builtin.target.os.tag) {
            .macos, .linux => {
                std.posix.tcsetattr(std.posix.STDIN_FILENO, .FLUSH, term.orig_termios) catch
                    return ZtermError.TerminalSetupFailed;
            },
            .windows => {
                const std_handle: windows.HANDLE = windows.GetStdHandle(windows.STD_INPUT_HANDLE) catch
                    return ZtermError.WindowsApiError;
                if (windows.kernel32.SetConsoleMode(std_handle, term.orig_terminal) == 0) {
                    return ZtermError.WindowsApiError;
                }
            },
            else => ZtermError.UnsupportedPlatform,
        };
    }

    pub fn enableMouseInput() void {
        utils.printEscapeCode("?1003h", .{});
        utils.printEscapeCode("?1006h", .{});
    }

    pub fn disableMouseInput() void {
        utils.printEscapeCode("?1003l", .{});
        utils.printEscapeCode("?1006l", .{});
    }

    pub fn getNextInput() ZtermError!Input {
        return switch (builtin.target.os.tag) {
            .macos, .linux => getNextInputUnix(),
            .windows => getNextInputWindows(),
            else => ZtermError.UnsupportedPlatform,
        };
    }

    fn getNextInputUnix() ZtermError!Input {
        var c: [32]u8 = undefined;
        c[0] = 0;

        const bytes_read = std.posix.read(std.posix.STDIN_FILENO, &c) catch |err| switch (err) {
            error.WouldBlock => 0,
            else => return ZtermError.InputReadFailed,
        };

        return parseInput(c[0..bytes_read]);
    }

    fn getNextInputWindows() ZtermError!Input {
        const std_handle = windows.GetStdHandle(windows.STD_INPUT_HANDLE) catch
            return ZtermError.WindowsApiError;

        const wait_result = windows.kernel32.WaitForSingleObject(std_handle, global_config.timeout_windows);
        var c: [32]u8 = undefined;
        var bytes_read: usize = 0;

        switch (wait_result) {
            windows.WAIT_OBJECT_0 => {
                var bytes_read_u32: u32 = undefined;
                if (windows.kernel32.ReadFile(std_handle, &c, c.len, &bytes_read_u32, null) == 0) {
                    return ZtermError.InputReadFailed;
                }
                bytes_read = bytes_read_u32;
            },
            windows.WAIT_TIMEOUT => {
                bytes_read = 0;
            },
            else => return ZtermError.InputReadFailed,
        }

        return parseInput(c[0..bytes_read]);
    }

    fn parseInput(buffer: []const u8) Input {
        var ret: Input = .{
            .value = if (buffer.len > 0) buffer[0] else 0,
            .key = .none,
            .mouse = .{
                .button = .none,
                .column = 0,
                .row = 0,
                .shift = false,
                .ctrl = false,
                .meta = false,
                .motion = false,
            },
        };

        if (buffer.len == 0) return ret;

        if (buffer.len == 1) {
            const c = buffer[0];
            if (std.ascii.isPrint(c)) {
                ret.key = .printable;
                if (std.ascii.isAlphanumeric(c)) {
                    ret.key = .alphanum;
                }
            }

            if (c >= 1 and c <= 26) ret.key = @enumFromInt(c);

            switch (c) {
                std.ascii.control_code.cr => ret.key = .enter,
                std.ascii.control_code.ht => ret.key = .tab,
                std.ascii.control_code.bs => ret.key = .backspace,
                std.ascii.control_code.del => ret.key = .delete,
                else => {},
            }
        } else if (buffer.len >= 3 and buffer[0] == '\x1b' and buffer[1] == '[') {
            if (buffer.len == 3) {
                switch (buffer[2]) {
                    'A' => ret.key = .arrow_up,
                    'B' => ret.key = .arrow_down,
                    'C' => ret.key = .arrow_right,
                    'D' => ret.key = .arrow_left,
                    'H' => ret.key = .home,
                    'F' => ret.key = .end,
                    else => {},
                }
            } else if (buffer.len == 4 and buffer[3] == '~') {
                switch (buffer[2]) {
                    '1' => ret.key = .home,
                    '3' => ret.key = .delete,
                    '4' => ret.key = .end,
                    '5' => ret.key = .page_up,
                    '6' => ret.key = .page_down,
                    '7' => ret.key = .home,
                    '8' => ret.key = .end,
                    else => {},
                }
            } else if (buffer.len >= 6 and buffer[2] == '<') {
                ret.key = .mouse;

                const mouse_data = buffer[3 .. buffer.len - 1];
                const last_char = buffer[buffer.len - 1];

                var iter = std.mem.splitAny(u8, mouse_data, ";");
                const b_str = iter.next() orelse return ret;
                const c_str = iter.next() orelse return ret;
                const r_str = iter.next() orelse return ret;

                const b = std.fmt.parseInt(u32, b_str, 10) catch return ret;
                const c = std.fmt.parseInt(u32, c_str, 10) catch return ret;
                const r = std.fmt.parseInt(u32, r_str, 10) catch return ret;

                ret.mouse.column = c;
                ret.mouse.row = r;
                ret.mouse.shift = (b & 4) != 0;
                ret.mouse.meta = (b & 8) != 0;
                ret.mouse.ctrl = (b & 16) != 0;

                if (last_char == 'M') {
                    if (b & 32 != 0) {
                        ret.mouse.motion = true;
                        ret.mouse.button = switch (b & 3) {
                            0 => .left,
                            1 => .middle,
                            2 => .right,
                            else => .none,
                        };
                    } else if (b >= 64) {
                        ret.mouse.motion = false;
                        if (b == 64)
                            ret.mouse.button = .scroll_up
                        else if (b == 65)
                            ret.mouse.button = .scroll_down
                        else
                            ret.mouse.button = .none;
                    } else {
                        ret.mouse.motion = false;
                        ret.mouse.button = switch (b & 3) {
                            0 => .left,
                            1 => .middle,
                            2 => .right,
                            else => .none,
                        };
                    }
                } else if (last_char == 'm') {
                    ret.mouse.motion = false;
                    ret.mouse.button = .release;
                }
            }
        }

        return ret;
    }

    pub const Input = struct {
        value: u8,
        key: KeyType,
        mouse: MouseEvent,
    };

    pub const KeyType = enum(u8) {
        none = 0,

        ctrl_a = 1,
        ctrl_b = 2,
        ctrl_c = 3,
        ctrl_d = 4,
        ctrl_e = 5,
        ctrl_f = 6,
        ctrl_g = 7,
        ctrl_h = 8,
        ctrl_i = 9, // is tab
        ctrl_j = 10,
        ctrl_k = 11,
        ctrl_l = 12,
        ctrl_m = 13, // is enter
        ctrl_n = 14,
        ctrl_o = 15,
        ctrl_p = 16,
        ctrl_q = 17,
        ctrl_r = 18,
        ctrl_s = 19,
        ctrl_t = 20,
        ctrl_u = 21,
        ctrl_v = 22,
        ctrl_w = 23,
        ctrl_x = 24,
        ctrl_y = 25,
        ctrl_z = 26,

        tab,
        enter,
        backspace,
        delete,

        arrow_up,
        arrow_down,
        arrow_right,
        arrow_left,

        home,
        end,
        page_up,
        page_down,

        mouse,

        alphanum,
        printable,
    };

    pub const MouseEvent = struct {
        button: MouseButton,
        column: u32,
        row: u32,
        shift: bool,
        ctrl: bool,
        meta: bool,
        motion: bool,
    };

    pub const MouseButton = enum(u8) {
        left,
        middle,
        right,
        release,
        scroll_up,
        scroll_down,
        none,
    };
};

// *******************************
// utils
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

    pub const TerminalSize = struct {
        rows: u16,
        cols: u16,
    };

    // get terminal size
    // requires raw mode to be enabled on some platforms
    pub fn getTerminalSize() ZtermError!TerminalSize {
        return switch (builtin.target.os.tag) {
            .macos, .linux => getTerminalSizeUnix(),
            .windows => getTerminalSizeWindows(),
            else => ZtermError.UnsupportedPlatform,
        };
    }

    fn getTerminalSizeUnix() ZtermError!TerminalSize {
        var winsize_struct: std.posix.winsize = undefined;
        const err = std.posix.system.ioctl(std.posix.STDOUT_FILENO, std.posix.T.IOCGWINSZ, @intFromPtr(&winsize_struct));

        if (std.posix.errno(err) != .SUCCESS) {
            return ZtermError.TerminalSizeFailed;
        }

        if (winsize_struct.row == 0 or winsize_struct.col == 0) {
            return ZtermError.TerminalSizeFailed;
        }

        return TerminalSize{
            .rows = winsize_struct.row,
            .cols = winsize_struct.col,
        };
    }

    fn getTerminalSizeWindows() ZtermError!TerminalSize {
        var winsize_struct: windows.CONSOLE_SCREEN_BUFFER_INFO = undefined;
        const stdout_handle = windows.GetStdHandle(windows.STD_OUTPUT_HANDLE) catch
            return ZtermError.WindowsApiError;

        if (windows.kernel32.GetConsoleScreenBufferInfo(stdout_handle, &winsize_struct) == 0) {
            return ZtermError.TerminalSizeFailed;
        }

        const cols = @as(u16, @intCast(winsize_struct.srWindow.Right - winsize_struct.srWindow.Left + 1));
        const rows = @as(u16, @intCast(winsize_struct.srWindow.Bottom - winsize_struct.srWindow.Top + 1));

        if (cols == 0 or rows == 0) {
            return ZtermError.TerminalSizeFailed;
        }

        return TerminalSize{
            .rows = rows,
            .cols = cols,
        };
    }
};
