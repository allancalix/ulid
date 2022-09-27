const std = @import("std");
const ulid = @import("ulid");
const pg = @cImport({
  @cInclude("postgres.h");
});

const RndGen = std.rand.DefaultPrng;

const PostgresRnd = struct {
  const This = @This();
  ptr: *anyopaque,

  pub fn init() This {
      return .{ .ptr = undefined, };
  }

  pub fn random(self: *This) std.rand.Random {
      return std.rand.Random.init(self, fill);
  }

  pub fn fill(self: *This, buf: []u8) void {
    _ = self;

    // TODO(allancalix): Fix hardcoded buffer sizes.
    if (!pg.pg_strong_random(buf[0..8], comptime buf.len)) {
      // Fallback RNG if Postgres cannot provide rng.
      const seed = @truncate(u64, @bitCast(u128, std.time.nanoTimestamp()));
      var prng = std.rand.DefaultPrng.init(seed);
      prng.random().bytes(buf);
    }
  }
};

pub export fn generate_ulid(buf: [*c]u8) void {
    var rng = PostgresRnd.init();
    var gen = ulid.Factory.init(std.time.epoch.posix, rng.random());
    var id = gen.newULID();

    comptime if (id.id.len != ulid.ULID_SIZE) {
      @panic("unexpected ulid id size");
    };

    std.mem.copy(u8, buf[0..ulid.ULID_SIZE], &id.id);
}
