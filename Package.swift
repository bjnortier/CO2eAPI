// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "CO2eWeb",
    products: [
        .library(name: "CO2eWeb", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.12.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["SQLite", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

