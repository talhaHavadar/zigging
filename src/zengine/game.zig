const std = @import("std");
const assert = std.debug.assert;
const Allocator = std.mem.Allocator;
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

allocator: Allocator,
options: Options = .{},
prng: std.Random.Xoroshiro128,
object_buckets: [GameObject.Priority.count]std.ArrayListUnmanaged(*GameObject),
id_object_map: std.AutoHashMapUnmanaged(@FieldType(GameObject, "id"), struct {
    bucket: u4,
    index: usize,
}),

pub fn init(alloc: Allocator, o: Options) Game {
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

    return Game{
        .allocator = alloc,
        .options = o,
        .prng = prng,
        .object_buckets = .{std.ArrayListUnmanaged(*GameObject).empty} ** GameObject.Priority.count,
        .id_object_map = .empty,
    };
}

pub fn deinit(self: *Game) void {
    for (&self.object_buckets) |*bucket| {
        for (bucket.items) |go| {
            go.deinit(self.allocator);
        }
        bucket.deinit(self.allocator);
    }
    self.id_object_map.deinit(self.allocator);
    rl.closeWindow();
}

pub fn spawn(self: *Game, go: *GameObject) !void {
    const bucket = @intFromEnum(go.flags.priority);
    const index = self.object_buckets[bucket].items.len;
    try self.object_buckets[bucket].append(self.allocator, go);
    try self.id_object_map.put(
        self.allocator,
        go.id,
        .{
            .index = index,
            .bucket = bucket,
        },
    );
}

pub fn run(self: Game) !void {
    while (!rl.windowShouldClose()) { // Detect window close button
        try self.update();

        rl.beginDrawing();
        defer rl.endDrawing();
        // TODO: non-ui related drawing ideally should be handled in begin/end mode
        self.draw();
        self.drawUI();
    }
}

fn update(self: Game) !void {
    for (self.object_buckets) |bucket| {
        for (bucket.items) |go| {
            try go.update(rl.getFrameTime());
        }
    }
}

fn draw(self: Game) void {
    rl.clearBackground(self.options.windowBackground);
    rl.drawText("Congrats! You created your first window!", 190, 200, 20, .light_gray);
    // TODO: draw entities
}

fn drawUI(self: Game) void {
    _ = self;
    // TODO: draw UI components
}

const GameObject = @import("game_object.zig");
