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
        .package(path: "../Architecture"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk",
            .upToNextMajor(from: "2.20.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DataSource",
            dependencies: [
                "Domain",
                "Architecture",
                .product(name: "KakaoSDKUser",
                         package: "kakao-ios-sdk")
            ]
        ),
        .testTarget(
            name: "DataSourceTests",
            dependencies: ["DataSource"]),
    ]
)
