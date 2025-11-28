// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreSecurity",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CoreSecurity",
            targets: ["CoreSecurity"]
        ),
    ],
    targets: [
        .target(
            name: "CoreSecurity"
        ),
        .testTarget(
            name: "CoreSecurityTests",
            dependencies: ["CoreSecurity"]
        ),
    ]
)
