// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "CaseKeyPath",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "CaseKeyPath",
            targets: ["CaseKeyPath"]),
        .library(
            name: "UIExamples",
            targets: ["UIExamples"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "603.0.0"),
    ],
    targets: [
        .target(
            name: "CaseKeyPath",
            dependencies: ["CaseKeyPathMacros"]
        ),
        .macro(
            name: "CaseKeyPathMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "UIExamples",
            dependencies: ["CaseKeyPath"]
        ),
        .executableTarget(
            name: "Examples",
            dependencies: ["CaseKeyPath"]
        ),
        .testTarget(
            name: "CaseKeyPathTests",
            dependencies: ["CaseKeyPath"]),
    ]
)
