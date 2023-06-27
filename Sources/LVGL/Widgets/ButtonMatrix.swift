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

public class LVButtonMatrix: LVObject {
    public required init(with parent: LVObject!) {
        super.init(lv_btnmatrix_create(parent.object), with: parent)
    }

    // TODO: lv_btnmatrix_set_map
    // TODO: lv_btnmatrix_set_ctrl_map

    public var selection: UInt16 {
        get {
            lv_btnmatrix_get_selected_btn(object)
        }
        set {
            precondition(isValid)
            lv_btnmatrix_set_selected_btn(object, newValue)
        }
    }

    public func buttonText(for id: UInt16) -> String {
        precondition(isValid)
        return String(cString: lv_btnmatrix_get_btn_text(object, id), encoding: .utf8)!
    }

    public func hasButtonControl(id: UInt16, control: lv_btnmatrix_ctrl_t) -> Bool {
        precondition(isValid)
        return lv_btnmatrix_has_btn_ctrl(object, id, control)
    }

    public func setButtonControl(id: UInt16? = nil, control: lv_btnmatrix_ctrl_t) {
        precondition(isValid)
        if let id {
            lv_btnmatrix_set_btn_ctrl(object, id, control)
        } else {
            lv_btnmatrix_set_btn_ctrl_all(object, control)
        }
    }

    public func clearButtonControl(id: UInt16? = nil, control: lv_btnmatrix_ctrl_t) {
        precondition(isValid)
        if let id {
            lv_btnmatrix_clear_btn_ctrl(object, id, control)
        } else {
            lv_btnmatrix_clear_btn_ctrl_all(object, control)
        }
    }

    public func setButtonWidth(id: UInt16, width: UInt8) {
        precondition(isValid)
        lv_btnmatrix_set_btn_width(object, id, width)
    }

    public var oneChecked: Bool {
        get {
            lv_btnmatrix_get_one_checked(object)
        }
        set {
            precondition(isValid)
            lv_btnmatrix_set_one_checked(object, newValue)
        }
    }
}
