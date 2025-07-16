const std = @import("std");
const posix = std.posix;
const ascii = std.ascii;
const utils = @import("main.zig").utils;

pub fn enableRawMode() !posix.termios {
    const orig_termios: posix.termios = try posix.tcgetattr(posix.STDIN_FILENO);

    var raw: posix.termios = orig_termios;

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

    raw.cc[@intFromEnum(posix.V.MIN)] = 0; // read can return after reading 0 bytes
    raw.cc[@intFromEnum(posix.V.TIME)] = 1; // read waits 1/10 of a second before returning

    try posix.tcsetattr(posix.STDIN_FILENO, posix.TCSA.FLUSH, raw);
    return orig_termios;
}

pub fn disableRawMode(orig_termios: posix.termios) !void {
    try posix.tcsetattr(posix.STDIN_FILENO, posix.TCSA.FLUSH, orig_termios);
}

// get terminal size in the format [rows_num; columns_num]
pub fn getTerminalSize() ![2]u16 {
    var winsizestruct: posix.winsize = .{
        .row = 0,
        .col = 0,
        .xpixel = 0,
        .ypixel = 0
    };

    var winsize = [2]u16{0,0};

    const err = std.posix.system.ioctl(std.io.getStdOut().handle, posix.T.IOCGWINSZ, @intFromPtr(&winsizestruct));
    if(posix.errno(err) == .SUCCESS) {
        winsize[0] = winsizestruct.row;
        winsize[1] = winsizestruct.col;
    }

    return winsize;
}

pub fn getNextInput() input {
    var c: [32]u8 = undefined;
    c[0] = 0;
    const bytes_read = posix.read(posix.STDIN_FILENO, &c) catch unreachable;

    var ret: input = .{
        .value = c[0],
        .key = .NONE,
    };

    if (bytes_read == 0) return ret;

    if (bytes_read == 1) {
        // printable characters
        if(ascii.isPrint(c[0])) {
            ret.key = .PRINTABLE;
            if (ascii.isAlphanumeric(c[0])) {
                ret.key = .ALPHANUM;
            }
        }

        // CTRL inputs
        if(c[0] >= 1 and c[0] <= 26) ret.key = @enumFromInt(c[0]);

        // control characters
        switch (c[0]) {
            ascii.control_code.cr => ret.key = .ENTER,
            ascii.control_code.ht => ret.key = .TAB,
            ascii.control_code.bs => ret.key = .BACKSPACE,
            ascii.control_code.del => ret.key = .DELETE,
            else => {}
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