const std = @import("std");

const QuaternionF32 = Quaternion(f32);
const QuaternionF64 = Quaternion(f64);

fn Quaternion(comptime T: type) type {
    return struct {
        real: T = 0.0, // real or scalar part of quaternion
        i: T = 0.0, // first imaginary number
        j: T = 0.0, // second imaginary number
        k: T = 0.0, // third imaginary number

        /// Add two quaternions and return new one.
        fn add(self: *const @This(), rhs: Quaternion(T)) Quaternion(T) {
            var q = self.*;
            q.real += rhs.real;
            q.i += rhs.i;
            q.j += rhs.j;
            q.k += rhs.k;
            return q;
        }

        /// Substract two quaternions and return new one.
        fn sub(self: *const @This(), rhs: Quaternion(T)) Quaternion(T) {
            var q = self.*;
            q.real -= rhs.real;
            q.i -= rhs.i;
            q.j -= rhs.j;
            q.k -= rhs.k;
            return q;
        }

        /// Multiplication/product two quaternions.
        /// Return new quaternion as a result of multipication/product two
        /// quaternions.
        fn mul(self: *const @This(), rhs: Quaternion(T)) Quaternion(T) {
            var q = Quaternion(T){};

            q.real = self.real * rhs.real;
            q.real -= self.i * rhs.i;
            q.real -= self.j * rhs.j;
            q.real -= self.k * rhs.k;

            q.i = self.real * rhs.i;
            q.i += self.i * rhs.real;
            q.i += self.j * rhs.k;
            q.i -= self.k * rhs.j;

            q.j = self.real * rhs.j;
            q.j -= self.i * rhs.k;
            q.j += self.j * rhs.real;
            q.j += self.k * rhs.i;

            q.k = self.real * rhs.k;
            q.k += self.i * rhs.j;
            q.k -= self.j * rhs.i;
            q.k += self.k * rhs.real;

            return q;
        }

        /// Norm of quaternion. Typicaly mark as ||, for example |q|.
        fn norm(self: *const @This()) T {
            var value: T = 0.0;
            value += self.real * self.real;
            value += self.i * self.i;
            value += self.j * self.j;
            value += self.k * self.k;
            return std.math.sqrt(value);
        }

        /// Conjugate. Typicaly mark as *, for example q*.
        fn conj(self: *const @This()) Quaternion(T) {
            return Quaternion(T){ .real = self.real, .i = (-self.i), .j = (-self.j), .k = (-self.k) };
        }

        ///
        const QuaternionError = error{
            IsNotUnit,
        };

        /// Inverse. Defined as q^-1 = (q*) / (|q|^2)
        fn inv(self: *const @This()) Quaternion(T).QuaternionError!Quaternion(T) {
            if (self.isUnit() == false) {
                return QuaternionError.IsNotUnit;
            }
            var q = self.conj();
            var norm2 = self.norm() * self.norm();
            q.real /= norm2;
            q.i /= norm2;
            q.j /= norm2;
            q.k /= norm2;
            return q;
        }

        /// Checks, if quaternion is unit (norm of quaternion is equal 1.0).
        fn isUnit(self: *const Quaternion(T)) bool {
            var n = self.norm();
            return std.math.approxEqRel(T, n, @as(T, 1.0), @as(T, 0.000001));
        }
    };
}
