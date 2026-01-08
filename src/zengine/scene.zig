const Scene = @This();

game_object: GameObject,

pub fn init(id: u32) Scene {
    return .{ .game_object = .{ .id = id, .vtable = &vtable } };
}
const vtable: GameObject.VTable = .{};

const GameObject = @import("game_object.zig");
