const std = @import("std");
const Allocator = std.mem.Allocator;
const Scene = @This();

game_object: GameObject,

pub fn init(id: u32) Scene {
    return .{ .game_object = .{ .id = id, .vtable = &vtable } };
}

pub fn deinit(game_object: *GameObject, allocator: Allocator) void {
    const self: *Scene = @fieldParentPtr("game_object", game_object);
    _ = self;
    _ = allocator;
}

const vtable: GameObject.VTable = .{
    .deinit = deinit,
};

const GameObject = @import("game_object.zig");
