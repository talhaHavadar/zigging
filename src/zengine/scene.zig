const Scene = @This();

game_object: GameObject,

pub fn init(id: u64, name: []const u8) Scene {
    return .{ .game_object = .{ .id = id, .name = name, .vtable = &vtable } };
}
const vtable: GameObject.VTable = .{};

const GameObject = @import("game_object.zig");
