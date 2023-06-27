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

public struct LVSize {
    public let width: lv_coord_t
    public let height: lv_coord_t

    public init(width: lv_coord_t, height: lv_coord_t) {
        self.width = width
        self.height = height
    }

    public static var content: Self {
        LVSize(width: .sizeContent, height: .sizeContent)
    }

    public static var zero: Self {
        LVSize(width: 0, height: 0)
    }
}

extension LVSize: Equatable {}
