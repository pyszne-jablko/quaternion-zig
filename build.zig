const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    // Add static library
    const q_lib = b.addStaticLibrary("quaternion", "lib/quaternion/quaternion.zig");
    q_lib.setBuildMode(mode);
    q_lib.install();

    const main_tests = b.addTest("lib/quaternion/quaternion-tests.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
