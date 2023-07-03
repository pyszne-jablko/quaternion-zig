const std = @import("std");
const Quat = @import("./quaternion.zig").QuaternionF32;
const expect = std.testing.expect;
const expectApproxEqRel = std.testing.expectApproxEqRel;
const expectApproxEqAbs = std.testing.expectApproxEqAbs;

test "Quaternion constructors" {
    var q1 = Quat{};
    try expect(q1.real == 0.0);
    try expect(q1.i == 0.0);
    try expect(q1.j == 0.0);
    try expect(q1.k == 0.0);

    const q2 = Quat{};
    try expect(q2.real == 0.0);
    try expect(q2.i == 0.0);
    try expect(q2.j == 0.0);
    try expect(q2.k == 0.0);

    const q3 = Quat{ .real = 1.0 };
    try expect(q3.real == 1.0);
    try expect(q3.i == 0.0);
    try expect(q3.j == 0.0);
    try expect(q3.k == 0.0);

    var q4 = Quat{ .real = -1.1 };
    q4.i += 5.0;
    q4.j -= 3.0;
    q4.k = 112.5;
    try expect(q4.real == -1.1);
    try expect(q4.i == 5.0);
    try expect(q4.j == -3.0);
    try expect(q4.k == 112.5);
}

test "Quaternion adding" {
    const q1 = Quat{};
    var q2 = q1.add(Quat{ .real = 1.0, .i = 2.0, .j = 3.0, .k = 4.0 });
    try expect(q2.real == 1.0);
    try expect(q2.i == 2.0);
    try expect(q2.j == 3.0);
    try expect(q2.k == 4.0);
}

test "Quaternion substract" {
    var q1 = Quat{};
    var q2 = q1.sub(Quat{ .real = 11.0, .i = 22.0, .j = 33.0, .k = 44.0 });
    try expect(q2.real == -11.0);
    try expect(q2.i == -22.0);
    try expect(q2.j == -33.0);
    try expect(q2.k == -44.0);

    var q3 = Quat{};
    var q4 = q3.add(Quat{ .real = 3.5 }).sub(Quat{ .i = -3.14 });
    try expect(q4.real == 3.5);
    try expect(q4.i == 3.14);
    try expect(q4.j == 0.0);
    try expect(q4.k == 0.0);
}

test "Quaternion norm" {
    const q1 = Quat{};
    try expect(q1.norm() == 0.0);

    const q2 = Quat{ .real = 1.5, .i = -3.2, .j = 5.7, .k = -10.0 };
    try expectApproxEqRel(@as(f32, 12.040764), q2.norm(), @as(f32, 0.000001));

    // |pq|^2 = |p|^2 * |q|^2
    var q3_1 = q2;
    var q3_2 = Quat{ .real = -0.3, .i = -1.0, .j = 0.75, .k = 2.0 };
    var res3_1 = q3_1.mul(q3_2).norm();
    res3_1 *= res3_1;
    var res3_2 = std.math.pow(f32, q3_1.norm(), 2.0);
    res3_2 *= std.math.pow(f32, q3_2.norm(), 2.0);
    try expectApproxEqRel(res3_1, res3_2, @as(f32, 0.000001));
}

test "Quaternion conj" {
    var q1 = Quat{ .real = -2.2, .i = 1.75, .j = -77.8, .k = -34.1 };
    var q1_1 = q1.conj();
    try expectApproxEqRel(@as(f32, -2.2), q1_1.real, @as(f32, 0.000001));
    try expectApproxEqRel(@as(f32, -1.75), q1_1.i, @as(f32, 0.000001));
    try expectApproxEqRel(@as(f32, 77.8), q1_1.j, @as(f32, 0.000001));
    try expectApproxEqRel(@as(f32, 34.1), q1_1.k, @as(f32, 0.000001));

    // (p*)* = p
    var q2 = Quat{ .real = -5.0, .i = -1.5, .j = 7.0, .k = 33.0 };
    var q3 = q2.conj().conj();
    try expectApproxEqRel(@as(f32, -5.0), q3.real, @as(f32, 0.000001));
    try expectApproxEqRel(@as(f32, -1.5), q3.i, @as(f32, 0.000001));
    try expectApproxEqRel(@as(f32, 7.0), q3.j, @as(f32, 0.000001));
    try expectApproxEqRel(@as(f32, 33.0), q3.k, @as(f32, 0.000001));

    // p + p* = only real part times 2
    var q4 = q2.add(q2.conj());
    try expectApproxEqRel(@as(f32, -10.0), q4.real, @as(f32, 0.000001));
    try expectApproxEqRel(@as(f32, 0.0), q4.i, @as(f32, 0.000001));
    try expectApproxEqRel(@as(f32, 0.0), q4.j, @as(f32, 0.000001));
    try expectApproxEqRel(@as(f32, 0.0), q4.k, @as(f32, 0.000001));

    // q* x q = q x q*
    const q5_1 = q2;
    var q5_2 = q5_1.conj().mul(q5_1);
    var q5_3 = q5_1.mul(q5_1.conj());
    try expectApproxEqRel(q5_2.real, q5_3.real, @as(f32, 0.000001));
    try expectApproxEqRel(q5_2.i, q5_3.i, @as(f32, 0.000001));
    try expectApproxEqRel(q5_2.j, q5_3.j, @as(f32, 0.000001));
    try expectApproxEqRel(q5_2.k, q5_3.k, @as(f32, 0.000001));

    // (pq)* = q*p*
    const q6_1 = Quat{ .real = 0.2, .i = 0.3, .j = -0.7, .k = -1.1 };
    const q6_2 = Quat{ .real = 0.3, .i = 0.32, .j = 0.1, .k = 20.0 };
    var q6_3 = q6_1.mul(q6_2).conj();
    var q6_4 = q6_2.conj().mul(q6_1.conj());
    try expectApproxEqRel(q6_3.real, q6_4.real, @as(f32, 0.000001));
}

test "Quaternion multiplication" {
    const q1 = Quat{ .real = 3.0, .i = 1.0, .j = -2.0, .k = 1.0 };
    const q2 = Quat{ .real = 2.0, .i = -1.0, .j = 2.0, .k = 3.0 };
    const q3 = q1.mul(q2);
    try expectApproxEqRel(@as(f32, 8.0), q3.real, @as(f32, 0.001));
    try expectApproxEqRel(@as(f32, -9.0), q3.i, @as(f32, 0.001));
    try expectApproxEqRel(@as(f32, -2.0), q3.j, @as(f32, 0.001));
    try expectApproxEqRel(@as(f32, 11.0), q3.k, @as(f32, 0.001));
}

test "Quaternion inverse" {
    var q1 = Quat{ .real = -5.0, .i = -1.5, .j = 7.0, .k = 33.0 };

    try std.testing.expectError(Quat.QuaternionError.IsNotUnit, q1.inv());

    // Make quaternion to be unite.
    var q1_norm = q1.norm();
    q1.real /= q1_norm;
    q1.i /= q1_norm;
    q1.j /= q1_norm;
    q1.k /= q1_norm;

    // q^-1 * q = 1.0
    // var q2 = try q1.inv().mul(q1);
    var q2 = try q1.inv();
    q2 = q2.mul(q1);
    try expectApproxEqRel(@as(f32, 1.0), q2.real, @as(f32, 0.000001));
    try expectApproxEqAbs(@as(f32, 0.0), q2.i, @as(f32, 0.000001));
    try expectApproxEqAbs(@as(f32, 0.0), q2.j, @as(f32, 0.000001));
    try expectApproxEqAbs(@as(f32, 0.0), q2.k, @as(f32, 0.000001));

    // q * q^-1 = 1.0
    // var q3 = q1.mul(q1.inv());
    var q3 = try q1.inv();
    q3 = q1.mul(q3);
    try expectApproxEqRel(@as(f32, 1.0), q3.real, @as(f32, 0.000001));
    try expectApproxEqAbs(@as(f32, 0.0), q3.i, @as(f32, 0.000001));
    try expectApproxEqAbs(@as(f32, 0.0), q3.j, @as(f32, 0.000001));
    try expectApproxEqAbs(@as(f32, 0.0), q3.k, @as(f32, 0.000001));
}
