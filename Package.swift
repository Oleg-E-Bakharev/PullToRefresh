// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PullToRefresh",
    platforms: [.iOS("13.0")],
    products: [
        .library(
            name: "PullToRefresh",
            targets: ["PullToRefresh"]),
    ],
    targets: [
        .target(
            name: "PullToRefresh"),
        .testTarget(
            name: "PullToRefreshTests",
            dependencies: ["PullToRefresh"]),
    ]
)
