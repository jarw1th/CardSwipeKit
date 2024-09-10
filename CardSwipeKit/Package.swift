// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CardSwipeKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "CardSwipeKit",
            targets: ["CardSwipeKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CardSwipeKit",
            dependencies: [],
            path: "Sources/CardSwipeKit"
        ),
        .testTarget(
            name: "CardSwipeKitTests",
            dependencies: ["CardSwipeKit"],
            path: "Tests"
        )
    ]
)
