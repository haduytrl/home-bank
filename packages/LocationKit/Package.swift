// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocationKit",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LocationKit",
            targets: ["LocationKit"]),
    ],
    dependencies: [
        .package(path: "../CoreKit"),
        .package(path: "../DomainKit"),
        .package(path: "../DataKit"),
        .package(path: "../Infrastructure")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LocationKit",
            dependencies: [
                "CoreKit",
                "DataKit",
                .product(name: "DomainRepositories", package: "DomainKit"),
                .product(name: "GlobalEntities", package: "DomainKit"),
                .product(name: "GlobalUsecase", package: "DomainKit"),
                .product(name: "PersistentStorages", package: "Infrastructure")
            ]
        ),
        .testTarget(
            name: "LocationKitTests",
            dependencies: ["LocationKit"]
        ),
    ]
)
