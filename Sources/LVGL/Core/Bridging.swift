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

func bridgeToSwift<T: AnyObject>(_ pointer: UnsafeRawPointer) -> T {
    Unmanaged<T>.fromOpaque(pointer).takeUnretainedValue()
}

func bridgeToCLVGL<T: AnyObject>(_ object: T) -> UnsafeMutableRawPointer {
    UnsafeMutableRawPointer(Unmanaged.passUnretained(object).toOpaque())
}

private func releasingBridgeToSwift<T: AnyObject>(_ pointer: UnsafeRawPointer) -> T {
    Unmanaged<T>.fromOpaque(pointer).takeRetainedValue()
}

private func retainingBridgeToCLVGL<T: AnyObject>(_ object: T) -> UnsafeMutableRawPointer {
    UnsafeMutableRawPointer(Unmanaged.passRetained(object).toOpaque())
}

func LVRetainUserData(_ object: UnsafeMutablePointer<lv_obj_t>) {
    _ = retainingBridgeToCLVGL(bridgeToSwift(lv_obj_get_user_data(object)) as LVObject)
}

func LVReleaseUserData(_ object: UnsafeMutablePointer<lv_obj_t>) {
    _ = bridgeToCLVGL(releasingBridgeToSwift(lv_obj_get_user_data(object)) as LVObject)
}

func LVRetainEventUserData(_ object: UnsafeMutablePointer<lv_event_t>) {
    _ = retainingBridgeToCLVGL(bridgeToSwift(lv_event_get_user_data(object)) as LVObject)
}

func LVReleaseEventUserData(_ object: UnsafeMutablePointer<lv_event_t>) {
    _ = bridgeToCLVGL(releasingBridgeToSwift(lv_event_get_user_data(object)) as LVObject)
}

extension UnsafeMutablePointer where Pointee == lv_obj_t {
    var swiftObject: LVObject? {
        if pointee.user_data == nil {
            return nil
        } else {
            return bridgeToSwift(pointee.user_data)
        }
    }
}

extension UnsafeMutablePointer where Pointee == lv_theme_t {
    var swiftObject: LVTheme? {
        if pointee.user_data == nil {
            return nil
        } else {
            return bridgeToSwift(pointee.user_data)
        }
    }
}

extension UnsafeMutableRawPointer {
    var swiftObject: AnyObject? {
        bridgeToSwift(self)
    }
}
