const std = @import("std");
const windows = std.os.windows;
const builtin = @import("builtin");

// *******************************
// WELCOME TO ZTERM - A Zig library for terminal manipulation
// *******************************

// *******************************
// ERROR TYPES
// *******************************

pub const ZTermError = error{
    UnsupportedPlatform,
    TerminalSetupFailed,
    InputReadFailed,
    WindowsAPIError,
    InvalidTimeout,
    CursorPositionFailed,
    TerminalSizeFailed,
};

// *******************************
// CONFIGURATION
// *******************************

pub const Config = struct {
    // timeout for input reading in ms
    // use 256 to block
    input_timeout_ms: u8 = 100,
};

var global_config = Config{};

pub fn setConfig(config: Config) ZTermError!void {
    global_config = config;
}

pub fn getConfig() Config {
    return global_config;
}

// *******************************
// CUSTOMIZE TEXT COLOR
// *******************************

pub const color = struct {
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

    // print functions instantly execute a code
    // other functions return the code to the user
    pub const print = struct {
        // fg() and bg() set colors based on the enum 'codes'
        pub fn fg(code: codes) void {
            utils.printEscapeCode("38;5;{d}m", .{@intFromEnum(code)});
        }

        pub fn bg(code: codes) void {
            utils.printEscapeCode("48;5;{d}m", .{@intFromEnum(code)});
        }

        // fgRGB() and bgRGB() set colors based on the RGB color system
        pub fn fgRGB(r: u8, g: u8, b: u8) void {
            utils.printEscapeCode("38;2;{d};{d};{d}m", .{ r, g, b });
        }

        pub fn bgRGB(r: u8, g: u8, b: u8) void {
            utils.printEscapeCode("48;2;{d};{d};{d}m", .{ r, g, b });
        }

        // fg256() and bg256() set colors based 'True color' system
        pub fn fg256(color256: u8) void {
            utils.printEscapeCode("38;5;{d}m", .{color256});
        }

        pub fn bg256(color256: u8) void {
            utils.printEscapeCode("48;5;{d}m", .{color256});
        }
    };

    // fg() and bg() set colors based on the enum 'codes'
    // these color codes should be supported in most terminals
    pub inline fn fg(code: codes) []const u8 {
        return utils.returnEscapeCode("38;5;{d}m", .{@intFromEnum(code)});
    }

    pub inline fn bg(code: codes) []const u8 {
        return utils.returnEscapeCode("48;5;{d}m", .{@intFromEnum(code)});
    }

    // fgRGB() and bgRGB() set colors based on the RGB color system
    // these color codes should be supported in some (modern) terminals
    pub inline fn fgRGB(r: u8, g: u8, b: u8) []const u8 {
        return utils.returnEscapeCode("38;2;{d};{d};{d}m", .{ r, g, b });
    }

    pub inline fn bgRGB(r: u8, g: u8, b: u8) []const u8 {
        return utils.returnEscapeCode("48;2;{d};{d};{d}m", .{ r, g, b });
    }

    // fg256() and bg256() set colors based 'True color' system
    // these color codes should be supported in most terminals
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

        pub fn moveTo(row: u16, col: u16) void {
            utils.printEscapeCode("{};{}H", .{ row, col});
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

    pub const cursor_pos = struct {
        rows: u16,
        cols: u16
    };

    // get cursor position
    // requires raw mode to be enabled
    pub fn getPosition() ZTermError!cursor_pos {
        const stdin = std.io.getStdIn().reader();
        const stdout = std.io.getStdOut().writer();

        stdout.writeAll(utils.returnEscapeCode("6n", .{})) catch return ZTermError.CursorPositionFailed;

        var pos = [2]u16{ 0, 0 };
        var buffer: [32]u8 = undefined;
        var index: usize = 0;
        var pos_i: u8 = 0;

        while (index < buffer.len - 1) : (index += 1) {
            buffer[index] = stdin.readByte() catch return ZTermError.CursorPositionFailed;

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

        const ret: cursor_pos = .{
            .rows = pos[0],
            .cols = pos[1]
        };
        return ret;
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
    pub const terminal_data = union {
        orig_termios: std.posix.termios,
        orig_terminal: windows.DWORD
    };

    pub fn enable() ZTermError!terminal_data {
        return switch (builtin.target.os.tag) {
            .macos, .linux => terminal_data{ .orig_termios = try enableUnix() },
            .windows => terminal_data{ .orig_terminal = try enableWindows() },
            else => ZTermError.UnsupportedPlatform,
        };
    }

    pub fn enableUnix() ZTermError!std.posix.termios {
        const orig_termios: std.posix.termios = std.posix.tcgetattr(std.posix.STDIN_FILENO) catch 
            return ZTermError.TerminalSetupFailed;

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

        if (global_config.input_timeout_ms == 256) {
            raw.cc[@intFromEnum(std.posix.V.MIN)] = 1; // read must read at least one byte before retuning
            raw.cc[@intFromEnum(std.posix.V.TIME)] = 0;
        } else {
            raw.cc[@intFromEnum(std.posix.V.MIN)] = 0; // read can return before receving input
            raw.cc[@intFromEnum(std.posix.V.TIME)] = global_config.input_timeout_ms/100;
        }

        std.posix.tcsetattr(std.posix.STDIN_FILENO, std.posix.TCSA.FLUSH, raw) catch 
            return ZTermError.TerminalSetupFailed;
        
        return orig_termios;
    }

    pub fn enableWindows() ZTermError!windows.DWORD {
        const std_handle: windows.HANDLE = windows.GetStdHandle(windows.STD_INPUT_HANDLE) catch 
            return ZTermError.WindowsAPIError;
        
        var orig_term: windows.DWORD = undefined;
        if (windows.kernel32.GetConsoleMode(std_handle, &orig_term) == 0) {
            return ZTermError.WindowsAPIError;
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
            return ZTermError.WindowsAPIError;
        }

        if (windows.kernel32.FlushFileBuffers(std_handle) == 0) { 
        return ZTermError.WindowsAPIError;
    }
        
        return orig_term;
    }

    pub fn disable(term: terminal_data) ZTermError!void {
        return switch (builtin.target.os.tag) {
            .macos, .linux => {
                std.posix.tcsetattr(std.posix.STDIN_FILENO, std.posix.TCSA.FLUSH, term.orig_termios) catch 
                    return ZTermError.TerminalSetupFailed;
            },
            .windows => {
                const std_handle: windows.HANDLE = windows.GetStdHandle(windows.STD_INPUT_HANDLE) catch 
                    return ZTermError.WindowsAPIError;
                if (windows.kernel32.SetConsoleMode(std_handle, term.orig_terminal) == 0) {
                    return ZTermError.WindowsAPIError;
                }
            },
            else => ZTermError.UnsupportedPlatform,
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

    pub fn getNextInput() ZTermError!input {
        return switch (builtin.target.os.tag) {
            .macos, .linux => getNextInputUnix(),
            .windows => getNextInputWindows(),
            else => ZTermError.UnsupportedPlatform,
        };
    }

    fn getNextInputUnix() ZTermError!input {
        var c: [32]u8 = undefined;
        c[0] = 0;
        
        const bytes_read = std.posix.read(std.posix.STDIN_FILENO, &c) catch |err| switch (err) {
            error.WouldBlock => 0, // timeout occurred
            else => return ZTermError.InputReadFailed,
        };

        return parseInput(c[0..bytes_read]);
    }

    fn getNextInputWindows() ZTermError!input {
        const std_handle = windows.GetStdHandle(windows.STD_INPUT_HANDLE) catch 
            return ZTermError.WindowsAPIError;
        
        const timeout = if (global_config.input_timeout_ms == 256) 
            windows.INFINITE 
        else 
            global_config.input_timeout_ms;

        const wait_result = windows.kernel32.WaitForSingleObject(std_handle, timeout);
        var c: [32]u8 = undefined;
        var bytes_read: usize = 0;
        
        switch (wait_result) {
            windows.WAIT_OBJECT_0 => {
                var bytes_read_u32: u32 = undefined;
                if (windows.kernel32.ReadFile(std_handle, &c, c.len, &bytes_read_u32, null) == 0) {
                    return ZTermError.InputReadFailed;
                }
                bytes_read = bytes_read_u32;
            },
            windows.WAIT_TIMEOUT => {
                bytes_read = 0;
            },
            else => return ZTermError.InputReadFailed,
        }

        return parseInput(c[0..bytes_read]);
    }

    fn parseInput(buffer: []const u8) input {
        var ret: input = .{
            .value = if (buffer.len > 0) buffer[0] else 0,
            .key = .NONE,
            .mouse = .{
                .button = .NONE,
                .column = 0,
                .row = 0,
                .shift = false,
                .ctrl = false,
                .meta = false,
                .motion = false
            }
        };

        if (buffer.len == 0) return ret;

        if (buffer.len == 1) {
            const c = buffer[0];
            if (std.ascii.isPrint(c)) {
                ret.key = .PRINTABLE;
                if (std.ascii.isAlphanumeric(c)) {
                    ret.key = .ALPHANUM;
                }
            }

            if (c >= 1 and c <= 26) ret.key = @enumFromInt(c);

            switch (c) {
                std.ascii.control_code.cr => ret.key = .ENTER,
                std.ascii.control_code.ht => ret.key = .TAB,
                std.ascii.control_code.bs => ret.key = .BACKSPACE,
                std.ascii.control_code.del => ret.key = .DELETE,
                else => {},
            }
        } else if (buffer.len >= 3 and buffer[0] == '\x1b' and buffer[1] == '[') {
            if (buffer.len == 3) {
                switch (buffer[2]) {
                    'A' => ret.key = .ARROW_UP,
                    'B' => ret.key = .ARROW_DOWN,
                    'C' => ret.key = .ARROW_RIGHT,
                    'D' => ret.key = .ARROW_LEFT,
                    'H' => ret.key = .HOME,
                    'F' => ret.key = .END,
                    else => {},
                }
            } else if (buffer.len == 4 and buffer[3] == '~') {
                switch (buffer[2]) {
                    '1' => ret.key = .HOME,
                    '3' => ret.key = .DELETE,
                    '4' => ret.key = .END,
                    '5' => ret.key = .PAGE_UP,
                    '6' => ret.key = .PAGE_DOWN,
                    '7' => ret.key = .HOME,
                    '8' => ret.key = .END,
                    else => {},
                }
            } else if (buffer.len >= 6 and buffer[2] == '<') {
                ret.key = .MOUSE;
                
                const mouse_data = buffer[3..buffer.len-1];
                const last_char = buffer[buffer.len-1];

                var iter = std.mem.splitAny(u8, mouse_data, ";");
                const B_str = iter.next() orelse return ret;
                const C_str = iter.next() orelse return ret;
                const R_str = iter.next() orelse return ret;

                const B = std.fmt.parseInt(u32, B_str, 10) catch return ret;
                const C = std.fmt.parseInt(u32, C_str, 10) catch return ret;
                const R = std.fmt.parseInt(u32, R_str, 10) catch return ret;

                ret.mouse.column = C;
                ret.mouse.row = R;
                ret.mouse.shift = (B & 4) != 0;
                ret.mouse.meta = (B & 8) != 0;
                ret.mouse.ctrl = (B & 16) != 0;

                if (last_char == 'M') {
                    if (B & 32 != 0) {
                        ret.mouse.motion = true;
                        ret.mouse.button = switch (B & 3) {
                            0 => .LEFT,
                            1 => .MIDDLE,
                            2 => .RIGHT,
                            else => .NONE,
                        };
                    } else if (B >= 64) {
                        ret.mouse.motion = false;
                        if (B == 64) ret.mouse.button = .SCROLL_UP
                        else if (B == 65) ret.mouse.button = .SCROLL_DOWN
                        else ret.mouse.button = .NONE;
                    } else {
                        ret.mouse.motion = false;
                        ret.mouse.button = switch (B & 3) {
                            0 => .LEFT,
                            1 => .MIDDLE,
                            2 => .RIGHT,
                            else => .NONE,
                        };
                    }
                } else if (last_char == 'm') {
                    ret.mouse.motion = false;
                    ret.mouse.button = .RELEASE;
                }
            }
        }

        return ret;
    }

    pub const input = struct {
        value: u8,
        key: key_type,
        mouse: mouse_event
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

        MOUSE,

        ALPHANUM,
        PRINTABLE,
    };

    pub const mouse_event = struct {
        button: mouse_button,
        column: u32,
        row: u32,
        shift: bool,
        ctrl: bool,
        meta: bool,
        motion: bool
    };

    pub const mouse_button = enum (u8) {
        LEFT,
        MIDDLE,
        RIGHT,
        RELEASE,
        SCROLL_UP,
        SCROLL_DOWN,
        NONE
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

    pub const terminal_size = struct {
        rows: u16,
        cols: u16
    };

    // get terminal size
    // requires raw mode to be enabled on some platforms
    pub fn getTerminalSize() ZTermError!terminal_size {
        return switch (builtin.target.os.tag) {
            .macos, .linux => getTerminalSizeUnix(),
            .windows => getTerminalSizeWindows(),
            else => ZTermError.UnsupportedPlatform,
        };
    }

    fn getTerminalSizeUnix() ZTermError!terminal_size {
        var winsizestruct: std.posix.winsize = .{ .row = 0, .col = 0, .xpixel = 0, .ypixel = 0 };
        const err = std.posix.system.ioctl(std.io.getStdOut().handle, std.posix.T.IOCGWINSZ, @intFromPtr(&winsizestruct));
        
        if (std.posix.errno(err) != .SUCCESS) {
            return ZTermError.TerminalSizeFailed;
        }
        
        if (winsizestruct.row == 0 or winsizestruct.col == 0) {
            return ZTermError.TerminalSizeFailed;
        }
        
        return terminal_size{
            .rows = winsizestruct.row,
            .cols = winsizestruct.col,
        };
    }

    fn getTerminalSizeWindows() ZTermError!terminal_size {
        var winsizestruct: windows.CONSOLE_SCREEN_BUFFER_INFO = undefined;
        const stdout_handle = windows.GetStdHandle(windows.STD_OUTPUT_HANDLE) catch 
            return ZTermError.WindowsAPIError;
        
        if (windows.kernel32.GetConsoleScreenBufferInfo(stdout_handle, &winsizestruct) == 0) {
            return ZTermError.TerminalSizeFailed;
        }
        
        const cols = @as(u16, @intCast(winsizestruct.srWindow.Right - winsizestruct.srWindow.Left + 1));
        const rows = @as(u16, @intCast(winsizestruct.srWindow.Bottom - winsizestruct.srWindow.Top + 1));
        
        if (cols == 0 or rows == 0) {
            return ZTermError.TerminalSizeFailed;
        }
        
        return terminal_size{
            .rows = rows,
            .cols = cols,
        };
    }
};