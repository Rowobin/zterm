const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Zterm module
    const zterm_mod = b.addModule("zterm", .{ .root_source_file = .{ .cwd_relative = "src/zterm.zig" } });

    // Examples
    const examples = [_][]const u8{ "text_effects", "cursor", "raw_mode", "clear_screen", "game_base", "alt_screen", "mouse_input" };

    for (examples) |example_name| {
        const example_mod = b.addModule(b.fmt("example_{s}", .{example_name}), .{
            .root_source_file = .{ .cwd_relative = b.fmt("examples/{s}.zig", .{example_name}) },
            .target = target,
            .optimize = optimize,
        });
        example_mod.addImport("zterm", zterm_mod);

        const example = b.addExecutable(.{
            .name = example_name,
            .root_module = example_mod,
        });

        const install_example = b.addRunArtifact(example);
        const example_step = b.step(example_name, b.fmt("Run {s} example", .{example_name}));
        example_step.dependOn(&install_example.step);
        example_step.dependOn(&example.step);
    }
}
