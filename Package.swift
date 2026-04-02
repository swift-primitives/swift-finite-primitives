// swift-tools-version: 6.3

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
        ),
        .library(
            name: "Finite Primitives Test Support",
            targets: ["Finite Primitives Test Support"]
        )
    ],
    dependencies: [
        .package(path: "../swift-ordinal-primitives"),
        .package(path: "../swift-identity-primitives"),
        .package(path: "../swift-index-primitives"),
        .package(path: "../swift-algebra-primitives"),
        .package(path: "../swift-algebra-group-primitives"),
        .package(path: "../swift-comparison-primitives"),
        .package(path: "../swift-optic-primitives"),
        .package(path: "../swift-sequence-primitives"),
    ],
    targets: [
        // MARK: - Core
        .target(
            name: "Finite Primitives Core",
            dependencies: [
                .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
                .product(name: "Identity Primitives", package: "swift-identity-primitives"),
                .product(name: "Index Primitives", package: "swift-index-primitives"),
                .product(name: "Sequence Primitives", package: "swift-sequence-primitives"),
            ]
        ),
        // MARK: - Umbrella
        .target(
            name: "Finite Primitives",
            dependencies: [
                "Finite Primitives Core",
                .product(name: "Algebra Primitives", package: "swift-algebra-primitives"),
                .product(name: "Algebra Group Primitives", package: "swift-algebra-group-primitives"),
                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
                .product(name: "Optic Primitives", package: "swift-optic-primitives"),
            ]
        ),
        .target(
            name: "Finite Primitives Test Support",
            dependencies: [
                "Finite Primitives",
                .product(name: "Index Primitives Test Support", package: "swift-index-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Finite Primitives Tests",
            dependencies: [
                "Finite Primitives",
                "Finite Primitives Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
