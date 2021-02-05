// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Roundrect",
  platforms: [
    .iOS(.v11),
  ],
  products: [
    .library(
      name: "Roundrect",
      targets: ["Roundrect"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.8.0"),
  ],
  targets: [
    .target(
      name: "Roundrect",
      dependencies: []
    ),
    .testTarget(
      name: "RoundrectTests",
      dependencies: ["Roundrect", "SnapshotTesting"]
    ),
  ]
)
