const std = @import("std");
const zterm = @import("zterm");

const option = struct {
    text: [] const u8,
    line: u8,
    selected: bool
};

var options= [_]option{
    .{
        .text = "Welcome to Zterm!",
        .line = 2,
        .selected = false
    },
    .{
        .text = "made by rowobin",
        .line = 4,
        .selected = false
    },
    .{
        .text = "-q to exit-",
        .line = 6,
        .selected = false
    },
};

const strings = [_][]const u8{ "Welcome to Zterm :)", "made by rowobin", "exit" };
const lines = [_][] const u8{2, 4, 6};

pub fn main() !void {
    zterm.cursor.print.hide();
    defer zterm.cursor.print.show();

    zterm.altScreen.print.enable();
    defer zterm.altScreen.print.disable();

    const orig_termios = try zterm.rawMode.enable();
    defer zterm.rawMode.disable(orig_termios) catch unreachable;

    zterm.rawMode.enableMouseInput();
    defer zterm.rawMode.disableMouseInput();

    while (true) {
        zterm.cursor.print.reset();
        if (handleInput() == -1) break;
        draw();
    }
}

pub fn handleInput() i8 {
    const input = zterm.rawMode.getNextInput();
    if (input.value == 0) return 0;
    if (input.value == 'q') return -1;

    if(input.key == .MOUSE){
        for(options, 0..) |_, i| {
            options[i].selected = (options[i].line == input.mouse.row);
        }

        if(input.mouse.button == .LEFT){
            if(options[2].selected){
                return -1;
            }
        }
    }

    return 0;
}

pub fn draw() void {
    for(options) |opt| {
        if(!opt.selected) {
            zterm.color.print.bg(.white);
            zterm.color.print.fg(.black);
        } else {
            zterm.color.print.bg(.red);
            zterm.color.print.fg(.white);
        }
        
        zterm.cursor.print.moveTo(opt.line, 2);
        std.debug.print(" {s} ", .{opt.text});
    } 
}