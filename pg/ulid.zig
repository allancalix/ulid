const std = @import("std");
const ulid = @import("src/main.zig");
const pg = @cImport({
  @cInclude("postgres.h");
});

const RndGen = std.rand.DefaultPrng;

const PostgresRnd = struct {
  const This = @This();

  field: u8,

  pub fn init() This {
      return .{
        .field = 0,
      };
  }

  pub fn random(self: *This) std.rand.Random {
      return std.rand.Random.init(self, fill);
  }

  pub fn fill(self: *This, buf: []u8) void {
    _ = self;

    // TODO(allancalix): Fix hardcoded buffer sizes.
    if (!pg.pg_strong_random(buf[0..8], comptime buf.len)) {
      @panic("could not generate random values");
    }
  }
};

pub export fn generate_ulid(buf: [*c]u8) void {
    var rng = PostgresRnd.init();
    var gen = ulid.Factory.init(std.time.epoch.posix, rng.random());
    var id = gen.newULID();

    std.mem.copy(u8, buf[0..16], id.id[0..16]);
}
