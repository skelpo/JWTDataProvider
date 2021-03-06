// swift-tools-version:4.0
import PackageDescription
let package = Package(
    name: "JWTDataProvider",
    products: [
        .library(name: "JWTDataProvider", targets: ["JWTDataProvider"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/skelpo/JSON.git", from: "0.13.0")
    ],
    targets: [
        .target(name: "JWTDataProvider", dependencies: ["Vapor", "JWT", "JSONKit"]),
        .testTarget(name: "JWTDataProviderTests", dependencies: ["JWTDataProvider"]),
    ]
)
