const std = @import("std");
const rl = @import("raylib");

const Game = @This();
pub const Options = struct {
    windowWidth: u64 = 800,
    windowHeight: u64 = 450,
    title: [:0]const u8 = "Zigging right now..",
    windowBackground: rl.Color = .white,
    randomSeed: u64 = 0,
};

options: Options = .{},

pub fn init(comptime o: Options) Game {
    rl.initWindow(o.windowWidth, o.windowHeight, o.title);
    rl.setExitKey(.null);

    // random seed
    // var seed: u64 = undefined;
    // std.posix.getrandom(std.mem.asBytes(&seed)) catch unreachable;

    var prng = std.Random.Xoroshiro128.init(o.randomSeed);
    std.debug.print("random: {d}\n", .{prng.random().int(u8)});

    return Game{ .options = o };
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
