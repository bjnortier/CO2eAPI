// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "CO2eAPI",
    products: [
        .library(name: "CO2eAPI", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/sqlite.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/database-kit.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["DatabaseKit", "SQLite", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
