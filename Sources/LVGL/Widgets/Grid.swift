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

extension lv_coord_t {
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

public class LVGrid: LVObject {
  var rowDescriptor = [lv_coord_t]()
  var columnDescriptor = [lv_coord_t]()
  private var _objects = [LVObject?]()

  public init(
    with parent: LVObject,
    rows: UInt8,
    columns: UInt8,
    padding: lv_coord_t? = nil
  ) {
    super.init(lv_obj_create(parent.object), with: parent)
    resize(rows: rows, columns: columns, padding: padding)
  }

  public required init(with parent: LVObject!) {
    super.init(lv_obj_create(parent.object), with: parent)
    resize(rows: 1, columns: 1, padding: nil)
  }

  public func resize(
    rows: UInt8,
    columns: UInt8,
    padding: lv_coord_t? = nil
  ) {
    columnDescriptor = Array(repeating: .gridContent, count: Int(columns))
    columnDescriptor.append(.gridTemplateLast)
    rowDescriptor = Array(repeating: .gridContent, count: Int(rows))
    rowDescriptor.append(.gridTemplateLast)
    _objects = Array(repeating: nil, count: Int(columns * rows))
    lv_obj_set_style_grid_column_dsc_array(object, columnDescriptor, 0)
    lv_obj_set_style_grid_row_dsc_array(object, rowDescriptor, 0)
    lv_obj_set_layout(object, UInt32(LV_LAYOUT_GRID))
  }

  var rowCount: Int {
    rowDescriptor.count - 1
  }

  var columnCount: Int {
    columnDescriptor.count - 1
  }

  public func set(cell: LVObject, at coordinate: (UInt8, UInt8)) {
    precondition(coordinate.0 < columnDescriptor.count - 1)
    precondition(coordinate.1 < rowDescriptor.count - 1)

    cell.parent = self

    if cell.size == .zero, size != .zero {
      cell.size = LVSize(
        width: size.width / Int16(columnCount),
        height: size.height / Int16(rowCount)
      )
    }

    // keep a reference
    _objects[(Int(coordinate.0) * rowCount) + Int(coordinate.1)] = cell
    lv_obj_set_grid_cell(
      cell.object,
      LV_GRID_ALIGN_STRETCH,
      coordinate.0,
      1,
      LV_GRID_ALIGN_STRETCH,
      coordinate.1,
      1
    )
  }
}
