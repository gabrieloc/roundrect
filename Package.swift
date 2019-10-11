// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Roundrect",
  products: [
    .library(
      name: "Roundrect",
      targets: ["Roundrect"])
  ],
  targets: [
    .target(
      name: "Roundrect",
      dependencies: []
    ),
    .testTarget(
      name: "RoundrectTests",
      dependencies: ["Roundrect"],
      path: "RoundrectTests")
  ]
)
