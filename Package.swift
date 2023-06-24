// swift-tools-version:5.5

import PackageDescription
import Foundation

#if os(macOS)
let SDLCFlags=["-I/opt/homebrew/include"]
#endif

let package = Package(
    name: "LVGLSwift",
    platforms: [
       .macOS(.v10_15),
    ],
    products: [
        .library(name: "CLVGLSwift", targets: ["CLVGLSwift"]),
        .library(name: "LVGLSwift", targets: ["LVGLSwift"]),
    ],
    dependencies: [
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CLVGLSwift",
            dependencies: [],
            cSettings: [
                        .headerSearchPath("lv_drivers"),
                        .headerSearchPath("lvgl"),
                        .unsafeFlags(SDLCFlags + ["-DLV_LVGL_H_INCLUDE_SIMPLE"])
                        ],
	    linkerSettings: [.unsafeFlags(["-L/opt/homebrew/lib","-lSDL2"])]
        ),
	.target(
	    name: "LVGLSwift",
	    dependencies: ["CLVGLSwift"]
	),
    ]
)
