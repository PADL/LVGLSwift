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

public class LVScreen: LVObject {
  public static let active = LVScreen(screen: lv_scr_act())

    init(screen: UnsafeMutablePointer<lv_obj_t>) {
        super.init(screen, with: nil)
    }

    public init() {
        super.init(lv_obj_create(nil), with: nil)
    }
  
    public required init(with parent: LVObject!) {
        super.init(lv_scr_act(), with: parent)
    }

    public func load() {
        lv_scr_load(object)
        precondition(isValid)
    }
}
