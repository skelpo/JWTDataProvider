// swift-tools-version:4.0
import PackageDescription
let package = Package(
    name: "JWTDataProvider",
    products: [
        .library(name: "JWTDataProvider", targets: ["JWTDataProvider"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .exact("3.0.0-beta.2")),
        .package(url: "https://github.com/vapor/jwt.git", .exact("3.0.0-beta.1")),
        .package(url: "git@github.com:skelpo/JSON.git", .exact("0.6.0"))
    ],
    targets: [
        .target(name: "JWTDataProvider", dependencies: ["Vapor", "JWT", "JSONKit"]),
        .testTarget(name: "JWTDataProviderTests", dependencies: ["JWTDataProvider"]),
    ]
)
