const std = @import("std");

pub fn main() !void {
    var debug_allocator: std.heap.DebugAllocator(.{ .thread_safe = true }) = .init;
    defer _ = debug_allocator.deinit();
    const allocator = debug_allocator.allocator();

    var game = Game.init(allocator, .{
        .windowWidth = 800,
        .windowHeight = 450,
        .title = "Hello raylib",
    });
    defer game.deinit();

    var timer = try Timer.init(166);
    try game.spawn(&timer.game_object);

    try game.run();
}

test {
    std.testing.refAllDecls(@This());
}

const Game = @import("zengine/game.zig");
const Timer = @import("zengine/timer.zig");
