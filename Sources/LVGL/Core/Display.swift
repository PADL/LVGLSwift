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

public class LVDisplay {
    public static let `default` = LVDisplay()

    var display: UnsafeMutablePointer<lv_disp_t>

    public convenience init() {
        self.init(lv_disp_get_default())
    }

    public init(_ display: UnsafeMutablePointer<lv_disp_t>) {
        self.display = display
    }

    public var size: LVSize {
        LVSize(
            width: lv_disp_get_hor_res(display),
            height: lv_disp_get_ver_res(display)
        )
    }

    public var backgroundColor: LVColor {
        get {
            LVColor(display.pointee.bg_color)
        }
        set {
            lv_disp_set_bg_color(display, newValue.color)
        }
    }

    public var backgroundOpacity: lv_opa_t {
        get {
            display.pointee.bg_opa
        }
        set {
            lv_disp_set_bg_opa(display, newValue)
        }
    }

    public var theme: LVTheme {
        get {
            lv_disp_get_theme(display).swiftObject!
        }
        set {
            lv_disp_set_theme(display, &newValue.theme)
        }
    }
}
