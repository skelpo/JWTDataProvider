// swift-tools-version:4.0
import PackageDescription
let package = Package(
    name: "JWTDataProvider",
    products: [
        .library(name: "JWTDataProvider", targets: ["JWTDataProvider"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/vapor/jwt.git", from: "3.0.0-rc"),
        .package(url: "git@github.com:skelpo/JSON.git", from: "0.10.0")
    ],
    targets: [
        .target(name: "JWTDataProvider", dependencies: ["Vapor", "JWT", "JSONKit"]),
        .testTarget(name: "JWTDataProviderTests", dependencies: ["JWTDataProvider"]),
    ]
)
