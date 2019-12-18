// swift-tools-version:4.2
// Generated automatically by Perfect Assistant
// Date: 2019-12-18 10:19:59 +0000
import PackageDescription

let package = Package(
	name: "PerfectPhase1",
	dependencies: [
		.package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", "3.0.0"..<"4.0.0"),
		.package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", "3.0.0"..<"4.0.0")
	],
	targets: [
		.target(name: "PerfectPhase1", dependencies: ["PerfectHTTPServer","PerfectMustache"])
	]
)
