const std = @import("std");
const zterm = @import("zterm");

// TO-DO
// Lose and restart
const map_struct = struct {
    size: u16,
    x_pad: u16,
    y_pad: u16
};
var terminal: zterm.utils.terminal_size = undefined;
var map: map_struct = undefined;
const square = "\u{2588}" ** 2;

const direction_enum = enum(u8) {
    RIGHT,
    LEFT,
    UP,
    DOWN
};
const player_struct = struct {
    x: []u16,
    y: []u16,
    score: u16,
    direction: direction_enum
};
var player: player_struct = undefined;
var game_started: bool = undefined;
const allocator = std.heap.page_allocator;

const apple_struct = struct {
    x: u16,
    y: u16
};
var apple: apple_struct = undefined;

pub fn main() void {
    // set up raw mode
    zterm.cursor.print.hide();
    defer zterm.cursor.print.show();
    zterm.altScreen.print.enable();
    defer zterm.altScreen.print.disable();
    const orig_termios = zterm.rawMode.enable() catch unreachable;
    defer zterm.rawMode.disable(orig_termios) catch unreachable;

    setUpGame();    
    defer freePlayerMem();

    while(true) {
        zterm.cursor.print.reset();

        if(handle_input() == 1) break;
        draw();

        // resizing resets game
        const term_tmp = zterm.utils.getTerminalSize() catch unreachable;
        if(terminal.cols != term_tmp.cols or terminal.rows != term_tmp.rows){
            freePlayerMem();
            setUpGame();
        }
    }
}

pub fn handle_input() u1 {
    const input = zterm.rawMode.getNextInput();

    switch (input.value) {
        'q' => {
            return 1;
        },
        'w' => {
            player.direction = .UP;
            game_started = true;
        },
        'a' => {
            player.direction = .LEFT;
            game_started = true;
        },
        's' => {
            player.direction = .DOWN;   
            game_started = true;
        },
        'd' => {
            player.direction = .RIGHT;  
            game_started = true;
        },
        else => {}
    }

    if(game_started){
        updatePlayerPosition();
        movePlayer();

        if(player.x[0] == apple.x and player.y[0] == apple.y){
            playerScoreUp();
            setUpApple();
        }
    }

    return 0;
}

pub fn updatePlayerPosition() void {
    var player_segments = player.score+2;
    player_segments-=1;
    while(player_segments > 0) : (player_segments-=1){
        player.y[player_segments] = player.y[player_segments - 1];
        player.x[player_segments] = player.x[player_segments - 1];
    }
}

pub fn movePlayer() void {
    switch (player.direction) {
        .UP => {
            if(player.y[0] > 1) {
                player.y[0] -= 1;
            } else {
                restartGame();
            }
        },
        .LEFT => {
            if(player.x[0] > 1) {
                player.x[0] -= 2;
            } else {
                restartGame();
            }
        },
        .DOWN => {
            if(player.y[0] < map.size - 1) {
                player.y[0] += 1;
            } else {
                restartGame();
            }
        },
        .RIGHT => {
            if(player.x[0] < (map.size * 2) - 2) {
                player.x[0] += 2;
            } else {
                restartGame();
            }
        }
    } 

    // check if player is collding with itself
    for(1..player.score+2) |i| {
        if(player.x[0] == player.x[i] and player.y[0] == player.y[i]){
            restartGame();
            break;
        }
    } 
}

pub fn playerScoreUp() void {
    player.score += 1;
    drawUIScore();

    player.x = allocator.realloc(player.x, player.score + 2) catch unreachable;
    player.y = allocator.realloc(player.y, player.score + 2) catch unreachable;

    player.x[player.score+1] = player.x[player.score];
    player.y[player.score+1] = player.y[player.score];
}

pub fn restartGame() void {
    std.time.sleep(1_000_000_000);
    setUpGame();
}

pub fn draw() void {
    drawPlayer();
    drawApple();
}

pub fn setUpGame() void {
    zterm.clear.print.screen();
    terminal = zterm.utils.getTerminalSize() catch unreachable;

    game_started = false;
    setUpMap();
    setUpPlayer();
    setUpApple();
    drawUIBar();
    drawUIScore();
}

pub fn setUpMap() void {
    map.x_pad = 0;
    map.y_pad = 0;

    if(terminal.rows > (terminal.cols/2)){
        map.size = terminal.cols/2;
        map.y_pad = (terminal.rows - map.size) / 2;
    } else {
        map.size = terminal.rows;
        map.x_pad = terminal.cols/2 - map.size;
    }

    zterm.cursor.print.reset();
    if(map.y_pad > 0) zterm.cursor.print.moveDown(map.y_pad);
    zterm.color.print.fg(.blue);
    for(0..map.size) |_| {
        zterm.cursor.print.moveToCol(map.x_pad);
        for(0..map.size) |_| {
            std.debug.print("{s}", .{square});
        }
        zterm.cursor.print.moveDownStart(1);
    }
    zterm.utils.print.resetAll();
}

pub fn setUpPlayer() void {
    player.score = 0;
    player.direction = .RIGHT;
    
    player.x = allocator.alloc(u16, 2) catch unreachable;
    player.y = allocator.alloc(u16, 2) catch unreachable;
    
    player.x[0] = map.size;
    if(map.size % 2 == 1) player.x[0] -= 1;
    player.x[1] = player.x[0];

    player.y[0] = map.size/2;
    player.y[1] = player.y[0];
}

pub fn setUpApple() void {
    apple.x = std.Random.intRangeAtMost(std.crypto.random, u16, 1, map.size-1);
    apple.x *= 2;

    apple.y = std.Random.intRangeAtMost(std.crypto.random, u16, 1, map.size-1);
}

pub fn drawUIBar() void {
    zterm.cursor.print.moveTo(map.size + map.y_pad, map.x_pad);
    zterm.color.print.fg(.white);
    for(0..map.size) |_| {
            std.debug.print("{s}", .{square});
    }
    zterm.utils.print.resetAll();
}

pub fn drawUIScore() void {
    zterm.color.print.fg(.black);
    zterm.color.print.bg(.white);
    zterm.cursor.print.moveTo(map.size + map.y_pad, map.x_pad);
    std.debug.print("Score: {d}", .{player.score});
    zterm.utils.print.resetAll();
}

pub fn drawPlayer() void {
    const player_segments = player.score+2;
    for(0..player_segments-1) |i|{
        zterm.cursor.print.moveTo(
            player.y[i] + map.y_pad, 
            player.x[i] + map.x_pad
        );
        std.debug.print("{s}{s}{s}", .{
            zterm.color.fg(.green),
            square,
            zterm.utils.resetAll()
        });
    }

    if(game_started){
        zterm.cursor.print.moveTo(
            player.y[player_segments-1] + map.y_pad, 
            player.x[player_segments-1] + map.x_pad
        );
        std.debug.print("{s}{s}{s}", .{
            zterm.color.fg(.blue),
            square,
            zterm.utils.resetAll()
        });
    }
}

pub fn drawApple() void {
    zterm.cursor.print.moveTo(
        apple.y + map.y_pad, 
        apple.x + map.x_pad
    );

    std.debug.print("{s}{s}{s}", .{
        zterm.color.fg(.red),
        square,
        zterm.utils.resetAll()
    });
}

pub fn freePlayerMem() void {
    allocator.free(player.x);
    allocator.free(player.y);
}