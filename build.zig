const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe_mod = b.createModule(.{
        .optimize = optimize,
        .target = target,
        .root_source_file = b.path("src/main.zig"),
    });

    const exe = b.addExecutable(.{
        .root_module = exe_mod,
        .name = "zigging",
    });

    b.installArtifact(exe);

    {
        // `zig build run`

        const run_cmd = b.addRunArtifact(exe);
        run_cmd.step.dependOn(b.getInstallStep());

        if (b.args) |args| {
            run_cmd.addArgs(args);
        }

        const run_step = b.step("run", "Run the zigging");
        run_step.dependOn(&run_cmd.step);
    }

    {
        // `zig build test`

        const unit_tests = b.addTest(.{
            .root_module = exe_mod,
        });

        const run_unit_tests = b.addRunArtifact(unit_tests);
        const run_tests_step = b.step("test", "Run unit tests for zigging");
        run_tests_step.dependOn(&run_unit_tests.step);
    }
}
