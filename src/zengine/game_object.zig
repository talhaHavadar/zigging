///
/// ┌─────────────────────────────────────────────────────────────────┐
/// │                    GameObject (16 bytes)                        │
/// ├─────────────────────────────────────────────────────────────────┤
/// │ Offset │ Field    │ Size  │ Alignment │ Notes                   │
/// ├────────┼──────────┼───────┼───────────┼─────────────────────────┤
/// │ 0      │ vtable   │ 8B    │ 8         │ pointer                 │
/// │ 8      │ id       │ 4B    │ 4         │ u32                     │
/// │ 12     │ flags    │ 4B    │ 4         │ packed struct(u32)      │
/// └─────────────────────────────────────────────────────────────────┘
/// Total: 16 bytes
///
const std = @import("std");
const log = std.log.scoped(.zengine_gameObject);
const Allocator = std.mem.Allocator;

const GameObject = @This();

pub const Priority = enum(u4) {
    critical = 0xF,
    high = 0xA,
    usual = 0x6,
    low = 0x3,
    ui = 0x0,

    pub const count = std.meta.fields(Priority).len;
};

id: u32,
flags: packed struct(u32) {
    priority: Priority = .usual,
    is_enabled: bool = true,
    is_visible: bool = true,
    _reserved: u26 = 0,
},
vtable: *const VTable,

pub const VTable = struct {
    update: *const fn (game_object: *GameObject, delta_time: f32) anyerror!void = defaultUpdate,
};

pub fn deinit(self: GameObject, allocator: Allocator) void {
    _ = self;
    _ = allocator;
}

pub fn defaultUpdate(self: *GameObject, delta_time: f32) anyerror!void {
    log.debug(
        "defaultUpdate(delta_time:{}) for GameObject[id: {d}] called, doing nothing..",
        .{ delta_time, self.id },
    );
}

pub fn update(self: *GameObject, delta_time: f32) anyerror!void {
    try self.vtable.update(self, delta_time);
}
