// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MacKeyboardiOS",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "MacKeyboardiOS",
            targets: ["MacKeyboardiOS"])
    ],
    targets: [
        .target(
            name: "MacKeyboardiOS",
            dependencies: [],
            path: "Sources"
        )
    ]
)

