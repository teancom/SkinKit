// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SkinKit",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "SkinKit",
            targets: ["SkinKit"]
        ),
    ],
    targets: [
        .target(
            name: "SkinKit",
            path: "Sources/SkinKit"
        ),
        .testTarget(
            name: "SkinKitTests",
            dependencies: ["SkinKit"],
            path: "Tests/SkinKitTests"
        ),
    ]
)
