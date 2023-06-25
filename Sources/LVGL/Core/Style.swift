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

public struct LVStyle {
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
    
    mutating func _setProperty(_ property: lv_style_prop_t, _ value: lv_style_value_t?) {
        if let value {
            lv_style_set_prop(&style, property, value)
        } else {
            lv_style_remove_prop(&style, property)
        }
    }
    
    mutating func setProperty(_ property: lv_style_prop_t, _ value: Bool?) {
        if let value {
            let value = lv_style_value_t(num: value ? 1 : 0)
            _setProperty(property, value)
        } else {
            _setProperty(property, nil)
        }
    }
    
    mutating func setProperty<T: BinaryInteger>(_ property: lv_style_prop_t, _ value: T?) {
        if let value {
            let value = lv_style_value_t(num: Int32(value))
            _setProperty(property, value)
        } else {
            _setProperty(property, nil)
        }
    }

    mutating func setProperty(_ property: lv_style_prop_t, _ value: LVColor?) {
        if let value {
            let value = lv_style_value_t(color: value.color)
            _setProperty(property, value)
        } else {
            _setProperty(property, nil)
        }
    }
    
    mutating func setProperty(_ property: lv_style_prop_t, _ value: LVFont?) {
        if let value {
            let value = lv_style_value_t(ptr: value.font)
            _setProperty(property, value)
        } else {
            _setProperty(property, nil)
        }
    }

}

// FIXME: we'd like to use a property wrapped but accessing the enclosing instance can only be done with class types, and we don't want to make LVStyle a class because of the allocation cost

public extension LVStyle {
    var width: lv_coord_t? {
        get {
            getProperty(LV_STYLE_WIDTH)
        }
        set {
            setProperty(LV_STYLE_WIDTH, newValue)
        }
    }
    
    var minWidth: lv_coord_t? {
        get {
            getProperty(LV_STYLE_MIN_WIDTH)
        }
        set {
            setProperty(LV_STYLE_MIN_WIDTH, newValue)
        }
    }

    var maxWidth: lv_coord_t? {
        get {
            getProperty(LV_STYLE_MAX_WIDTH)
        }
        set {
            setProperty(LV_STYLE_MAX_WIDTH, newValue)
        }
    }

    var height: lv_coord_t? {
        get {
            getProperty(LV_STYLE_HEIGHT)
        }
        set {
            setProperty(LV_STYLE_HEIGHT, newValue)
        }
    }

    var minHeight: lv_coord_t? {
        get {
            getProperty(LV_STYLE_MIN_HEIGHT)
        }
        set {
            setProperty(LV_STYLE_MIN_HEIGHT, newValue)
        }
    }

    var maxHeight: lv_coord_t? {
        get {
            getProperty(LV_STYLE_MAX_HEIGHT)
        }
        set {
            setProperty(LV_STYLE_MAX_HEIGHT, newValue)
        }
    }

    var x: lv_coord_t? {
        get {
            getProperty(LV_STYLE_X)
        }
        set {
            setProperty(LV_STYLE_X, newValue)
        }
    }

    var y: lv_coord_t? {
        get {
            getProperty(LV_STYLE_Y)
        }
        set {
            setProperty(LV_STYLE_Y, newValue)
        }
    }

    var alignment: lv_align_t? {
        get {
            getProperty(LV_STYLE_ALIGN)
        }
        set {
            setProperty(LV_STYLE_ALIGN, newValue)
        }
    }

    var widthTransformation: lv_coord_t? {
        get {
            getProperty(LV_STYLE_TRANSFORM_WIDTH)
        }
        set {
            setProperty(LV_STYLE_TRANSFORM_WIDTH, newValue)
        }
    }
    
    var heighTransformation: lv_coord_t? {
        get {
            getProperty(LV_STYLE_TRANSFORM_HEIGHT)
        }
        set {
            setProperty(LV_STYLE_TRANSFORM_HEIGHT, newValue)
        }
    }

    var xTranslation: lv_coord_t? {
        get {
            getProperty(LV_STYLE_TRANSLATE_X)
        }
        set {
            setProperty(LV_STYLE_TRANSLATE_X, newValue)
        }
    }

    var yTranslation: lv_coord_t? {
        get {
            getProperty(LV_STYLE_TRANSLATE_Y)
        }
        set {
            setProperty(LV_STYLE_TRANSLATE_Y, newValue)
        }
    }

    var zoomTransform: lv_coord_t? {
        get {
            getProperty(LV_STYLE_TRANSFORM_ZOOM)
        }
        set {
            setProperty(LV_STYLE_TRANSFORM_ZOOM, newValue)
        }
    }

    var angleTransform: lv_coord_t? {
        get {
            getProperty(LV_STYLE_TRANSFORM_ANGLE)
        }
        set {
            setProperty(LV_STYLE_TRANSFORM_ANGLE, newValue)
        }
    }

    var xPivotTransform: lv_coord_t? {
        get {
            getProperty(LV_STYLE_TRANSFORM_PIVOT_X)
        }
        set {
            setProperty(LV_STYLE_TRANSFORM_PIVOT_X, newValue)
        }
    }

    var yPivotTransform: lv_coord_t? {
        get {
            getProperty(LV_STYLE_TRANSFORM_PIVOT_Y)
        }
        set {
            setProperty(LV_STYLE_TRANSFORM_PIVOT_Y, newValue)
        }
    }

    var topPadding: lv_coord_t? {
        get {
            getProperty(LV_STYLE_PAD_TOP)
        }
        set {
            setProperty(LV_STYLE_PAD_TOP, newValue)
        }
    }

    var bottomPadding: lv_coord_t? {
        get {
            getProperty(LV_STYLE_PAD_BOTTOM)
        }
        set {
            setProperty(LV_STYLE_PAD_BOTTOM, newValue)
        }
    }
    
    var leftPadding: lv_coord_t? {
        get {
            getProperty(LV_STYLE_PAD_LEFT)
        }
        set {
            setProperty(LV_STYLE_PAD_LEFT, newValue)
        }
    }
    
    var rightPadding: lv_coord_t? {
        get {
            getProperty(LV_STYLE_PAD_RIGHT)
        }
        set {
            setProperty(LV_STYLE_PAD_RIGHT, newValue)
        }
    }

    var rowPadding: lv_coord_t? {
        get {
            getProperty(LV_STYLE_PAD_ROW)
        }
        set {
            setProperty(LV_STYLE_PAD_ROW, newValue)
        }
    }

    var columnPadding: lv_coord_t? {
        get {
            getProperty(LV_STYLE_PAD_COLUMN)
        }
        set {
            setProperty(LV_STYLE_PAD_COLUMN, newValue)
        }
    }

    var backgroundColor: LVColor? {
        get {
            getProperty(LV_STYLE_BG_COLOR)
        }
        set {
            setProperty(LV_STYLE_BG_COLOR, newValue)
        }
    }
    
    var backgroundOpacity: lv_opa_t? {
        get {
            getProperty(LV_STYLE_BG_OPA)
        }
        set {
            setProperty(LV_STYLE_BG_OPA, newValue)
        }
    }

    var backgroundGradientColor: LVColor? {
        get {
            getProperty(LV_STYLE_BG_GRAD_COLOR)
        }
        set {
            setProperty(LV_STYLE_BG_GRAD_COLOR, newValue)
        }
    }

    var backgroundGradientDirection: lv_grad_dir_t? {
        get {
            getProperty(LV_STYLE_BG_GRAD_DIR)
        }
        set {
            setProperty(LV_STYLE_BG_GRAD_DIR, newValue)
        }
    }

    var backgroundMainStop: lv_coord_t? {
        get {
            getProperty(LV_STYLE_BG_MAIN_STOP)
        }
        set {
            setProperty(LV_STYLE_BG_MAIN_STOP, newValue)
        }
    }

    var backgroundGradientStop: lv_coord_t? {
        get {
            getProperty(LV_STYLE_BG_GRAD_STOP)
        }
        set {
            setProperty(LV_STYLE_BG_GRAD_STOP, newValue)
        }
    }

    // TODO: LV_STYLE_BG_GRAD
    // TODO: LV_STYLE_BG_DITHER_MODE
    // TODO: LV_STYLE_BG_IMG_SRC
    // TODO: LV_STYLE_BG_IMG_OPA
    // TODO: LV_STYLE_BG_IMG_RECOLOR
    // TODO: LV_STYLE_BG_IMG_RECOLOR_OPA
    // TODO: LV_STYLE_BG_IMG_TILED
    
    var borderColor: LVColor? {
        get {
            getProperty(LV_STYLE_BORDER_COLOR)
        }
        set {
            setProperty(LV_STYLE_BORDER_COLOR, newValue)
        }
    }
    
    var borderOpacity: lv_opa_t? {
        get {
            getProperty(LV_STYLE_BORDER_OPA)
        }
        set {
            setProperty(LV_STYLE_BORDER_OPA, newValue)
        }
    }

    var borderWidth: lv_coord_t? {
        get {
            getProperty(LV_STYLE_BORDER_WIDTH)
        }
        set {
            setProperty(LV_STYLE_BORDER_WIDTH, newValue)
        }
    }

    var borderSide: lv_border_side_t? {
        get {
            getProperty(LV_STYLE_BORDER_SIDE)
        }
        set {
            setProperty(LV_STYLE_BORDER_SIDE, newValue)
        }
    }

    var borderPost: Bool? {
        get {
            getProperty(LV_STYLE_BORDER_POST)
        }
        set {
            setProperty(LV_STYLE_BORDER_POST, newValue)
        }
    }
    
    var outlineWidth: lv_coord_t? {
        get {
            getProperty(LV_STYLE_OUTLINE_WIDTH)
        }
        set {
            setProperty(LV_STYLE_OUTLINE_WIDTH, newValue)
        }
    }

    var outlineColor: LVColor? {
        get {
            getProperty(LV_STYLE_OUTLINE_COLOR)
        }
        set {
            setProperty(LV_STYLE_OUTLINE_COLOR, newValue)
        }
    }

    var outlineOpacity: lv_opa_t? {
        get {
            getProperty(LV_STYLE_OUTLINE_OPA)
        }
        set {
            setProperty(LV_STYLE_OUTLINE_OPA, newValue)
        }
    }

    var outlinePad: lv_coord_t? {
        get {
            getProperty(LV_STYLE_OUTLINE_PAD)
        }
        set {
            setProperty(LV_STYLE_OUTLINE_PAD, newValue)
        }
    }

    var shadowWidth: lv_coord_t? {
        get {
            getProperty(LV_STYLE_SHADOW_WIDTH)
        }
        set {
            setProperty(LV_STYLE_SHADOW_WIDTH, newValue)
        }
    }

    var shadowXOffset: lv_coord_t? {
        get {
            getProperty(LV_STYLE_SHADOW_OFS_X)
        }
        set {
            setProperty(LV_STYLE_SHADOW_OFS_X, newValue)
        }
    }

    var shadowYOffset: lv_coord_t? {
        get {
            getProperty(LV_STYLE_SHADOW_OFS_Y)
        }
        set {
            setProperty(LV_STYLE_SHADOW_OFS_Y, newValue)
        }
    }

    var shadowSpread: lv_coord_t? {
        get {
            getProperty(LV_STYLE_SHADOW_SPREAD)
        }
        set {
            setProperty(LV_STYLE_SHADOW_SPREAD, newValue)
        }
    }

    var shadowColor: LVColor? {
        get {
            getProperty(LV_STYLE_SHADOW_COLOR)
        }
        set {
            setProperty(LV_STYLE_SHADOW_COLOR, newValue)
        }
    }

    var shadowOpacity: lv_opa_t? {
        get {
            getProperty(LV_STYLE_SHADOW_OPA)
        }
        set {
            setProperty(LV_STYLE_SHADOW_OPA, newValue)
        }
    }
    
    // TODO: LV_STYLE_IMG_OPA
    // TODO: LV_STYLE_IMG_RECOLOR
    // TODO: LV_STYLE_IMG_RECOLOR_OPA
    // TODO: LV_STYLE_LINE_WIDTH
    // TODO: LV_STYLE_LINE_DASH_WIDTH
    // TODO: LV_STYLE_LINE_DASH_GAP
    // TODO: LV_STYLE_LINE_ROUNDED
    // TODO: LV_STYLE_LINE_COLOR
    // TODO: LV_STYLE_LINE_OPA
    // TODO: LV_STYLE_ARC_WIDTH
    // TODO: LV_STYLE_ARC_ROUNDED


    var arcColor: LVColor? {
        get {
            getProperty(LV_STYLE_ARC_COLOR)
        }
        set {
            setProperty(LV_STYLE_ARC_COLOR, newValue)
        }
    }
    
    // TODO: LV_STYLE_ARC_OPA
    // TODO: LV_STYLE_ARC_IMG_SRC

    var textColor: LVColor? {
        get {
            getProperty(LV_STYLE_TEXT_COLOR)
        }
        set {
            setProperty(LV_STYLE_TEXT_COLOR, newValue)
        }
    }
    
    var textOpacity: lv_opa_t? {
        get {
            getProperty(LV_STYLE_TEXT_OPA)
        }
        set {
            setProperty(LV_STYLE_TEXT_OPA, newValue)
        }
    }

    var textFont: LVFont? {
        get {
            getProperty(LV_STYLE_TEXT_FONT)
        }
        set {
            setProperty(LV_STYLE_TEXT_FONT, newValue)
        }
    }

    var textLetterSpacing: lv_coord_t? {
        get {
            getProperty(LV_STYLE_TEXT_LETTER_SPACE)
        }
        set {
            setProperty(LV_STYLE_TEXT_LETTER_SPACE, newValue)
        }
    }
    
    var textLineSpacing: lv_coord_t? {
        get {
            getProperty(LV_STYLE_TEXT_LINE_SPACE)
        }
        set {
            setProperty(LV_STYLE_TEXT_LINE_SPACE, newValue)
        }
    }

    var textDocor: lv_text_decor_t? {
        get {
            getProperty(LV_STYLE_TEXT_DECOR)
        }
        set {
            setProperty(LV_STYLE_TEXT_DECOR, newValue)
        }
    }

    var textAlignment: lv_text_align_t? {
        get {
            getProperty(LV_STYLE_TEXT_ALIGN)
        }
        set {
            setProperty(LV_STYLE_TEXT_ALIGN, newValue)
        }
    }

    var radius: lv_coord_t? {
        get {
            getProperty(LV_STYLE_RADIUS)
        }
        set {
            setProperty(LV_STYLE_RADIUS, newValue)
        }
    }
    
    var clipCorner: Bool? {
        get {
            getProperty(LV_STYLE_CLIP_CORNER)
        }
        set {
            setProperty(LV_STYLE_CLIP_CORNER, newValue)
        }
    }

    var opacity: lv_opa_t? {
        get {
            getProperty(LV_STYLE_OPA)
        }
        set {
            setProperty(LV_STYLE_OPA, newValue)
        }
    }
    
    // TODO: LV_STYLE_COLOR_FILTER_DSC
    
    var colorFilterOpacity: lv_opa_t? {
        get {
            getProperty(LV_STYLE_COLOR_FILTER_OPA)
        }
        set {
            setProperty(LV_STYLE_COLOR_FILTER_OPA, newValue)
        }
    }

    // TODO: LV_STYLE_ANIM
    // TODO: LV_STYLE_ANIM_TIME
    // TODO: LV_STYLE_ANIM_SPEED
    // TODO: LV_STYLE_TRANSITION
    
    var blendMode: lv_blend_mode_t? {
        get {
            getProperty(LV_STYLE_BLEND_MODE)
        }
        set {
            setProperty(LV_STYLE_BLEND_MODE, newValue)
        }
    }

    var layout: UInt16? {
        get {
            getProperty(LV_STYLE_LAYOUT)
        }
        set {
            setProperty(LV_STYLE_LAYOUT, newValue)
        }
    }
    
    var baseDir: UInt16? {
        get {
            getProperty(LV_STYLE_BASE_DIR)
        }
        set {
            setProperty(LV_STYLE_BASE_DIR, newValue)
        }
    }
}
