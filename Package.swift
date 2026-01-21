// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-finite-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "Finite Primitives",
            targets: ["Finite Primitives"]
        )
    ],
    dependencies: [
        .package(path: "../swift-ordinal-primitives"),
        .package(path: "../swift-collection-primitives"),
        .package(path: "../swift-index-primitives"),
    ],
    targets: [
        .target(
            name: "Finite Primitives",
            dependencies: [
                .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
                .product(name: "Collection Primitives", package: "swift-collection-primitives"),
                .product(name: "Index Primitives", package: "swift-index-primitives"),
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableExperimentalFeature("Lifetimes"),
        .strictMemorySafety()
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
