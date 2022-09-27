const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("ulid", "pg/ulid.zig");
    lib.setBuildMode(mode);
    lib.install();

    const pg_ulid = b.addSharedLibrary("pg_ulid", null, b.version(0, 1, 0));
    pg_ulid.setBuildMode(mode);
    pg_ulid.addCSourceFile("pg/ulid.c", &[_][]const u8{"-c", "-std=c99"});
    pg_ulid.addIncludePath("../web/postgres-REL_14_5/src/include");
    pg_ulid.linkLibrary(lib);
    pg_ulid.linkSystemLibrary("c");
    pg_ulid.install();

    // b.default_step.dependOn(&exe.step);
    // const run_cmd = exe.run();

    // const test_step = b.step("run", "Run the program");
    // test_step.dependOn(&run_cmd.step);

    // const main_tests = b.addTest("src/main.zig");
    // main_tests.addIncludeDir("postgres-REL_14_5/src/include");
    // main_tests.setBuildMode(mode);

    // const test_step = b.step("test", "Run library tests");
    // test_step.dependOn(&main_tests.step);
}
