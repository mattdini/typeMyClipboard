// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TypeMyClipboard",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "TypeMyClipboard",
            targets: ["TypeMyClipboard"]
        )
    ],
    targets: [
        .executableTarget(
            name: "TypeMyClipboard",
            dependencies: [],
            path: "Sources"
        )
    ]
)
