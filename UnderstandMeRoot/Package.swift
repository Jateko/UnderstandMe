// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UnderstandMeRoot",
    platforms: [
        // Declare the minimum platform versions, if needed.
        .iOS(.v13)
    ],
    products: [
        // Create a library product for each XCFramework you want to expose.
        // The 'targets' array references the names given in the targets section below.
        .library(
            name: "UnderstandMeRoot",
            type: .static,
            targets: ["UnderstandMeRoot", "MLKitTranslate"]
        )
    ],
    dependencies: [
      .package(url: "https://github.com/google/gtm-session-fetcher.git", exact: "3.5.0"),
      .package(url: "https://github.com/google/GoogleDataTransport.git", exact: "10.0.0"),
      .package(url: "https://github.com/google/GoogleUtilities.git", exact: "8.0.0"),
      .package(url: "https://github.com/google/promises.git", exact: "2.4.0"),
      .package(url: "https://github.com/ZipArchive/ZipArchive.git", exact: "2.4.2"),
//      .package(url: "https://github.com/nanopb/nanopb.git", exact: "2.30910.0")
    ],
    targets: [
//        // Each binary target corresponds to one zipped XCFramework.
        .binaryTarget(
            name: "MLKitNaturalLanguage",
            url: "https://github.com/Jateko/UnderstandMe/releases/download/1.0.0/MLKitNaturalLanguage.xcframework.zip",
            checksum: "92dd5f3278e705f008997be78e95b8d8a02de4af18ef551cd08f1d7a8dc313f7"
        ),
      .binaryTarget(
          name: "MLKitCommon",
          url: "https://github.com/Jateko/UnderstandMe/releases/download/1.0.0/MLKitCommon.xcframework.zip",
          checksum: "9b74eea03fd76bc69b93afdf31e78b250e13a917b41a9081802f7464929a9a44"
      ),
        .binaryTarget(
            name: "MLKitTranslate",
            url: "https://github.com/Jateko/UnderstandMe/releases/download/1.0.0/MLKitTranslate.xcframework.zip",
            checksum: "89217832fc862ca768778b22f64ced1ce6235b02de1056cf574a01b40667ded9"
        ),
      .target(
        name: "UnderstandMeRoot",
        dependencies: [
          "MLKitNaturalLanguage",
          "MLKitCommon",
          .product(name: "GoogleDataTransport", package: "GoogleDataTransport"),
          .product(name: "GULLogger", package: "GoogleUtilities"),
          .product(name: "GULUserDefaults", package: "GoogleUtilities"),
          .product(name: "GULEnvironment", package: "GoogleUtilities"),
          .product(name: "GTMSessionFetcher", package: "gtm-session-fetcher"),
          .product(name: "Promises", package: "Promises"),
          .product(name: "ZipArchive", package: "ziparchive"),
        ]
      )
    ]
)
