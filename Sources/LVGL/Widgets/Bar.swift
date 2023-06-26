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

public class LVBar: LVObject {
    public init(with parent: LVObject) {
        super.init(lv_bar_create(parent.object))
    }
    
    public var value: Int32 {
        get {
            lv_bar_get_value(object)
        }
        set {
            precondition(isValid)
            lv_bar_set_value(object, newValue, LV_ANIM_OFF)
        }
    }
    
    public var animatedValue: Int32 {
        get {
            lv_bar_get_value(object)
        }
        set {
            precondition(isValid)
            lv_bar_set_value(object, newValue, LV_ANIM_ON)
        }
    }

    public var range: ClosedRange<Int32> {
        get {
            lv_bar_get_min_value(object)...lv_bar_get_max_value(object)
        }
        set {
            precondition(isValid)
            lv_bar_set_range(object, newValue.lowerBound, newValue.upperBound)
        }
    }
    
    public var mode: lv_bar_mode_t {
        get {
            lv_bar_get_mode(object)
        }
        set {
            precondition(isValid)
            lv_bar_set_mode(object, newValue)
        }
    }
}
