// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SelectableRowsViewKit",
    platforms: [
         .iOS(.v16),
         .macOS(.v13),
         .watchOS(.v9),
         .tvOS(.v16)
     ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SelectableRowsViewKit",
            targets: ["SelectableRowsViewKit"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SelectableRowsViewKit"),
        .testTarget(
            name: "SelectableRowsViewKitTests",
            dependencies: ["SelectableRowsViewKit"]
        ),
    ]
)
