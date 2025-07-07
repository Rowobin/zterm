const std = @import("std");
const posix = std.posix;
const zterm = @import("zterm");

const map_x = 50;
const map_y = 25;

var player_pos: [2]u8 = [2]u8{0,0};

pub fn main() !void {
    zterm.clear.print.screen();
    zterm.cursor.print.hide();

    const orig_termios = try zterm.terminal.enableRawMode();
    defer reset(orig_termios) catch unreachable;

    while(true) {
        zterm.cursor.print.reset();
        if (handleInput() == -1) break;
        draw();
    }
}

pub fn handleInput() i8 {
    var input: [1]u8 = [1]u8{0};
    _ = posix.read(posix.STDIN_FILENO, &input) catch unreachable;

    switch (input[0]) {
        'w' => {
            if(player_pos[1] != 0) player_pos[1] -= 1;
        },
        'a' => {
            if(player_pos[0] != 0) player_pos[0] -= 1;
        },
        's' => {
            player_pos[1] += 1;
        },
        'd' => {
            player_pos[0] += 1;
        },
        'q' => {
            return -1;
        },
        else => {}
    }

    if (player_pos[0] > map_x - 1) player_pos[0] = map_x - 1;
    if(player_pos[1] > map_y - 1) player_pos[1] = map_y - 1;

    return 0;
}

pub fn draw() void {
    var i: u8 = 0;
    while (i < map_y) : (i += 1) {
        var j: u8 = 0;
        while(j < map_x) : (j += 1) {
            if(i == player_pos[1] and j == player_pos[0]){
                zterm.color.print.fg(.red);
            } else {
                zterm.color.print.fg(.blue);
            }
            std.debug.print("\u{2588}", .{});
            zterm.utils.print.resetAll();
        }
        std.debug.print("\n\r", .{});
    }
    std.debug.print("\n\r", .{});

    const term_size = zterm.terminal.getTerminalSize() catch unreachable;
    
    i = 0;
    while (i < term_size[1]) : (i += 1) {
        std.debug.print("=", .{});
    }
    std.debug.print("\n\r", .{});

    std.debug.print("WSAD TO MOVE || Q TO QUIT\n\r", .{});

    i = 0;
    while (i < term_size[1]) : (i += 1) {
        std.debug.print("=", .{});
    }
    std.debug.print("\n\r", .{});
}

pub fn reset(orig_termios : posix.termios) !void {
    try zterm.terminal.disableRawMode(orig_termios);
    zterm.cursor.print.show();
}