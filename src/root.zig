//! By convention, root.zig is the root source file when making a package.
const std = @import("std");
const Io = std.Io;

/// This is a documentation comment to explain the `printAnotherMessage` function below.
///
/// Accepting an `Io.Writer` instance is a handy way to write reusable code.
pub fn printAnotherMessage(writer: *Io.Writer) Io.Writer.Error!void {
    try writer.print("Run `zig build test` to run the tests.\n", .{});
}

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try std.testing.expect(add(3, 7) == 10);
}

//markove type
//---------------------------------------------
pub fn markove_type(comptime size: usize) type {
    return struct {
        //we need the probs in a map
        json_path: []const u8,
        index: std.AutoHashMap([]const u8, u32), // name -> id
        chain: std.AutoHashMap(u32, std.AutoHashMap(u32, f32)),
        states: std.ArrayListAlignedUnmanaged([size]f32),

        pub fn init() @This() {
            return .{};
        }
    };
}

test "markove_type" {
    const m_test = markove_type(20);
    _ = m_test;
}

//---------------------------------------------
pub fn fog_of_war_search() type {
    return struct {
        // we need sklern for this and the old mod
        pub fn init() @This() {
            return .{};
        }
    };
}
