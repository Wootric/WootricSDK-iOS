// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "WootricSDK",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_10),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(name: "WootricSDK", targets: ["WootricSDK"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "WootricSDK",
            dependencies: [],
            path: "WootricSDK/WootricSDK",
            exclude: ["Info.plist"],
            resources: [
                .process("fontawesome-webfont.ttf"),
                .process("IBMPlexSans-Bold.ttf"),
                .process("IBMPlexSans-Italic.ttf"),
                .process("IBMPlexSans-Medium.ttf"),
                .process("IBMPlexSans-Regular.ttf"),
            ],
            publicHeadersPath: "Public",
            cSettings: [
                .headerSearchPath("."),
            ]),
    ],
    cxxLanguageStandard: CXXLanguageStandard(rawValue: "gnu++17")
)
