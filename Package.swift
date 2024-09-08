// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WeatherPackage",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WeatherPackage",
            targets: ["WeatherPackage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Yoji-kms/WeatherNetworkService", branch: "main"),
        .package(url: "https://github.com/Yoji-kms/LocationService", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WeatherPackage",
            dependencies: [
                .product(name: "NetworkService", package: "weathernetworkservice"),
                .product(name: "LocationService", package: "locationservice")
            ]
        ),
        .testTarget(
            name: "WeatherPackageTests",
            dependencies: ["WeatherPackage"]
        ),
    ]
)
