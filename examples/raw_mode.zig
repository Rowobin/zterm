const std = @import("std");
const posix = std.posix;
const ascii = std.ascii;
const zterm = @import("zterm");

pub fn main() !void{
    // enable raw mode
    // the terminal will now process user input byte by byte
    const orig_termios = try zterm.terminal.enableRawMode();
    defer zterm.terminal.disableRawMode(orig_termios) catch unreachable; // disable raw mode at the end

    while (true) {
        const input = zterm.terminal.getNextInput();
        
        if(input.value == 0) continue;
        
        switch (input.key) {
            .ALPHANUM,
            .PRINTABLE => {
                std.debug.print("{c} ", .{input.value});
            },
            .NONE => {
                std.debug.print("NONE enum (raw value: {d}) ", .{input.value});
            },
            else => {
                std.debug.print("{s} ", .{@tagName(input.key)});
            }
        }

        const cursor_pos = zterm.cursor.getPosition() catch unreachable;
        std.debug.print("Cursor is at line {d}\r\n", .{cursor_pos[0]});

        if (input.value == 'q' or input.key == .CTRL_C) break; // Press 'q' to quit
    }
}