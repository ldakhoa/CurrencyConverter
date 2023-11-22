// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "CurrencyConverter",
  	platforms: [
		.iOS(.v13)
	],
	products: [
		.library(name: "CurrencyConverterFeature", targets: ["CurrencyConverterFeature"]),
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "Common", targets: ["Common"])
	],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", exact: "0.52.3"),
        .package(url: "https://github.com/BastiaanJansen/toast-swift", from: "2.0.0")
    ],
	targets: [
        .target(name: "Common"),

		.target(
			name: "CurrencyConverterFeature",
			dependencies: [
                "Common",
                "Networking",
                "UIComponentKit",
                .product(name: "Toast", package: "toast-swift"),
            ]
		),
		.testTarget(
			name: "CurrencyConverterFeatureTests",
			dependencies: ["CurrencyConverterFeature"]
		),

        .target(
            name: "Networking",
            dependencies: []
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"]
        ),

        .target(
            name: "UIComponentKit"
        ),
	]
)

// Inject base plugins into each target
package.targets = package.targets.map { target in
    var plugins = target.plugins ?? []
    plugins.append(.plugin(name: "SwiftLintPlugin", package: "SwiftLint"))
    target.plugins = plugins
    return target
}
