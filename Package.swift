// swift-tools-version:4.0
import PackageDescription
let package = Package(
    name: "JWTDataProvider",
    products: [
        .library(name: "JWTDataProvider", targets: ["JWTDataProvider"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-beta.3.1.2"),
        .package(url: "https://github.com/vapor/jwt.git", from: "3.0.0-beta.1.1"),
        .package(url: "git@github.com:skelpo/JSON.git", from: "0.7.2")
    ],
    targets: [
        .target(name: "JWTDataProvider", dependencies: ["Vapor", "JWT", "JSONKit"]),
        .testTarget(name: "JWTDataProviderTests", dependencies: ["JWTDataProvider"]),
    ]
)
