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

public extension lv_coord_t {
    static var sizeContent = LVGLSwiftSizeContent()
    static var maxCoordinate = LVGLSwiftCoordMax()
    static var minCoordinate = LVGLSwiftCoordMin()
}

public struct LVSize {
    var width: lv_coord_t
    var height: lv_coord_t
    
    public init(width: lv_coord_t, height: lv_coord_t) {
        self.width = width
        self.height = height
    }
    
    public static var content: Self {
        LVSize(width: .sizeContent, height: .sizeContent)
    }
}

public class LVObject: CustomStringConvertible, Equatable {
    private let _children = [LVObject]() // keep reference
    private var _styles = [LVStyle]() // keep references

    let object: UnsafeMutablePointer<lv_obj_t>
    
    public let events = AsyncChannel<LVEvent>()
    public var associatedValue: Any? = nil
    
    @LVObjectFlag(LV_OBJ_FLAG_HIDDEN) public var isHidden
    @LVObjectFlag(LV_OBJ_FLAG_CLICKABLE) public var isClickable
    @LVObjectFlag(LV_OBJ_FLAG_CLICK_FOCUSABLE) public var isClickFocusable
    @LVObjectFlag(LV_OBJ_FLAG_CHECKABLE) public var isCheckable
    @LVObjectFlag(LV_OBJ_FLAG_SCROLLABLE) public var isScrollable
    @LVObjectFlag(LV_OBJ_FLAG_SCROLL_ELASTIC) public var elasticScrolling
    @LVObjectFlag(LV_OBJ_FLAG_SCROLL_MOMENTUM) public var momentumScrolling
    @LVObjectFlag(LV_OBJ_FLAG_SCROLL_ONE) public var scrollOne
    @LVObjectFlag(LV_OBJ_FLAG_SCROLL_CHAIN_HOR) public var scrollChainHorizontal
    @LVObjectFlag(LV_OBJ_FLAG_SCROLL_CHAIN_VER) public var scrollChainVertical
    @LVObjectFlag(LV_OBJ_FLAG_SCROLL_ON_FOCUS) public var scrollOnFocus
    @LVObjectFlag(LV_OBJ_FLAG_SCROLL_WITH_ARROW) public var scrollWithArrow
    @LVObjectFlag(LV_OBJ_FLAG_SNAPPABLE) public var isSnappable
    @LVObjectFlag(LV_OBJ_FLAG_PRESS_LOCK) public var pressLock
    @LVObjectFlag(LV_OBJ_FLAG_EVENT_BUBBLE) public var eventBubble
    @LVObjectFlag(LV_OBJ_FLAG_GESTURE_BUBBLE) public var gestureBubble
    @LVObjectFlag(LV_OBJ_FLAG_ADV_HITTEST) public var advHitTest
    @LVObjectFlag(LV_OBJ_FLAG_IGNORE_LAYOUT) public var ignoreLayout
    @LVObjectFlag(LV_OBJ_FLAG_FLOATING) public var isFloating
    @LVObjectFlag(LV_OBJ_FLAG_OVERFLOW_VISIBLE) public var isOVerflowVisible
    
    @LVObjectFlag(LV_OBJ_FLAG_LAYOUT_1) public var layout1
    @LVObjectFlag(LV_OBJ_FLAG_LAYOUT_2) public var layout2
    
    @LVObjectFlag(LV_OBJ_FLAG_WIDGET_1) public var widget1
    @LVObjectFlag(LV_OBJ_FLAG_WIDGET_2) public var widget2
    @LVObjectFlag(LV_OBJ_FLAG_USER_1) public var user1
    @LVObjectFlag(LV_OBJ_FLAG_USER_2) public var user2
    @LVObjectFlag(LV_OBJ_FLAG_USER_3) public var user3
    @LVObjectFlag(LV_OBJ_FLAG_USER_4) public var user4

    init(_ object: UnsafeMutablePointer<lv_obj_t>, filter: lv_event_code_t = LV_EVENT_ALL, with parent: LVObject?) {
        self.object = object

        lv_obj_set_user_data(object, bridgeToCLVGL(self))
        lv_obj_add_event_cb(object, {
            guard let eventData = $0?.pointee else {
                return
            }
            
            if eventData.code == LV_EVENT_DELETE {
                lv_obj_set_user_data(eventData.target, nil)
            }
            
            let event = LVEvent(eventData)

            Task { @MainActor in
                await event.target.events.send(event)
            }
        }, filter, bridgeToCLVGL(self))
        
        // gotta keep references because event handler may run asynchronously
        parent?._children.append(self)
    }

    public convenience init(with parent: LVObject) {
        self.init(lv_obj_create(parent.object), with: parent)
    }

    deinit {
        events.finish()
        lv_obj_del(object)
    }

    public static func == (lhs: LVObject, rhs: LVObject) -> Bool {
        lhs.object == rhs.object
    }

    public var parent: LVObject? {
        get {
            guard let parent = object.pointee.parent else {
                return nil
            }
            return parent.swiftObject
        }
        set {
            if let parent = newValue {
                lv_obj_set_parent(object, parent.object)
            } else {
                lv_obj_set_parent(object, nil)
            }
        }
    }
    
    public var description: String {
        "LVGL.\(type(of: self))(parent: \(String(describing: parent)))"
    }
    
    func withObjectCast<T, U>(to type: T.Type, _ body: (T) -> U) -> U {
        withUnsafePointer(to: object) {
            $0.withMemoryRebound(to: type, capacity: 1) {
                body($0.pointee)
            }
        }
    }
    
    public var size: LVSize {
        get {
            LVSize(width: lv_obj_get_width(object), height: lv_obj_get_height(object))
        }
        set {
            lv_obj_set_size(object, newValue.width, newValue.height)
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
    
    public func align(to align: lv_align_t, offset: lv_point_t) {
        lv_obj_align(object, align, offset.x, offset.y)
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
    
    public func append(style: LVStyle?, selector: lv_style_selector_t = lv_style_selector_t(LV_PART_MAIN)) {
        if let style {
            _styles.append(style)
            lv_obj_add_style(object, &style.style, selector)
        } else {
            lv_obj_add_style(object, nil, selector)
        }
    }
    
    public func remove(style: LVStyle?, selector: lv_style_selector_t = lv_style_selector_t(LV_PART_MAIN)) {
        if let style {
            _styles.removeAll(where: { $0 == style })
            lv_obj_remove_style(object, &style.style, selector)
        } else {
            lv_obj_remove_style(object, nil, selector)
        }
    }
    
    public func removeAllStyles() {
        lv_obj_remove_style_all(object)
    }
    
    public func applyTheme() {
        lv_theme_apply(object)
    }
    
    public func refreshStyle(part: lv_part_t, property: lv_style_prop_t) {
        lv_obj_refresh_style(object, part, property)
    }
    
    public static func enableStyleRefresh(_ enabled: Bool) {
        lv_obj_enable_style_refresh(enabled)
    }
    
    public func set(flag: lv_obj_flag_t) {
        lv_obj_add_flag(object, flag)
    }

    public func clear(flag: lv_obj_flag_t) {
        lv_obj_clear_flag(object, flag)
    }
    
    public func set(state: lv_state_t) {
        lv_obj_add_state(object, state)
    }

    public func clear(state: lv_state_t) {
        lv_obj_clear_state(object, state)
    }
    
    public func isSet(flag: lv_obj_flag_t) -> Bool {
        lv_obj_has_flag(object, flag)
    }
    
    public var state: lv_state_t {
        lv_obj_get_state(object)
    }
    
    public var isValid: Bool {
        precondition(object.pointee.user_data == bridgeToCLVGL(self))
        precondition(Thread.isMainThread)
        return lv_obj_is_valid(object)
    }
    
    public func refresh() {
        lv_event_send(object, LV_EVENT_REFRESH, nil)
    }
    
    // TODO: get/set local style property?
    
    func forEachChild(_ block: (LVObject, inout Bool) -> Void) {
        guard let children = object.pointee.spec_attr.pointee.children else {
            return
        }
        
        debugPrint("child count = \(lv_obj_get_child_cnt(object))")
        var stop = false
        for index in 0..<childCount {
            let childPointer = children[index]
            let objectUserData = lv_obj_get_user_data(childPointer)!
            
            block(objectUserData.swiftObject as! LVObject, &stop)
            if stop {
                break
            }
        }
    }
    
    public var childCount: Int {
        Int(lv_obj_get_child_cnt(object))
    }
}


@propertyWrapper
public struct LVObjectFlag {
    public typealias Value = Bool
    
    let flag: lv_obj_flag_t
    
    init(_ flag: Int) {
        self.flag = lv_obj_flag_t(flag)
    }
    
    public var wrappedValue: Value {
        get { fatalError() }
        nonmutating set { fatalError() }
    }
    
    public static subscript(
        _enclosingInstance instance: LVObject,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<LVObject, Bool>,
        storage storageKeyPath: ReferenceWritableKeyPath<LVObject, Self>) -> Bool {
        get {
            instance.isSet(flag: instance[keyPath: storageKeyPath].flag)
        }
        set {
            if newValue {
                instance.set(flag: instance[keyPath: storageKeyPath].flag)
            } else {
                instance.clear(flag: instance[keyPath: storageKeyPath].flag)
            }
        }
    }
}

