// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataSource",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DataSource",
            targets: ["DataSource"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../Architecture")
//        .package(
//            url: "https://github.com/insub4067/DependencyContainer.git",
//            .upToNextMajor(from: "1.0.2"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DataSource",
            dependencies: [
                "Domain",
                "Architecture"
            ]
        ),
        .testTarget(
            name: "DataSourceTests",
            dependencies: ["DataSource"]),
    ]
)
