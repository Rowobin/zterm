const std = @import("std");
const posix = std.posix;
const ascii = std.ascii;
const zterm = @import("zterm");

pub fn main() !void{
    // enable raw mode
    // the terminal will now process user input byte by byte
    const orig_termios = try zterm.rawMode.enable();
    defer zterm.rawMode.disable(orig_termios) catch unreachable; // disable raw mode at the end

    // test mouse input 
    zterm.rawMode.enableMouseInput();
    defer zterm.rawMode.disableMouseInput();

    while (true) {
        const input = zterm.rawMode.getNextInput();
        
        if(input.value == 0) continue;
        
        switch (input.key) {
            .ALPHANUM,
            .PRINTABLE => {
                std.debug.print("{c} ", .{input.value});
            },
            .MOUSE => {
                std.debug.print("MOUSE INPUT!\n\r  BUTTON: {s}\n\r  POS:{d},{d}\n\r  CTRL: {any}\n\r  SHIFT: {any}\n\r  META: {any}\n\r  MOTION: {any}\n\r", .{
                    @tagName(input.mouse.button),
                    input.mouse.column,
                    input.mouse.row,
                    input.mouse.ctrl,
                    input.mouse.shift,
                    input.mouse.meta,
                    input.mouse.motion
                });
                continue;
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