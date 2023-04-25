// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "IAC_DNIWallet_Swift",
    platforms: [ .iOS(.v13), .macOS(.v10_15) ],
    products: [
        .library( name: "IACCore", targets: ["IACCore"]),
        .library( name: "IAC_DNIWallet", targets: ["IAC_DNIWallet"])
    ],
    dependencies: [
        .package(url: "https://github.com/airsidemobile/JOSESwift.git", branch: "master"),
    ],
    targets: [
        .target( name: "IACCore"),
        .target( name: "IAC_DNIWallet", dependencies: ["JOSESwift", "IACCore"])
    ],
    swiftLanguageVersions: [.v5]
)
