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

extension lv_coord_t {
    static var maxCoordinate = LVGLSwiftCoordMax()
    static var minCoordinate = LVGLSwiftCoordMin()

    static var gridContent: lv_coord_t {
        // TODO: don't calculate this here
        maxCoordinate - 101
    }
    
    static var gridTemplateLast: lv_coord_t {
        maxCoordinate
    }
    
    static func gridSpacer(_ size: lv_coord_t) -> lv_coord_t {
        maxCoordinate - 100 + size
    }
}

public class LVGrid {
    var container: LVObject
    var rowDescriptor: [lv_coord_t]
    var columnDescriptor: [lv_coord_t]
    
    public init(with container: LVObject,
                rows: lv_coord_t,
                columns: lv_coord_t,
                padding: lv_coord_t? = nil) {
        self.container = container
        self.columnDescriptor = Array(repeating: .gridContent, count: Int(columns))
        self.columnDescriptor.append(.gridTemplateLast)
        self.rowDescriptor = Array(repeating: .gridContent, count: Int(rows))
        self.rowDescriptor.append(.gridTemplateLast)
        
        lv_obj_set_grid_dsc_array(container.object, rowDescriptor, columnDescriptor)
    }
    
    var columnCount: Int {
        columnDescriptor.count - 1
    }
    
    var rowCount: Int {
        rowDescriptor.count - 1
    }
    
    func advance(_ cursor: inout lv_point_t) -> Bool {
        cursor.x += 1
        
        precondition(cursor.x <= columnCount)
        
        if cursor.x == columnCount {
            cursor.x = 0
            cursor.y += 1
            
            precondition(cursor.y <= rowCount)
            
            if cursor.y == rowCount {
                return false
            }
        }
        
        return true
    }
    
    public func apply() {
        var cursor = lv_point_t()
        container.forEachChild { child in
            guard advance(&cursor) else {
                return // TODO: add stop variable
            }
            
            lv_obj_set_grid_cell(child.object,
                                 LV_GRID_ALIGN_STRETCH, UInt8(cursor.x), 1,
                                 LV_GRID_ALIGN_CENTER, UInt8(cursor.y), 1)
        }
    }
}
