const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Zterm module
    const zterm_mod = b.addModule("zterm", .{ .root_source_file = b.path("src/main.zig") });

    // Examples
    const examples = [_][]const u8{"text_effects", "cursor", "raw_mode"};

    for (examples) |example_name| {
        const example = b.addExecutable(.{ .name = example_name, .root_source_file = b.path(b.fmt("examples/{s}.zig", .{example_name})), .target = target, .optimize = optimize });

        const install_example = b.addRunArtifact(example);
        example.root_module.addImport("zterm", zterm_mod);

        const example_step = b.step(example_name, b.fmt("Run {s} example", .{example_name}));
        example_step.dependOn(&install_example.step);
        example_step.dependOn(&example.step);
    }
}
