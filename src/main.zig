const std = @import("std");

pub fn main() !void {
    const game = Game.init(.{
        .windowWidth = 800,
        .windowHeight = 450,
        .title = "Hello raylib",
    });
    defer game.deinit();

    game.run();
}

test {
    std.testing.refAllDecls(@This());
}

const Game = @import("game.zig");
