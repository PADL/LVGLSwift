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

public class LVEvent: CustomStringConvertible {
    var event: lv_event_t
    
    static func registerID() -> UInt32 {
        lv_event_register_id()
    }
    
    /// unbalanced retain required in case event outlives target
    
    init(_ event: lv_event_t) {
        self.event = event
        LVRetainEventUserData(&self.event)
    }
    
    deinit {
        LVReleaseEventUserData(&event)
    }
    
    public var target: LVObject {
        let target = lv_event_get_target(&event)!
        return bridgeToSwift(lv_obj_get_user_data(target))
    }
    
    public var currentTarget: LVObject {
        let currentTarget = lv_event_get_current_target(&event)!
        return bridgeToSwift(lv_obj_get_user_data(currentTarget))
    }
    
    public var code: lv_event_code_t {
        return lv_event_get_code(&event)
    }
    
    public var description: String {
        return "LVGL.LVEvent(target: \(target), currentTarget: \(currentTarget), code: \(code))"
    }
}
