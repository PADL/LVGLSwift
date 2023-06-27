//
// Copyright (c) 2023 PADL Software Pty Ltd
//
// Licensed under the Apache License, Version 2.0 (the License);
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an 'AS IS' BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import CLVGL
import Foundation

public struct LVColor {
    var color: lv_color_t

    init(_ color: lv_color_t) {
        self.color = color
    }

    public init(hexValue: UInt32) {
        self.init(lv_color_hex(hexValue))
    }

    public init(red: UInt8, green: UInt8, blue: UInt8) {
        self.init(lv_color_make(red, green, blue))
    }

    public func darken(by opacity: lv_opa_t) -> LVColor {
        LVColor(lv_color_darken(color, opacity))
    }
}

public extension LVColor {
    static var black: LVColor {
        LVColor(lv_color_black())
    }

    static var white: LVColor {
        LVColor(lv_color_white())
    }

    static var red: LVColor {
        LVColor(red: 255, green: 0, blue: 0)
    }

    static var green: LVColor {
        LVColor(red: 0, green: 255, blue: 0)
    }

    static var blue: LVColor {
        LVColor(red: 0, green: 0, blue: 255)
    }
}
