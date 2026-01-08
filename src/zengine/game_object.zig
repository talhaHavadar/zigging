const std = @import("std");
const log = std.log.scoped(.zengine_gameObject);
const Allocator = std.mem.Allocator;

const GameObject = @This();

id: u64,
name: ?[]const u8 = null,
vtable: *const VTable,

pub const VTable = struct {
    update: *const fn (game_object: *GameObject, delta_time: f32) anyerror!void = defaultUpdate,
};

pub fn deinit(self: GameObject, allocator: Allocator) void {
    allocator.free(self.name);
}

pub fn defaultUpdate(self: *GameObject, delta_time: f32) anyerror!void {
    log.debug(
        "defaultUpdate(delta_time:{}) for {d}[name:{?s}] called, doing nothing..",
        .{ delta_time, self.id, self.name },
    );
}

pub fn update(self: *GameObject, delta_time: f32) anyerror!void {
    try self.vtable.update(self, delta_time);
}
