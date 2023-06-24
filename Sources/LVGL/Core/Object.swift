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
import AsyncAlgorithms
import AsyncExtensions
import CLVGL

func bridgeToSwift<T: AnyObject>(_ pointer: UnsafeRawPointer) -> T {
    Unmanaged<T>.fromOpaque(pointer).takeUnretainedValue()
}

func bridgeToCLVGL<T: AnyObject>(_ object: T) -> UnsafeMutableRawPointer {
    UnsafeMutableRawPointer(Unmanaged.passUnretained(object).toOpaque())
}

public class LVObject {
    let object: UnsafeMutablePointer<lv_obj_t>
    public let events = AsyncChannel<LVEvent>()
    
    init(_ object: UnsafeMutablePointer<lv_obj_t>) {
        self.object = object
        object.pointee.user_data = bridgeToCLVGL(self)
        
        lv_obj_add_event_cb(object, {
            if $0 == nil { return }
            let event = LVEvent($0!)
            
            Task { @MainActor in
                await event.target.events.send(event)
            }
        }, LV_EVENT_ALL, bridgeToCLVGL(self))
    }
    
    func withObjectCast<T, U>(to type: T.Type, _ body: (T) -> U) -> U {
        withUnsafePointer(to: object) {
            $0.withMemoryRebound(to: type, capacity: 1) {
                body($0.pointee)
            }
        }
    }

    deinit {
        events.finish()
        lv_obj_del(object)
    }
}
