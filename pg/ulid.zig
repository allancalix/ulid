const std = @import("std");
const ulid = @import("src/main.zig");

const RndGen = std.rand.DefaultPrng;

pub export fn generate_ulid(buf: [*c]u8) void {
    var rng = RndGen.init(0);
    var gen = ulid.Factory.init(std.time.epoch.posix, rng.random());
    var id = gen.newULID();
    std.debug.print("{s}\n", .{id.bytes()});

    std.mem.copy(u8, buf[0..16], id.id[0..16]);
}
