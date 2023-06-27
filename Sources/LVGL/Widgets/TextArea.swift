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

public class LVTextArea: LVObject {
  public required init(with parent: LVObject!) {
    super.init(lv_textarea_create(parent.object), with: parent)
  }

  public var text: String {
    get {
      String(cString: lv_textarea_get_text(object), encoding: .utf8)!
    }
    set {
      precondition(isValid)
      lv_textarea_set_text(object, newValue)
    }
  }

  public var placeholderText: String {
    get {
      String(cString: lv_textarea_get_placeholder_text(object), encoding: .utf8)!
    }
    set {
      precondition(isValid)
      lv_textarea_set_placeholder_text(object, newValue)
    }
  }

  public var cursorPosition: Int32 {
    get {
      Int32(lv_textarea_get_cursor_pos(object))
    }
    set {
      precondition(isValid)
      lv_textarea_set_cursor_pos(object, newValue)
    }
  }

  public var canPositionCursorByClicking: Bool {
    get {
      lv_textarea_get_cursor_click_pos(object)
    }
    set {
      precondition(isValid)
      lv_textarea_set_cursor_click_pos(object, newValue)
    }
  }

  public var passwordMode: Bool {
    get {
      lv_textarea_get_password_mode(object)
    }
    set {
      precondition(isValid)
      lv_textarea_set_password_mode(object, newValue)
    }
  }

  public var passwordBullet: String {
    get {
      String(cString: lv_textarea_get_password_bullet(object), encoding: .utf8)!
    }
    set {
      precondition(isValid)
      lv_textarea_set_password_bullet(object, newValue)
    }
  }

  public var isSingleline: Bool {
    get {
      lv_textarea_get_one_line(object)
    }
    set {
      precondition(isValid)
      lv_textarea_set_one_line(object, newValue)
    }
  }

  public var isMultiline: Bool {
    get {
      !isSingleline
    }
    set {
      precondition(isValid)
      isSingleline = !newValue
    }
  }

  public var acceptedCharacters: String {
    get {
      String(cString: lv_textarea_get_accepted_chars(object), encoding: .utf8)!
    }
    set {
      precondition(isValid)
      lv_textarea_set_accepted_chars(object, newValue)
    }
  }

  public var maximumCharacters: UInt32 {
    get {
      lv_textarea_get_max_length(object)
    }
    set {
      precondition(isValid)
      lv_textarea_set_max_length(object, newValue)
    }
  }

  public func setInsertReplacement(to newValue: String) {
    precondition(isValid)
    lv_textarea_set_insert_replace(object, newValue)
  }

  public var selectionMode: Bool {
    get {
      lv_textarea_get_text_selection(object)
    }
    set {
      precondition(isValid)
      lv_textarea_set_text_selection(object, newValue)
    }
  }

  public var passwordShowTime: TimeInterval {
    get {
      TimeInterval(lv_textarea_get_password_show_time(object) / 1000)
    }
    set {
      precondition(isValid)
      lv_textarea_set_password_show_time(object, UInt16(newValue * 1000))
    }
  }

  public var label: LVLabel {
    lv_textarea_get_label(object)!.swiftObject as! LVLabel
  }

  public func setTxtAlignment(to newValue: lv_text_align_t) {
    precondition(isValid)
    lv_textarea_set_align(object, newValue)
  }

  public func append(_ character: Character) {
    precondition(isValid)
    lv_textarea_add_char(object, _lv_txt_encoded_conv_wc(character.unicodeScalarCodePoint))
  }

  public func append(_ text: String) {
    precondition(isValid)
    lv_textarea_add_text(object, text)
  }

  public func removeLeadingCharacter() {
    precondition(isValid)
    lv_textarea_del_char(object)
  }

  public func removeTrailingCharacter() {
    precondition(isValid)
    lv_textarea_del_char_forward(object)
  }

  public func clearSelection() {
    precondition(isValid)
    lv_textarea_clear_selection(object)
  }

  public func moveCrsorRight() {
    precondition(isValid)
    lv_textarea_cursor_right(object)
  }

  public func moveCursorLeft() {
    precondition(isValid)
    lv_textarea_cursor_left(object)
  }

  public func moveCursorUp() {
    precondition(isValid)
    lv_textarea_cursor_up(object)
  }

  public func moveCursorDown() {
    precondition(isValid)
    lv_textarea_cursor_down(object)
  }
}

extension Character {
  var unicodeScalarCodePoint: UInt32 {
    let characterString = String(self)
    let scalars = characterString.unicodeScalars

    return scalars[scalars.startIndex].value
  }
}
