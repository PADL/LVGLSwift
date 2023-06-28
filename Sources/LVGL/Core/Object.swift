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

import AsyncAlgorithms
import AsyncExtensions
import CLVGL
import Foundation

public extension lv_coord_t {
    static var sizeContent = LVGLSwiftSizeContent()
    static var maxCoordinate = LVGLSwiftCoordMax()
    static var minCoordinate = LVGLSwiftCoordMin()
}

public struct LVFlags: OptionSet {
    public static let hidden = LVFlags(rawValue: LV_OBJ_FLAG_HIDDEN)
    public static let clickable = LVFlags(rawValue: LV_OBJ_FLAG_CLICKABLE)
    public static let clickFocusable = LVFlags(rawValue: LV_OBJ_FLAG_CLICK_FOCUSABLE)
    public static let checkable = LVFlags(rawValue: LV_OBJ_FLAG_CHECKABLE)
    public static let scrollable = LVFlags(rawValue: LV_OBJ_FLAG_SCROLLABLE)
    public static let scrollElastic = LVFlags(rawValue: LV_OBJ_FLAG_SCROLL_ELASTIC)
    public static let scrollMomentum = LVFlags(rawValue: LV_OBJ_FLAG_SCROLL_MOMENTUM)
    public static let scrollOne = LVFlags(rawValue: LV_OBJ_FLAG_SCROLL_ONE)
    public static let scrollChainHorizontal = LVFlags(rawValue: LV_OBJ_FLAG_SCROLL_CHAIN_HOR)
    public static let scrollChainVertical = LVFlags(rawValue: LV_OBJ_FLAG_SCROLL_CHAIN_VER)
    public static let scrollOnFocus = LVFlags(rawValue: LV_OBJ_FLAG_SCROLL_ON_FOCUS)
    public static let scrollWithArrow = LVFlags(rawValue: LV_OBJ_FLAG_SCROLL_WITH_ARROW)
    public static let snappable = LVFlags(rawValue: LV_OBJ_FLAG_SNAPPABLE)
    public static let pressLock = LVFlags(rawValue: LV_OBJ_FLAG_PRESS_LOCK)
    public static let eventBubble = LVFlags(rawValue: LV_OBJ_FLAG_EVENT_BUBBLE)
    public static let gestureBubble = LVFlags(rawValue: LV_OBJ_FLAG_GESTURE_BUBBLE)
    public static let advHitTest = LVFlags(rawValue: LV_OBJ_FLAG_ADV_HITTEST)
    public static let ignoreLayout = LVFlags(rawValue: LV_OBJ_FLAG_IGNORE_LAYOUT)
    public static let floating = LVFlags(rawValue: LV_OBJ_FLAG_FLOATING)
    public static let overflowVisible = LVFlags(rawValue: LV_OBJ_FLAG_OVERFLOW_VISIBLE)

    public static let layout1 = LVFlags(rawValue: LV_OBJ_FLAG_LAYOUT_1)
    public static let layout2 = LVFlags(rawValue: LV_OBJ_FLAG_LAYOUT_2)

    public static let widget1 = LVFlags(rawValue: LV_OBJ_FLAG_WIDGET_1)
    public static let widget2 = LVFlags(rawValue: LV_OBJ_FLAG_WIDGET_2)
    public static let user1 = LVFlags(rawValue: LV_OBJ_FLAG_USER_1)
    public static let user2 = LVFlags(rawValue: LV_OBJ_FLAG_USER_2)
    public static let user3 = LVFlags(rawValue: LV_OBJ_FLAG_USER_3)
    public static let user4 = LVFlags(rawValue: LV_OBJ_FLAG_USER_4)

    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    init(rawValue: Int) {
        self.init(rawValue: UInt32(rawValue))
    }
}

public class LVObject: CustomStringConvertible, Equatable {
    private var _children = [LVObject]() // keep reference
    private var _styles = [LVStyle]() // keep references

    var object: UnsafeMutablePointer<lv_obj_t>

    public let events = AsyncChannel<LVEvent>()

    private func addEventCallback(filter: lv_event_code_t) {
        lv_obj_add_event_cb(object, eventCallback, filter, bridgeToCLVGL(self))
    }

    init(
        _ object: UnsafeMutablePointer<lv_obj_t>,
        filters: [lv_event_code_t]? = [LV_EVENT_ALL],
        with parent: LVObject!
    ) {
        self.object = object

        lv_obj_set_user_data(object, bridgeToCLVGL(self))
        filters?.forEach { addEventCallback(filter: $0) }
        // gotta keep references because event handler may run asynchronously
        parent?._children.append(self)
    }

    public required init(with parent: LVObject!) {
        precondition(parent != nil)
        object = lv_obj_create(parent.object)
        lv_obj_set_user_data(object, bridgeToCLVGL(self))
        addEventCallback(filter: LV_EVENT_ALL)
        parent._children.append(self)
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
            let oldParent = object.pointee.parent?.swiftObject
            if let newParent = newValue, newParent != oldParent {
                oldParent?._children.removeAll(where: { $0 == self })
                lv_obj_set_parent(object, newParent.object)
                newParent._children.append(self)
            }
        }
    }

    public var description: String {
        "LVGL.\(type(of: self))(parent: \(String(describing: parent)))"
    }

    func withObjectCast<T, U>(to type: T.Type, _ body: (inout T) -> U) -> U {
        withUnsafeMutablePointer(to: &object) {
            $0.withMemoryRebound(to: type, capacity: 1) {
                body(&$0.pointee)
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
        lv_point_t(x: lv_obj_get_content_width(object), y: lv_obj_get_content_height(object))
    }

    public var selfSize: lv_point_t {
        lv_point_t(x: lv_obj_get_self_width(object), y: lv_obj_get_self_height(object))
    }

    public func set(layout: UInt16) {
        // TODO: do we need a get accessor?
        lv_obj_set_layout(object, UInt32(layout))
    }

    public var isLayoutPositioned: Bool {
        lv_obj_is_layout_positioned(object)
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
        lv_obj_is_visible(object)
    }

    public var isHidden: Bool {
        get {
            isSet(flag: .hidden)
        }
        set {
            if newValue {
                set(flag: .hidden)
            } else {
                clear(flag: .hidden)
            }
        }
    }

    public var clickArea: lv_area_t {
        var area = lv_area_t(x1: 0, y1: 0, x2: 0, y2: 0)
        lv_obj_get_click_area(object, &area)
        return area
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

    public func append(
        style: LVStyle?,
        selector: lv_style_selector_t = lv_style_selector_t(LV_PART_MAIN)
    ) {
        if let style {
            _styles.append(style)
            lv_obj_add_style(object, style.style, selector)
        } else {
            lv_obj_add_style(object, nil, selector)
        }
    }

    public func remove(
        style: LVStyle?,
        selector: lv_style_selector_t = lv_style_selector_t(LV_PART_MAIN)
    ) {
        if let style {
            _styles.removeAll(where: { $0 == style })
            lv_obj_remove_style(object, style.style, selector)
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

    public func set(flag: LVFlags) {
        lv_obj_add_flag(object, flag.rawValue)
    }

    public func clear(flag: LVFlags) {
        lv_obj_clear_flag(object, flag.rawValue)
    }

    public func isSet(flag: LVFlags) -> Bool {
        lv_obj_has_flag(object, flag.rawValue)
    }

    public func set(state: lv_state_t) {
        lv_obj_add_state(object, state)
    }

    public func clear(state: lv_state_t) {
        lv_obj_clear_state(object, state)
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

    public func forEachChild(_ block: (LVObject, inout Bool) -> ()) {
        guard let children = object.pointee.spec_attr.pointee.children else {
            return
        }

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

    public func removeAllChildren() {
        _children.removeAll()
        lv_obj_clean(object)
    }

    public var index: Int {
        Int(lv_obj_get_index(object))
    }

    public func child(at index: Int) -> LVObject? {
        guard let child = lv_obj_get_child(object, Int32(index)) else {
            return nil
        }

        return child.swiftObject
    }

    public func move(to index: Int) {
        lv_obj_move_to_index(object, Int32(index))
    }

    public var childCount: Int {
        Int(lv_obj_get_child_cnt(object))
    }

    public var screen: LVObject {
        lv_obj_get_screen(object).swiftObject!
    }

    public var display: LVDisplay {
        LVDisplay(lv_obj_get_disp(object))
    }

    public func withLocalStyle(
        for selector: lv_style_selector_t = 0,
        _ block: (LVReferenceStyle) -> ()
    ) {
        for index in 0..<object.pointee.style_cnt {
            let style = object.pointee.styles[Int(index)]
            guard style.is_local != 0, style.selector == selector else {
                continue
            }
            let ref = LVReferenceStyle(style.style)
            block(ref)
        }
        lv_obj_refresh_style(object, selector, LV_STYLE_PROP_ANY)
    }
}

private func eventCallback(_ eventData: UnsafeMutablePointer<lv_event_t>?) {
    guard let eventData = eventData?.pointee else {
        return
    }

    let event = LVEvent(eventData)

    Task { @MainActor in
        await event.target.events.send(event)
    }
}
