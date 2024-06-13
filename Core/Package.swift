// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Core",
            targets: [
                "Architecture",
                "ExampleScene",
            ]
        )
    ],
    targets: [
        .target(name: "Architecture"),
        .target(
            name: "ExampleScene",
            dependencies: ["Architecture"]
        )
    ]
)

