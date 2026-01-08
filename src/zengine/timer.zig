const std = @import("std");
const log = std.log.scoped(.zengine_timer);
const Allocator = std.mem.Allocator;
const Timer = @This();

game_object: GameObject,

pub fn init(id: u32) !Timer {
    return .{ .game_object = .{ .id = id, .vtable = &vtable } };
}

pub fn deinit(game_object: *GameObject, allocator: Allocator) void {
    const self: *Timer = @fieldParentPtr("game_object", game_object);
    _ = allocator;
    log.debug(
        "deinit for Timer[id: {d}] called",
        .{self.game_object.id},
    );
}

const vtable: GameObject.VTable = .{
    .update = update,
    .deinit = deinit,
};

pub fn update(game_object: *GameObject, delta_time: f32) anyerror!void {
    const self: *Timer = @fieldParentPtr("game_object", game_object);
    log.debug(
        "update(delta_time: {}) for Timer[id: {d},] called",
        .{ delta_time, self.game_object.id },
    );
}

const GameObject = @import("game_object.zig");
