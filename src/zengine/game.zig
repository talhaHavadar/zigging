const std = @import("std");
const assert = std.debug.assert;
const log = std.log.scoped(.zengine_game);
const rl = @import("raylib");

const Game = @This();
pub const Options = struct {
    windowWidth: i32 = 800,
    windowHeight: i32 = 450,
    title: [:0]const u8 = "Zigging right now..",
    windowBackground: rl.Color = .white,
    randomSeed: ?u64 = null,
};

options: Options = .{},
prng: std.Random.Xoroshiro128,

pub fn init(o: Options) Game {
    rl.initWindow(o.windowWidth, o.windowHeight, o.title);
    rl.setExitKey(.null);

    var seed: u64 = undefined;
    if (o.randomSeed == null) {
        std.posix.getrandom(std.mem.asBytes(&seed)) catch {
            log.err("not able to create seed for prng!", .{});
            unreachable;
        };
    } else {
        seed = o.randomSeed.?;
    }
    const prng = std.Random.Xoroshiro128.init(seed);

    return Game{ .options = o, .prng = prng };
}

pub fn deinit(self: Game) void {
    _ = self;
    rl.closeWindow();
}

pub fn run(self: Game) void {
    while (!rl.windowShouldClose()) { // Detect window close button
        self.update();

        rl.beginDrawing();
        defer rl.endDrawing();
        self.draw();
    }
}

fn update(self: Game) void {
    _ = self;
    // TODO: update game objects, entities
}

fn draw(self: Game) void {
    rl.clearBackground(self.options.windowBackground);
    rl.drawText("Congrats! You created your first window!", 190, 200, 20, .light_gray);
    // TODO: draw entities
}
