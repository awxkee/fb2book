// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fb2book",
    platforms: [
      .iOS(.v13),
      .macOS(.v10_15),
      .tvOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "fb2book",
            targets: ["fb2book"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/CoreOffice/XMLCoder.git", from: "0.14.0"),
         .package(url: "https://github.com/pointfreeco/swift-html.git", from: "0.4.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "fb2book",
            dependencies: [.product(name: "XMLCoder", package: "XMLCoder"),
                           .product(name: "Html", package: "swift-html")]),
        .testTarget(
            name: "fb2parserTests",
            dependencies: ["fb2book"]),
    ]
)
