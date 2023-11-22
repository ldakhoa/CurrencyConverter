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
        .library(name: "Networking", targets: ["Networking"])
	],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", exact: "0.52.3")
    ],
	targets: [
		.target(
			name: "CurrencyConverterFeature",
			dependencies: []
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
        )
	]
)

// Inject base plugins into each target
package.targets = package.targets.map { target in
    var plugins = target.plugins ?? []
    plugins.append(.plugin(name: "SwiftLintPlugin", package: "SwiftLint"))
    target.plugins = plugins
    return target
}
