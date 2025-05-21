// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Infrastructure",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NetworkProvider",
            targets: ["NetworkProvider"]
        ),
        .library(
            name: "PersistentStorages",
            targets: ["PersistentStorages"]
        )
    ],
    targets: [
        .target(name: "NetworkProvider"),
        .target(name: "PersistentStorages"),
        .testTarget(
            name: "InfrastructureTests",
            dependencies: ["NetworkProvider", "PersistentStorages"]
        )
    ]
)
