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

public class LVStyle {
    private var style: lv_style_t = lv_style_t()
    
    init() {
        lv_style_init(&style)
    }
    
    func _getProperty(_ property: lv_style_prop_t) -> lv_style_value_t? {
        var style = self.style
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
    
    @LVStyleIntegerProperty(LV_STYLE_WIDTH) var width: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_MIN_WIDTH) var minWidth: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_MAX_WIDTH) var maxWidth: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_HEIGHT) var height: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_MIN_HEIGHT) var minHeight: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_MAX_HEIGHT) var maxHeight: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_X) var x: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_Y) var y: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_ALIGN) var alignment: lv_align_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSFORM_WIDTH) var widthTransformation: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSFORM_HEIGHT) var heightTransformation: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSLATE_X) var xTranslation: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSLATE_Y) var yTranslation: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSFORM_ZOOM) var zoomTransform: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSFORM_ANGLE) var angleTransform: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSFORM_PIVOT_X) var xPivotTransform: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TRANSFORM_PIVOT_Y) var yPivotTransform: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_PAD_TOP) var topPadding: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_PAD_BOTTOM) var bottomPadding: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_PAD_LEFT) var leftPadding: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_PAD_RIGHT) var rightPadding: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_PAD_ROW) var rowPadding: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_PAD_COLUMN) var colunnPadding: lv_coord_t?
    @LVStyleColorProperty(LV_STYLE_BG_COLOR) var backgroundColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_BG_OPA) var backgroundOpacity: lv_opa_t?
    @LVStyleColorProperty(LV_STYLE_BG_GRAD_COLOR) var backgroundGradientColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_BG_GRAD_DIR) var backgroundGradientDirection: lv_grad_dir_t?
    @LVStyleIntegerProperty(LV_STYLE_BG_MAIN_STOP) var backgroundMainStop: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_BG_GRAD_STOP) var backgroundGradientStop: lv_coord_t?
    // TODO: LV_STYLE_BG_GRAD
    // TODO: LV_STYLE_BG_DITHER_MODE
    // TODO: LV_STYLE_BG_IMG_SRC
    @LVStyleIntegerProperty(LV_STYLE_BG_IMG_OPA) var imageOpacity: lv_opa_t?
    @LVStyleColorProperty(LV_STYLE_BG_IMG_RECOLOR) var imageRecolor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_BG_IMG_RECOLOR_OPA) var imageRecolorOpacity: lv_opa_t?
    @LVStyleBooleanProperty(LV_STYLE_BG_IMG_TILED) var imageIsTiled: Bool?
    @LVStyleColorProperty(LV_STYLE_BORDER_COLOR) var borderColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_BORDER_OPA) var borderOpacity: lv_opa_t?
    @LVStyleIntegerProperty(LV_STYLE_BORDER_WIDTH) var borderWidth: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_BORDER_SIDE) var borderSide: lv_border_side_t?
    @LVStyleBooleanProperty(LV_STYLE_BORDER_POST) var borderPost: Bool?
    @LVStyleIntegerProperty(LV_STYLE_OUTLINE_WIDTH) var outlineWidth: lv_coord_t?
    @LVStyleColorProperty(LV_STYLE_OUTLINE_COLOR) var outlineColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_OUTLINE_OPA) var outlineOpacity: lv_opa_t?
    @LVStyleIntegerProperty(LV_STYLE_OUTLINE_PAD) var outlinePad: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_SHADOW_WIDTH) var shadowWidth: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_SHADOW_OFS_X) var shadowXOffset: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_SHADOW_OFS_Y) var shadowYOffset: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_SHADOW_SPREAD) var shadowSpread: lv_coord_t?
    @LVStyleColorProperty(LV_STYLE_SHADOW_COLOR) var shadowColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_SHADOW_OPA) var shadowOpacity: lv_opa_t?
    @LVStyleIntegerProperty(LV_STYLE_LINE_WIDTH) var lineWidth: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_LINE_DASH_WIDTH) var lineDashWidth: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_LINE_DASH_GAP) var lineDashGap: lv_coord_t?
    @LVStyleBooleanProperty(LV_STYLE_LINE_ROUNDED) var lineIsRounded: Bool?
    @LVStyleColorProperty(LV_STYLE_LINE_COLOR) var lineColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_LINE_OPA) var lineOpacity: lv_opa_t?
    @LVStyleIntegerProperty(LV_STYLE_ARC_WIDTH) var arcWidth: lv_coord_t?
    @LVStyleBooleanProperty(LV_STYLE_ARC_ROUNDED) var arcIsRounded: Bool?
    @LVStyleColorProperty(LV_STYLE_ARC_COLOR) var arcColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_ARC_OPA) var arcOpacity: lv_opa_t?
    // TODO: LV_STYLE_ARC_IMG_SRC
    @LVStyleColorProperty(LV_STYLE_TEXT_COLOR) var textColor: LVColor?
    @LVStyleIntegerProperty(LV_STYLE_TEXT_OPA) var textOpacity: lv_opa_t?
    @LVStyleFontProperty(LV_STYLE_TEXT_FONT) var textFont: LVFont?
    @LVStyleIntegerProperty(LV_STYLE_TEXT_LETTER_SPACE) var textLetterSpacing: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TEXT_LINE_SPACE) var textLineSpacing: lv_coord_t?
    @LVStyleIntegerProperty(LV_STYLE_TEXT_DECOR) var textDecor: lv_text_decor_t?
    @LVStyleIntegerProperty(LV_STYLE_TEXT_ALIGN) var textAlignment: lv_text_align_t?
    @LVStyleIntegerProperty(LV_STYLE_RADIUS) var radius: lv_coord_t?
    @LVStyleBooleanProperty(LV_STYLE_CLIP_CORNER) var clipCorner: Bool?
    @LVStyleIntegerProperty(LV_STYLE_OPA) var opacity: lv_opa_t?
    // TODO: LV_STYLE_COLOR_FILTER_DSC
    @LVStyleIntegerProperty(LV_STYLE_COLOR_FILTER_OPA) var colorFilterOpacity: lv_opa_t?
    // TODO: LV_STYLE_ANIM
    // TODO: LV_STYLE_ANIM_TIME
    // TODO: LV_STYLE_ANIM_SPEED
    // TODO: LV_STYLE_TRANSITION
    @LVStyleIntegerProperty(LV_STYLE_BLEND_MODE) var blendMode: lv_blend_mode_t?
    @LVStyleIntegerProperty(LV_STYLE_LAYOUT) var layout: UInt16?
    @LVStyleIntegerProperty(LV_STYLE_BASE_DIR) var baseDir: UInt16?
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
