// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "NaturalMath",
    products: [
        .library(
            name: "NaturalMath",
            targets: ["NaturalMath"]),
    ],
    targets: [
        .target(
            name: "NaturalMath"),
        .testTarget(
            name: "NaturalMathTests",
            dependencies: ["NaturalMath"]),
    ]
)
