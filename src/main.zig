//! https://github.com/ulid/spec

const std = @import("std");
const string = []const u8;
const base32 = @import("./base32.zig");

pub const Factory = struct {
    epoch: i64,
    rand: std.rand.Random,

    pub fn init(epoch: i64, rand: std.rand.Random) Factory {
        return Factory{
            .epoch = epoch,
            .rand = rand,
        };
    }

    pub fn newULID(self: Factory) ULID {
        const now = std.time.milliTimestamp() - self.epoch;

        if (now > 281474976710655) {
         @panic("time.milliTimestamp() is higher than 281474976710655");
        }

        const ms: u64 = @intCast(u64, now);

        var buf: [16]u8 = undefined;
        buf[0] = @truncate(u8, ms >> 40);
        buf[1] = @truncate(u8, ms >> 32);
        buf[2] = @truncate(u8, ms >> 24);
        buf[3] = @truncate(u8, ms >> 16);
        buf[4] = @truncate(u8, ms >> 8);
        buf[5] = @truncate(u8, ms);
        
        self.rand.bytes(buf[6..]);

        return ULID{
            .id = buf,
        };
    }
};

///  01AN4Z07BY   79KA1307SR9X4MV3
///
/// |----------| |----------------|
///  Timestamp       Randomness
///    48bits          80bits
pub const ULID = struct {
    id: [16]u8,

    pub const BaseType = string;
    
    pub const Error = error{
        InvalidInputLength,
        Overflow,
    };

    pub fn parse(value: BaseType) Error!ULID {
        if (value.len != 26) return error.InvalidInputLength;
        if (value[0] > '7') {
          return error.Overflow;
        }

        var buffer: [16]u8 = undefined;
        base32.decode(&buffer, value);

        return ULID{
            .id = buffer,
        };
    }

    pub fn toString(self: ULID, alloc: std.mem.Allocator) !BaseType {
        var res = try std.ArrayList(u8).initCapacity(alloc, 16);
        defer res.deinit();

        try res.writer().print("{}", .{self});
        return res.toOwnedSlice();
    }

    pub const readField = parse;
    pub const bindField = toString;

    pub fn bytes(self: ULID) [26]u8 {
      return base32.encode(self.id);
    }

    pub fn format(self: ULID, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        _ = fmt;
        _ = options;
        try writer.writeAll(&self.bytes());
    }
};

const testing = std.testing;
const RndGen = std.rand.DefaultPrng;

test "parsed ulids equal source" {
    var rng = RndGen.init(0);
    var ulid = Factory.init(std.time.epoch.posix, rng.random());
    var ulid_base32 = ulid.newULID();
    var ulid_copy = try ULID.parse(&ulid_base32.bytes());
    try testing.expectEqualStrings(&ulid_base32.bytes(), &ulid_copy.bytes());
}
