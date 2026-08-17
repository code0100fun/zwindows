const std = @import("std");
const zwindows = @import("zwindows");
const zd3d12 = @import("zd3d12");
const zxaudio2 = @import("zxaudio2");

test {
    refAllDeclsRecursive(zwindows);
    refAllDeclsRecursive(zd3d12);
    refAllDeclsRecursive(zxaudio2);
}

// std.testing.refAllDeclsRecursive was removed in Zig 0.16.
fn refAllDeclsRecursive(comptime T: type) void {
    inline for (comptime std.meta.declarations(T)) |decl| {
        if (@TypeOf(@field(T, decl.name)) == type) {
            switch (@typeInfo(@field(T, decl.name))) {
                .@"struct", .@"enum", .@"union", .@"opaque" => refAllDeclsRecursive(@field(T, decl.name)),
                else => {},
            }
        }
        _ = &@field(T, decl.name);
    }
}
