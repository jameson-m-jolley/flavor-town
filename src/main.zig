const std = @import("std");
const lib = @import("flavor_town");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const model = lib.markove_type(251105, .@"4", 1250);
    const aloc = std.heap.page_allocator;
    var arre = std.heap.ArenaAllocator.init(aloc);
    defer arre.deinit();
    var pred = try model.init(
        arre.allocator(),
        "data/clean.csv",
        .{0} ** 251105,
    );
    try pred.load_csv(io);
}
