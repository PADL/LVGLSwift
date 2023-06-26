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

public class LVStyle: Hashable {
    var style: lv_style_t = lv_style_t()
    
    public init() {
        lv_style_init(&style)
    }
    
    public static func == (lhs: LVStyle, rhs: LVStyle) -> Bool {
        ObjectIdentifier(self) == ObjectIdentifier(self)
    }
    
    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
    
    public func reportChange() {
        lv_obj_report_style_change(&style)
    }
    
    func _getProperty(_ property: lv_style_prop_t) -> lv_style_value_t? {
        var value = lv_style_value_t()
        
        guard lv_style_get_prop(&style, property, &value) == lv_res_t(LV_RES_OK) else {
            return nil
        }
        
        return value
    }
    
    func getProperty(_ property: lv_style_prop_t) -> Bool? {
        guard let value = _getProperty(property) else {
            return nil
        }
        
        return value.num != 0
    }
    
    func getProperty<T: BinaryInteger>(_ property: lv_style_prop_t) -> T? {
        guard let value = _getProperty(property) else {
            return nil
        }
        
        return T(value.num)
    }

    func getProperty(_ property: lv_style_prop_t) -> LVColor? {
        guard let value = _getProperty(property) else {
            return nil
        }
        
        return LVColor(value.color)
    }
    
    func getProperty(_ property: lv_style_prop_t) -> LVFont? {
        guard let value = _getProperty(property) else {
            return nil
        }
        
        return LVFont(value.ptr.assumingMemoryBound(to: lv_font_t.self))
    }
    
    func _setProperty(_ property: lv_style_prop_t, _ value: lv_style_value_t?) {
        if let value {
            lv_style_set_prop(&style, property, value)
        } else {
            lv_style_remove_prop(&style, property)
        }
    }
    
    func setProperty(_ property: lv_style_prop_t, _ value: Bool?) {
        if let value {
            let value = lv_style_value_t(num: value ? 1 : 0)
            _setProperty(property, value)
        } else {
            _setProperty(property, nil)
        }
    }
    
    func setProperty<T: BinaryInteger>(_ property: lv_style_prop_t, _ value: T?) {
        if let value {
            let value = lv_style_value_t(num: Int32(value))
            _setProperty(property, value)
        } else {
            _setProperty(property, nil)
        }
    }

    func setProperty(_ property: lv_style_prop_t, _ value: LVColor?) {
        if let value {
            let value = lv_style_value_t(color: value.color)
            _setProperty(property, value)
        } else {
            _setProperty(property, nil)
        }
    }
    
    func setProperty(_ property: lv_style_prop_t, _ value: LVFont?) {
        if let value {
            let value = lv_style_value_t(ptr: value.font)
            _setProperty(property, value)
        } else {
            _setProperty(property, nil)
        }
    }
    
    @LVStyleIntegerProperty(LV_STYLE_WIDTH) public var width: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_MIN_WIDTH) public var minWidth: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_MAX_WIDTH) public var maxWidth: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_HEIGHT) public var height: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_MIN_HEIGHT) public var minHeight: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_MAX_HEIGHT) public var maxHeight: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_X) public var x: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_Y) public var y: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_ALIGN) public var alignment: lv_align_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSFORM_WIDTH) public var widthTransformation: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSFORM_HEIGHT) public var heightTransformation: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSLATE_X) public var xTranslation: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSLATE_Y) public var yTranslation: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSFORM_ZOOM) public var zoomTransform: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSFORM_ANGLE) public var angleTransform: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSFORM_PIVOT_X) public var xPivotTransform: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSFORM_PIVOT_Y) public var yPivotTransform: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_PAD_TOP) public var topPadding: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_PAD_BOTTOM) public var bottomPadding: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_PAD_LEFT) public var leftPadding: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_PAD_RIGHT) public var rightPadding: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_PAD_ROW) public var rowPadding: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_PAD_COLUMN) public var colunnPadding: lv_coord_t?
    @LVStyleColorProperty(LV_STYLE_BG_COLOR) public var backgroundColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_BG_OPA) public var backgroundOpacity: lv_opa_t?
    @LVStyleColorProperty(LV_STYLE_BG_GRAD_COLOR) public var backgroundGradientColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_BG_GRAD_DIR) public var backgroundGradientDirection: lv_grad_dir_t?
    @LVStyleIntegerProperty(LV_STYLE_BG_MAIN_STOP) public var backgroundMainStop: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_BG_GRAD_STOP) public var backgroundGradientStop: lv_coord_t?
    // TODO: LV_STYLE_BG_GRAD
    // TODO: LV_STYLE_BG_DITHER_MODE
    // TODO: LV_STYLE_BG_IMG_SRC
    @LVStyleIntegerProperty(LV_STYLE_BG_IMG_OPA) public var imageOpacity: lv_opa_t?
    @LVStyleColorProperty(LV_STYLE_BG_IMG_RECOLOR) public var imageRecolor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_BG_IMG_RECOLOR_OPA) public var imageRecolorOpacity: lv_opa_t?
    @LVStyleBooleanProperty(LV_STYLE_BG_IMG_TILED) public var imageIsTiled: Bool?
    @LVStyleColorProperty(LV_STYLE_BORDER_COLOR) public var borderColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_BORDER_OPA) public var borderOpacity: lv_opa_t?
    @LVStyleIntegerProperty(LV_STYLE_BORDER_WIDTH) public var borderWidth: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_BORDER_SIDE) public var borderSide: lv_border_side_t?
    @LVStyleBooleanProperty(LV_STYLE_BORDER_POST) public var borderPost: Bool?
    @LVStyleIntegerProperty(LV_STYLE_OUTLINE_WIDTH) public var outlineWidth: lv_coord_t?
    @LVStyleColorProperty(LV_STYLE_OUTLINE_COLOR) public var outlineColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_OUTLINE_OPA) public var outlineOpacity: lv_opa_t?
    @LVStyleIntegerProperty(LV_STYLE_OUTLINE_PAD) public var outlinePad: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_SHADOW_WIDTH) public var shadowWidth: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_SHADOW_OFS_X) public var shadowXOffset: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_SHADOW_OFS_Y) public var shadowYOffset: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_SHADOW_SPREAD) public var shadowSpread: lv_coord_t?
    @LVStyleColorProperty(LV_STYLE_SHADOW_COLOR) public var shadowColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_SHADOW_OPA) public var shadowOpacity: lv_opa_t?
    @LVStyleIntegerProperty(LV_STYLE_LINE_WIDTH) public var lineWidth: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_LINE_DASH_WIDTH) public var lineDashWidth: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_LINE_DASH_GAP) public var lineDashGap: lv_coord_t?
    @LVStyleBooleanProperty(LV_STYLE_LINE_ROUNDED) public var lineIsRounded: Bool?
    @LVStyleColorProperty(LV_STYLE_LINE_COLOR) public var lineColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_LINE_OPA) public var lineOpacity: lv_opa_t?
    @LVStyleIntegerProperty(LV_STYLE_ARC_WIDTH) public var arcWidth: lv_coord_t?
    @LVStyleBooleanProperty(LV_STYLE_ARC_ROUNDED) public var arcIsRounded: Bool?
    @LVStyleColorProperty(LV_STYLE_ARC_COLOR) public var arcColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_ARC_OPA) public var arcOpacity: lv_opa_t?
    // TODO: LV_STYLE_ARC_IMG_SRC
    @LVStyleColorProperty(LV_STYLE_TEXT_COLOR) public var textColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_TEXT_OPA) public var textOpacity: lv_opa_t?
    @LVStyleFontProperty(LV_STYLE_TEXT_FONT) public var textFont: LVFont?
    @LVStyleIntegerProperty(LV_STYLE_TEXT_LETTER_SPACE) public var textLetterSpacing: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TEXT_LINE_SPACE) public var textLineSpacing: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TEXT_DECOR) public var textDecor: lv_text_decor_t?
    @LVStyleIntegerProperty(LV_STYLE_TEXT_ALIGN) public var textAlignment: lv_text_align_t?
    @LVStyleIntegerProperty(LV_STYLE_RADIUS) public var radius: lv_coord_t?
    @LVStyleBooleanProperty(LV_STYLE_CLIP_CORNER) public var clipCorner: Bool?
    @LVStyleIntegerProperty(LV_STYLE_OPA) public var opacity: lv_opa_t?
    // TODO: LV_STYLE_COLOR_FILTER_DSC
    @LVStyleIntegerProperty(LV_STYLE_COLOR_FILTER_OPA) public var colorFilterOpacity: lv_opa_t?
    // TODO: LV_STYLE_ANIM
    // TODO: LV_STYLE_ANIM_TIME
    // TODO: LV_STYLE_ANIM_SPEED
    // TODO: LV_STYLE_TRANSITION
    @LVStyleIntegerProperty(LV_STYLE_BLEND_MODE) public var blendMode: lv_blend_mode_t?
    @LVStyleIntegerProperty(LV_STYLE_LAYOUT) public var layout: UInt16?
    @LVStyleIntegerProperty(LV_STYLE_BASE_DIR) public var baseDir: UInt16?

    // TODO: LV_STYLE_GRID_ROW_DSC_ARRAY
    // TODO: LV_STYLE_GRID_COLUMN_DSC_ARRAY
    @LVStyleIntegerProperty(LV_STYLE_GRID_ROW_ALIGN) public var gridRowAlignment: UInt32?
    @LVStyleIntegerProperty(LV_STYLE_GRID_COLUMN_ALIGN) public var gridColumnAlignment: UInt32?
    @LVStyleIntegerProperty(LV_STYLE_GRID_CELL_COLUMN_POS) public var gridCellColumnALignment: UInt32?
    @LVStyleIntegerProperty(LV_STYLE_GRID_CELL_COLUMN_SPAN) public var gridCellColumnSpan: UInt32?
    @LVStyleIntegerProperty(LV_STYLE_GRID_CELL_ROW_POS) public var gridCellRowPosition: UInt32?
    @LVStyleIntegerProperty(LV_STYLE_GRID_CELL_ROW_SPAN) public var gridCellRowSPan: UInt32?
    @LVStyleIntegerProperty(LV_STYLE_GRID_CELL_X_ALIGN) public var gridCellXAlignment: UInt32?
    @LVStyleIntegerProperty(LV_STYLE_GRID_CELL_Y_ALIGN) public var gridCellYAlignment: UInt32?

}

@propertyWrapper
public struct LVStyleIntegerProperty<Value> where Value: BinaryInteger {
    let property: lv_style_prop_t
    
    init(_ property: lv_style_prop_t) {
        self.property = property
    }
    
    public var wrappedValue: Value? {
        get { fatalError() }
        nonmutating set { fatalError() }
    }
    
    public static subscript(
        _enclosingInstance instance: LVStyle,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<LVStyle, Value?>,
        storage storageKeyPath: ReferenceWritableKeyPath<LVStyle, Self>) -> Value? {
        get {
            instance.getProperty(instance[keyPath: storageKeyPath].property)
        }
        set {
            instance.setProperty(instance[keyPath: storageKeyPath].property, newValue)
        }
    }
}

@propertyWrapper
public struct LVStyleBooleanProperty {
    public typealias Value = Bool
    
    let property: lv_style_prop_t
    
    init(_ property: lv_style_prop_t) {
        self.property = property
    }
    
    public var wrappedValue: Value? {
        get { fatalError() }
        nonmutating set { fatalError() }
    }
    
    public static subscript(
        _enclosingInstance instance: LVStyle,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<LVStyle, Value?>,
        storage storageKeyPath: ReferenceWritableKeyPath<LVStyle, Self>) -> Value? {
        get {
            instance.getProperty(instance[keyPath: storageKeyPath].property)
        }
        set {
            instance.setProperty(instance[keyPath: storageKeyPath].property, newValue)
        }
    }
}

@propertyWrapper
public struct LVStyleColorProperty {
    public typealias Value = LVColor
    
    let property: lv_style_prop_t
    
    init(_ property: lv_style_prop_t) {
        self.property = property
    }
    
    public var wrappedValue: Value? {
        get { fatalError() }
        nonmutating set { fatalError() }
    }
    
    public static subscript(
        _enclosingInstance instance: LVStyle,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<LVStyle, Value?>,
        storage storageKeyPath: ReferenceWritableKeyPath<LVStyle, Self>) -> Value? {
        get {
            instance.getProperty(instance[keyPath: storageKeyPath].property)
        }
        set {
            instance.setProperty(instance[keyPath: storageKeyPath].property, newValue)
        }
    }
}

@propertyWrapper
public struct LVStyleFontProperty {
    public typealias Value = LVFont
    
    let property: lv_style_prop_t
    
    init(_ property: lv_style_prop_t) {
        self.property = property
    }
    
    public var wrappedValue: Value? {
        get { fatalError() }
        nonmutating set { fatalError() }
    }
    
    public static subscript(
        _enclosingInstance instance: LVStyle,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<LVStyle, Value?>,
        storage storageKeyPath: ReferenceWritableKeyPath<LVStyle, Self>) -> Value? {
        get {
            instance.getProperty(instance[keyPath: storageKeyPath].property)
        }
        set {
            instance.setProperty(instance[keyPath: storageKeyPath].property, newValue)
        }
    }
}
