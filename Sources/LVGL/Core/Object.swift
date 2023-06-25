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
        
        lv_theme_apply(object)
        lv_obj_set_user_data(object, bridgeToCLVGL(self))
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

    public var size: (lv_coord_t, lv_coord_t) {
        get {
            (lv_obj_get_width(object), lv_obj_get_height(object))
        }
        set {
            lv_obj_set_size(object, newValue.0, newValue.1)
        }
    }

    public var position: lv_point_t {
        get {
            lv_point_t(x: lv_obj_get_x(object), y: lv_obj_get_y(object))
        }
        set {
            lv_obj_set_pos(object, newValue.x, newValue.y)
        }
    }

    public var contentSize: lv_point_t {
        get {
            lv_point_t(x: lv_obj_get_content_width(object), y: lv_obj_get_content_height(object))
        }
    }
    
    public var selfSize: lv_point_t {
        get {
            lv_point_t(x: lv_obj_get_self_width(object), y: lv_obj_get_self_height(object))
        }
    }

    public var isLayoutPositioned: Bool {
        get {
            lv_obj_is_layout_positioned(object)
        }
    }
    
    public func markDirty() {
        lv_obj_mark_layout_as_dirty(object)
    }

    public func updateLayout() {
        lv_obj_update_layout(object)
    }
    
    public func refreshSize() {
        lv_obj_refr_size(object)
    }
    
    // TODO: lv_layout_register
    
    public func align(to align: lv_align_t) {
        lv_obj_set_align(object, align)
    }
    
    public func align(to align: lv_align_t, offset: (lv_coord_t, lv_coord_t)) {
        lv_obj_align(object, align, offset.0, offset.1)
    }
    
    public func invalidate(area: lv_area_t? = nil) {
        if var area {
            lv_obj_invalidate_area(object, &area)
        } else {
            lv_obj_invalidate(object)
        }
    }
    
    public func isVisible(area: lv_area_t) -> Bool {
        var area = area
        return lv_obj_area_is_visible(object, &area)
    }
    
    public var isVisible: Bool {
        get {
            lv_obj_is_visible(object)
        }
    }
    
    public var clickArea: lv_area_t {
        get {
            var area = lv_area_t(x1: 0, y1: 0, x2: 0, y2: 0)
            lv_obj_get_click_area(object, &area)
            return area
        }
    }
    
    public func setExtendedClickableArea(_ size: lv_coord_t) {
        lv_obj_set_ext_click_area(object, size)
    }
    
    public func hitTest(_ point: lv_point_t) -> Bool {
        var point = point
        return lv_obj_hit_test(object, &point)
    }
    
    public func center() {
        lv_obj_center(object)
    }

    deinit {
        events.finish()
        lv_obj_del(object)
    }
}
