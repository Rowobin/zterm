const std = @import("std");
const zterm = @import("zterm");

pub fn main() !void {
    zterm.altScreen.enable();
    defer zterm.altScreen.disable();

    std.debug.print("Hello from the Alternate Screen!\n", .{});
    std.debug.print("You should see this text on a blank screen.\n", .{});
    std.debug.print("Press Enter to return to your original terminal.\n", .{});

    const orig_termios = try zterm.rawMode.enable();
    defer zterm.rawMode.disable(orig_termios) catch unreachable;

    while (true) {
        const input = zterm.rawMode.getNextInput();

        if (input.value == 0) continue;

        if (input.key == .ENTER) {
            break;
        }

        if (input.value == 'q' or input.key == .CTRL_C) {
            break;
        }
    }
}
