// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppWidgets",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "AppWidgets",
            targets: ["AppWidgets"]
        ),
    ],
    dependencies: [
        .package(path: "../CoreKit")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppWidgets",
            dependencies: [
                "CoreKit"
            ]
        ),
        .testTarget(
            name: "AppWidgetsTests",
            dependencies: ["AppWidgets"]
        ),
    ]
)
