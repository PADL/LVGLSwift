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

public class LVArc: LVObject {
    public init(with parent: LVObject) {
        super.init(lv_arc_create(parent.object))
    }

    public var startAngle: UInt16 {
        get {
            lv_arc_get_angle_start(object)
        }
        set {
            precondition(isValid)
            lv_arc_set_start_angle(object, newValue)
        }
    }
    
    public var endAngle: UInt16 {
        get {
            lv_arc_get_angle_end(object)
        }
        set {
            precondition(isValid)
            lv_arc_set_end_angle(object, newValue)
        }
    }
    
    public var backgroundStartAngle: UInt16 {
        get {
            lv_arc_get_bg_angle_start(object)
        }
        set {
            precondition(isValid)
            lv_arc_set_bg_start_angle(object, newValue)
        }
    }
    
    public var backgroundEndAngle: UInt16 {
        get {
            lv_arc_get_bg_angle_end(object)
        }
        set {
            precondition(isValid)
            lv_arc_set_bg_end_angle(object, newValue)
        }
    }
    
    public var mode: lv_arc_mode_t {
        get {
            lv_arc_get_mode(object)
        }
        set {
            precondition(isValid)
            lv_arc_set_mode(object, newValue)
        }
    }
    
    public var rotation: UInt16 {
        get {
            withObjectCast(to: lv_arc_t.self) {
                $0.rotation
            }
        }
        set {
            precondition(isValid)
            lv_arc_set_rotation(object, newValue)
        }
    }
    
    public var value: Int16 {
        get {
            lv_arc_get_value(object)
        }
        set {
            precondition(isValid)
            lv_arc_set_value(object, newValue)
        }
    }
        
    public var range: ClosedRange<Int16> {
        get {
            withObjectCast(to: lv_arc_t.self) {
                $0.min_value...$0.max_value
            }
        }
        set {
            precondition(isValid)
            lv_arc_set_range(object, newValue.lowerBound, newValue.upperBound)
        }
    }
    
    public var changeRate: UInt16 {
        get {
            withObjectCast(to: lv_arc_t.self) {
                $0.chg_rate
            }
        }
        set {
            precondition(isValid)
            lv_arc_set_change_rate(object, newValue)
        }
    }
}
