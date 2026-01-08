const std = @import("std");
const log = std.log.scoped(.zengine_timer);
const Timer = @This();

game_object: GameObject,

pub fn init(id: u32) Timer {
    return .{ .game_object = .{ .id = id, .vtable = &vtable } };
}
const vtable: GameObject.VTable = .{
    .update = update,
};

pub fn update(game_object: *GameObject, delta_time: f32) anyerror!void {
    const self: *Timer = @fieldParentPtr("game_object", game_object);
    log.debug(
        "update(delta_time: {}) for Timer[id: {d}, name: {?s}] called",
        .{ delta_time, self.game_object.id, self.game_object.name },
    );
}

const GameObject = @import("game_object.zig");
