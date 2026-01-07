const std = @import("std");

pub fn main() !void {
    std.debug.print("Hello Moto!\n", .{});
}

test {
    std.testing.refAllDecls(@This());
}
