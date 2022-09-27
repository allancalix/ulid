const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("web", "src/main.zig");
    lib.addIncludeDir("postgres-REL_14_5/src/include");
    // lib.addIncludeDir("/opt/homebrew/Cellar/postgresql@14/14.5_3/include/postgresql@14");
    lib.setBuildMode(mode);
    lib.install();

    const main_tests = b.addTest("src/main.zig");
    main_tests.addIncludeDir("postgres-REL_14_5/src/include");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
