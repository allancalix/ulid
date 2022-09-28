const std = @import("std");
const Pkg = std.build.Pkg;

const ulid = Pkg{
    .name = "ulid",
    .source = .{ .path = "src/main.zig" },
};

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const pg_ulid_lib = b.addStaticLibrary("pg_ulid", "pg/ulid.zig");
    pg_ulid_lib.setBuildMode(mode);
    pg_ulid_lib.addIncludePath("postgresql-14.5/src/include");
    pg_ulid_lib.addPackage(ulid);
    pg_ulid_lib.linkSystemLibrary("c");
    pg_ulid_lib.install();

    const pg_ulid = b.addSharedLibrary("ext_pg_ulid", null, b.version(0, 1, 0));
    pg_ulid.setTarget(target);
    pg_ulid.setBuildMode(mode);
    pg_ulid.addCSourceFile("pg/ulid.c", &[_][]const u8{"-c"});
    pg_ulid.addIncludePath("postgresql-14.5/src/include");
    pg_ulid.linkLibrary(pg_ulid_lib);
    pg_ulid.linkSystemLibrary("c");
    pg_ulid.install();

    // b.default_step.dependOn(&exe.step);
    // const run_cmd = exe.run();

    // const test_step = b.step("run", "Run the program");
    // test_step.dependOn(&run_cmd.step);

     const main_tests = b.addTest("src/main.zig");
     main_tests.setBuildMode(mode);

     const test_step = b.step("test", "Run library tests");
     test_step.dependOn(&main_tests.step);
}
