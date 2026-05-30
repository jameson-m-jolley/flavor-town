//! By convention, root.zig is the root source file when making a package.
const std = @import("std");

//markove type
//---------------------------------------------
pub fn markove_type(
    comptime size: usize,
    comptime alignment: std.mem.Alignment,
    comptime reader_line_memory_len: usize,
) type {
    return struct {
        //we need the probs in a map
        path: []const u8,
        index: std.AutoHashMap([]const u8, u32), // name -> id
        chain: std.AutoHashMap(u32, std.AutoHashMap(u32, f32)),
        states: std.ArrayListAlignedUnmanaged([size]f32, alignment),
        pub fn init(allocator: std.mem.Allocator, _path: []const u8, start_state: [size]f32) !@This() {
            var ret: @This() = .{
                .path = _path,
                .chain = std.AutoHashMap(u32, std.AutoHashMap(u32, f32)).init(allocator),
                .index = std.AutoHashMap([]const u8, u32).init(allocator),
                .states = try std.ArrayListAlignedUnmanaged([size]f32, alignment).initCapacity(allocator, 1),
            };

            try ret.states.append(allocator, start_state);
            return ret;
        }

        pub fn load_csv(this: *@This(), io: std.Io) !void {
            // 1. allocate a buffer for stdin reads
            var file = try std.Io.Dir.cwd().openFile(io, this.path, .{ .mode = .read_only });
            defer file.close(io);
            var buffer: [reader_line_memory_len]u8 = undefined;
            var reader_w = file.reader(io, &buffer);
            var reader = &reader_w.interface;

            while (reader.takeDelimiterInclusive('\n')) |str| {
                const fixed = if (str.len >= 4) str[2 .. str.len - 3] else &[_]u8{};
                // we now have the line we need to split it
                //var split = std.mem.splitAny(u8, str, "[");
                var split = std.mem.splitSequence(u8, fixed, ",");
                while (split.next()) |line| {
                    // un quote the vals
                    const unquote = if (line.len >= 3) line[3 .. line.len - 2] else &[_]u8{};
                    std.debug.print("{s}\n\n", .{unquote});
                }
            } else |err| {
                std.debug.print("{}", .{err});
            }
        }
    };
}

//____________________tests_______________________________________

test "markove_type_init" {
    const m_test = markove_type(6, .@"4", 4096);
    const aloc = std.heap.page_allocator;
    const start_state: [6]f32 = .{ 1, 2, 3, 4, 5, 6 };
    const item = try m_test.init(aloc, "data/recipes_ingredients.csv", start_state);
    try std.testing.expect(!std.mem.eql(u8, item.path, ""));
}

test "parse_csv" {
    const m_test = markove_type(6, .@"4", 4000096);
    const aloc = std.heap.page_allocator;
    const start_state: [6]f32 = .{ 1, 2, 3, 4, 5, 6 };
    var item = try m_test.init(aloc, "data/recipes_ingredients.csv", start_state);
    try item.load_csv();
}
//____________________tests_______________________________________

//---------------------------------------------
pub fn fog_of_war_search() type {
    return struct {
        // we need sklern for this and the old mod
        pub fn init() @This() {
            return .{};
        }
    };
}
