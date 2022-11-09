// swift-tools-version:5.6
import PackageDescription

let package = Package(name: "BuildTools",
                      platforms: [
                          .macOS(.v12),
                          .iOS(.v13)
                      ],
                      dependencies: [
                          .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.50.2"),
                          .package(url: "https://github.com/mac-cain13/R.swift", from: "6.1.0"),
                          .package(url: "https://github.com/realm/SwiftLint", from: "0.49.1")
                      ],
                      targets: [.target(name: "BuildTools", path: "")])
