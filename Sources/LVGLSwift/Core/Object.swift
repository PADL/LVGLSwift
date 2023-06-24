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
import CLVGLSwift

func bridgeToSwift<T: LVObject>(_ pointer: UnsafeRawPointer) -> T {
    Unmanaged<T>.fromOpaque(pointer).takeUnretainedValue()
}

func bridgeToCLVGL<T: LVObject>(_ object: T) -> UnsafeMutableRawPointer {
    UnsafeMutableRawPointer(Unmanaged.passUnretained(object).toOpaque())
}

public class LVObject {
    let object: UnsafeMutablePointer<lv_obj_t>
    
    init(_ object: UnsafeMutablePointer<lv_obj_t>) {
        self.object = object
        object.pointee.user_data = bridgeToCLVGL(self)
        lv_obj_add_event_cb(object, { event in
            guard let event = event?.pointee else {
                return
            }
            let object = bridgeToSwift(event.target.pointee.user_data)
        
            // fire off event handler
        }, LV_EVENT_ALL, nil)
    }
    
    deinit {
        lv_obj_del(object)
    }
    
    
    
}
