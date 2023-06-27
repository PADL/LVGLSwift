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

public enum LVImageSource {
    case file(String)
    // TODO: other image source types
}

public class LVImage: LVObject {
    required public init(with parent: LVObject!) {
        super.init(lv_img_create(parent.object), with: parent)
    }
    
    public var source: LVImageSource {
        get {
            let source = lv_img_get_src(object)
            switch Int(lv_img_src_get_type(source)) {
            case LV_IMG_SRC_FILE:
                return withUnsafePointer(to: source) {
                    $0.withMemoryRebound(to: UnsafePointer<CChar>.self, capacity: 1) {
                        let file = String(cString: $0.pointee, encoding: .utf8)!
                        return LVImageSource.file(file)
                    }
                }
            default:
                fatalError("not implemented")
            }
        }
        set {
            precondition(isValid)
            switch newValue {
            case .file(let file):
                lv_img_set_src(object, file)
            default:
                fatalError("not implemented")
            }
        }
    }
    
    public var xOffset: lv_coord_t {
        get {
            lv_img_get_offset_x(object)
        }
        set {
            precondition(isValid)
            lv_img_set_offset_x(object, newValue)
        }
    }
    
    public var yOffset: lv_coord_t {
        get {
            lv_img_get_offset_y(object)
        }
        set {
            precondition(isValid)
            lv_img_set_offset_y(object, newValue)
        }
    }
    
    public var angle: Int16 {
        get {
            Int16(lv_img_get_angle(object))
        }
        set {
            precondition(isValid)
            lv_img_set_angle(object, newValue)
        }
    }
    
    public var pivot: lv_point_t {
        get {
            var pivot = lv_point_t(x: 0, y: 0)
            lv_img_get_pivot(object, &pivot)
            return pivot
        }
        set {
            precondition(isValid)
            lv_img_set_pivot(object, newValue.x, newValue.y)
        }
    }
    
    public var zoom: UInt16 {
        get {
            lv_img_get_zoom(object)
        }
        set {
            precondition(isValid)
            lv_img_set_zoom(object, newValue)
        }
    }
    
    public var isAntialiased: Bool {
        get {
            lv_img_get_antialias(object)
        }
        set {
            precondition(isValid)
            lv_img_set_antialias(object, newValue)
        }
    }
    
    public var sizeMode: lv_img_size_mode_t {
        get {
            lv_img_get_size_mode(object)
        }
        set {
            precondition(isValid)
            lv_img_set_size_mode(object, newValue)
        }
    }
}
