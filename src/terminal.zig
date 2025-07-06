const std = @import("std");
const posix = std.posix;
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