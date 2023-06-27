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

public class LVLine: LVObject {
    public required init(with parent: LVObject!) {
        super.init(lv_label_create(parent.object), with: parent)
    }

    public func set(points: [lv_point_t]) {
        points.withUnsafeBufferPointer { (cArray: UnsafeBufferPointer<lv_point_t>) in
            lv_line_set_points(object, cArray.baseAddress, UInt16(cArray.count))
        }
    }

    public var yCoordinateInversion: Bool {
        get {
            lv_line_get_y_invert(object)
        }
        set {
            precondition(isValid)
            lv_line_set_y_invert(object, newValue)
        }
    }
}
