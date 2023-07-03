const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const quaternion_module = b.addModule("quaternion", std.build.CreateModuleOptions{
        .source_file = std.build.FileSource.relative("lib/quaternion/quaternion.zig"),
    });

    const main_tests = b.addTest("lib/quaternion/quaternion-tests.zig");
    main_tests.setBuildMode(mode);
    main_tests.addModule("quaternion", quaternion_module);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
