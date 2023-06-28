const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    // s
    //    const quaternion_module = b.addModule("shared".
    //        std.build.CreateModuleOptions{
    //            .source_file = std.build.FileSource.relative("lib/quaternion/quaternion.zig"),
    //        });
    //    const exe = b.addExecutable(.{
    //        .name = "quaternion-main",
    //        .root_source_file = .{
    //            .path = "src/main.zig",
    //        },
    //        .target = target,
    //        .optimize = optimize,
    //    });
    //    exe.addModule("quaternion", quaternion_module);
    // e

    const lib = b.addStaticLibrary("quaternion", "lib/quaternion/quaternion.zig");
    lib.setBuildMode(mode);
    lib.install();

    const main_tests = b.addTest("lib/quaternion/quaternion-tests.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
