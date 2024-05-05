const std = @import("std");

const Path = std.Build.LazyPath;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const wren_vm = b.addStaticLibrary(.{
        .name = "wren",
        .target = target,
        .optimize = optimize,
    });
    wren_vm.addIncludePath(Path{ .path = "src/include" });
    wren_vm.addIncludePath(Path{ .path = "src/vm" });
    wren_vm.addCSourceFiles(.{
        .files = &.{
            "src/vm/wren_compiler.c",
            "src/vm/wren_core.c",
            "src/vm/wren_debug.c",
            "src/vm/wren_primitive.c",
            "src/vm/wren_utils.c",
            "src/vm/wren_value.c",
            "src/vm/wren_vm.c",
        },
        .flags = &.{
            // "-std=c++17",
            // "-fno-rtti",
            // "-frtti",
            // "-fno-exceptions",
            // "-fexceptions",
        },
    });
    wren_vm.installHeadersDirectory(b.path("src/include"), "", .{
        .include_extensions = &.{
            ".h",
        },
        .exclude_extensions = &.{
            "am",
            "gitignore",
        },
    });
    wren_vm.addIncludePath(Path{ .path = "src/optional" });

    wren_vm.addCSourceFiles(.{
        .files = &.{
            "src/optional/wren_opt_meta.c",
            "src/optional/wren_opt_random.c",
        },
        .flags = &.{
            // "-std=c++17",
            // "-fno-rtti",
            // "-frtti",
            // "-fno-exceptions",
            // "-fexceptions",
        },
    });
    wren_vm.linkLibC();
    b.installArtifact(wren_vm);
}
