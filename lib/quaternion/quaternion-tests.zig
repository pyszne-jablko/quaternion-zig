const std = @import("std");
const Quat = @import("./quaternion.zig").QuaternionF32;
const expect = std.testing.expect;

test "Base init" {
    const q1 = Quat{};
    try expect(q1.real == 0.0);
    try expect(q1.i == 0.0);
    try expect(q1.j == 0.0);
    try expect(q1.k == 0.0);
}
