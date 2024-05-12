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

public class LVLabel: LVObject {
  public required init(with parent: LVObject!) {
    super.init(lv_label_create(parent.object), with: parent)
  }

  public var text: String {
    get {
      String(cString: lv_label_get_text(object), encoding: .utf8)!
    }
    set {
      precondition(isValid)
      lv_label_set_text(object, newValue)
    }
  }

  public var longMode: lv_label_long_mode_t {
    get {
      lv_label_get_long_mode(object)
    }
    set {
      precondition(isValid)
      lv_label_set_long_mode(object, newValue)
    }
  }

  public var recolor: Bool {
    get {
      lv_label_get_recolor(object)
    }
    set {
      precondition(isValid)
      lv_label_set_recolor(object, newValue)
    }
  }

  // UInt16 because LV_LABEL_TEXT_SELECTION_OFF is 0xffff
  public var selection: ClosedRange<UInt16> {
    get {
      UInt16(lv_label_get_text_selection_start(object))...UInt16(lv_label_get_text_selection_end(object))
    }
    set {
      precondition(isValid)
      lv_label_set_text_sel_start(object, UInt32(newValue.lowerBound))
      lv_label_set_text_sel_end(object, UInt32(newValue.upperBound))
    }
  }

  func getPosition(letter: UInt32) -> lv_point_t {
    precondition(isValid)
    var position = lv_point_t(x: 0, y: 0)
    lv_label_get_letter_pos(object, letter, &position)
    return position
  }

  func getLetter(on position: lv_point_t) -> UInt32 {
    precondition(isValid)
    var position = position
    return lv_label_get_letter_on(object, &position)
  }

  func isCharacter(under position: lv_point_t) -> Bool {
    precondition(isValid)
    var position = position
    return lv_label_is_char_under_pos(object, &position)
  }

  func insert(text: String, at position: UInt32) {
    precondition(isValid)
    lv_label_ins_text(object, position, text)
  }

  func cut(characters: UInt32, at position: UInt32) {
    precondition(isValid)
    lv_label_cut_text(object, position, characters)
  }
}
