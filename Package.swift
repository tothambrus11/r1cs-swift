// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "R1CSSwift",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "R1CS",
            targets: ["R1CS"]),
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt", from: "5.7.0"),
    ],
    targets: [
        .target(
            name: "R1CS",
            dependencies: [
                .product(name: "BigInt", package: "BigInt"),
            ]),
        .testTarget(
            name: "R1CSTests",
            dependencies: ["R1CS"]),
    ]
)