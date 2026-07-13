// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "CasePathable",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CasePathable",
            targets: ["CasePathable"]),
        .library(
            name: "UIExamples",
            targets: ["UIExamples"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "603.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CasePathable",
            dependencies: ["CasePathableMacros"]
        ),
        .macro(
            name: "CasePathableMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "UIExamples",
            dependencies: ["CasePathable"]
        ),
        .executableTarget(
            name: "Examples",
            dependencies: ["CasePathable"]
        ),
        .testTarget(
            name: "CasePathableTests",
            dependencies: ["CasePathable"]),
    ]
)
