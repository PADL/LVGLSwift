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

import Foundation
import CLVGL

public struct LVDisplay {
    var display: UnsafeMutablePointer<lv_disp_t>
    
    public init() {
        self.display = lv_disp_get_default()
    }
    
    public var theme: LVTheme {
        get {
            bridgeToSwift(lv_disp_get_theme(display)!.pointee.user_data)
        }
        set {
            lv_disp_set_theme(display, &newValue.theme)
        }
    }
}
