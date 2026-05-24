// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MisakiSwiftLite",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "MisakiSwiftLite", targets: ["MisakiSwiftLite"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MisakiSwiftLite",
            dependencies: [],
            path: "Sources/MisakiSwiftLite",
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "MisakiSwiftLiteTests",
            dependencies: ["MisakiSwiftLite"],
            path: "Tests/MisakiSwiftLiteTests"
        ),
    ]
)
