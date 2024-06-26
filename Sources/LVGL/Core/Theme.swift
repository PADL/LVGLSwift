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

public class LVTheme {
  public typealias Callback = (LVTheme, LVObject) -> ()

  var theme: lv_theme_t = .init()
  private let callback: Callback?

  public init(_ callback: Callback? = nil) {
    if let callback {
      self.callback = callback
    } else {
      self.callback = nil
    }
    theme.parent = nil
    theme.user_data = bridgeToCLVGL(self)
    theme.disp = lv_disp_get_default()
    primaryColor = .white
    secondaryColor = .black
    smallFont = LVFont.defaultFont
    normalFont = LVFont.defaultFont
    largeFont = LVFont.defaultFont
    flags = 0

    theme.apply_cb = { (
      themePointer: UnsafeMutablePointer<_lv_theme_t>?,
      objectPointer: UnsafeMutablePointer<lv_obj_t>?
    ) in
      guard let themePointer,
            let theme = themePointer.swiftObject,
            let callback = theme.callback,
            let objectPointer
      else {
        return
      }

      if let object: LVObject = objectPointer.swiftObject {
        callback(theme, object)
      } else if objectPointer.pointee.flags != 0 {
        // check flags, because when zero we're likely constructing the object
        debugPrint("LVGL object \(objectPointer) is missing associated Swift object!")
      }
    }
  }

  init(_ theme: lv_theme_t) {
    self.theme = theme
    callback = nil
  }

  public var primaryColor: LVColor {
    get {
      LVColor(theme.color_primary)
    }
    set {
      theme.color_primary = newValue.color
    }
  }

  public var secondaryColor: LVColor {
    get {
      LVColor(theme.color_secondary)
    }
    set {
      theme.color_secondary = newValue.color
    }
  }

  public var smallFont: LVFont {
    get {
      LVFont(theme.font_small)
    }
    set {
      theme.font_small = newValue.font
    }
  }

  public var normalFont: LVFont {
    get {
      LVFont(theme.font_normal)
    }
    set {
      theme.font_normal = newValue.font
    }
  }

  public var largeFont: LVFont {
    get {
      LVFont(theme.font_large)
    }
    set {
      theme.font_large = newValue.font
    }
  }

  public var flags: UInt32 {
    get {
      theme.flags
    }
    set {
      theme.flags = newValue
    }
  }
}
