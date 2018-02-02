// swift-tools-version:4.0
import PackageDescription
let package = Package(
    name: "JWTDataProvider",
    products: [
        .library(name: "JWTDataProvider", targets: ["JWTDataProvider"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .branch("beta")),
        .package(url: "https://github.com/vapor/jwt.git", .branch("beta")),
        .package(url: "git@github.com:skelpo/JSON.git", .exact("0.1.1"))
    ],
    targets: [
        .target(name: "JWTDataProvider", dependencies: ["Vapor", "JWT", "JSON"]),
        .testTarget(name: "JWTDataProviderTests", dependencies: ["JWTDataProvider"]),
    ]
)
