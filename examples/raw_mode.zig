const std = @import("std");
const posix = std.posix;
const ascii = std.ascii;
const zterm = @import("zterm");

pub fn main() !void{
    const orig_termios = try zterm.terminal.enableRawMode();
    defer zterm.terminal.disableRawMode(orig_termios) catch unreachable; // disable raw mode at the end

    while (true) {
        var c: u8 = 0;
        _ = posix.read(posix.STDIN_FILENO, @as([*]u8, @ptrCast(&c))[0..1]) catch unreachable;
        if(c == 0) continue;

        std.debug.print("{c} ", .{c});

        const cursor_pos = zterm.cursor.getPosition() catch unreachable;
        std.debug.print("Cursor is at line {d}\r\n", .{cursor_pos[0]});

        if (c == 'q') break; // Press 'q' to quit
    }
}