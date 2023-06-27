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

public class LVRoller: LVObject {
  public required init(with parent: LVObject!) {
    super.init(lv_roller_create(parent.object), with: parent)
  }

  public var options: [String] {
    get {
      guard let options = String(cString: lv_roller_get_options(object), encoding: .utf8)
      else {
        return []
      }
      return options.components(separatedBy: "\n")
    }
    set {
      withObjectCast(to: lv_roller_t.self) {
        let options = newValue.joined(separator: "\n")
        lv_roller_set_options(object, options, $0.mode)
      }
    }
  }

  public var mode: lv_roller_mode_t {
    get {
      withObjectCast(to: lv_roller_t.self) {
        $0.mode
      }
    }
    set {
      withObjectCast(to: lv_roller_t.self) {
        $0.mode = newValue
      }
    }
  }

  public var selected: UInt16 {
    get {
      lv_roller_get_selected(object)
    }
    set {
      lv_roller_set_selected(object, newValue, LV_ANIM_ON)
    }
  }

  public func setVisibleRowCount(_ rowCount: UInt8) {
    lv_roller_set_visible_row_count(object, rowCount)
  }

  public var optionCount: Int {
    Int(lv_roller_get_option_cnt(object))
  }
}
