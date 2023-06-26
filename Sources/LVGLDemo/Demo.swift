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
import LVGL
import AsyncAlgorithms
import AsyncExtensions

/// example based on https://github.com/scottandrew/LVGLSwift
/// used with permission from author

@MainActor
private func CounterDemo() {
    let screenStyle = LVStyle()
    screenStyle.backgroundColor = LVColor(hexValue: 0x663300)
    screenStyle.backgroundOpacity = lv_opa_t(LV_OPA_COVER)
    screenStyle.textColor = LVColor.white
    
    let buttonStyle = LVStyle()
    buttonStyle.backgroundColor = LVColor(red: 0, green: 100, blue: 0)
    buttonStyle.backgroundOpacity = lv_opa_t(LV_OPA_COVER)
    buttonStyle.textFont = LVFont(size: 18)

    let buttonStylePressed = LVStyle()
    buttonStylePressed.backgroundColor = LVColor(red: 100, green: 0, blue: 0)
    buttonStylePressed.backgroundOpacity = lv_opa_t(LV_OPA_COVER)
    buttonStylePressed.textFont = LVFont(size: 18)

    let labelStyle = LVStyle()
    labelStyle.backgroundColor = LVColor(red: 0, green: 0, blue: 0)
    labelStyle.backgroundOpacity = 0
    labelStyle.textFont = LVFont(size: 48)
    
    let theme = LVTheme { theme, object in
        if object is LVScreen {
            object.append(style: screenStyle, selector: lv_style_selector_t(LV_PART_MAIN))
        }
    }
    
    let screen = LVScreen.active

    let display = LVDisplay.default
    display.theme = theme
    
    let button = LVButton(with: screen)
    button.size = LVSize(width: 200, height: 50)
    button.center()
    button.append(style: buttonStyle, selector: lv_style_selector_t(LV_STATE_DEFAULT))
    button.append(style: buttonStylePressed, selector: lv_style_selector_t(LV_STATE_PRESSED))
    button.center()

    let buttonLabel = LVLabel(with: button)
    buttonLabel.text = "Stop Counter"
    buttonLabel.center()
    
    let counterLabel = LVLabel(with: screen)
    counterLabel.text = ""
    counterLabel.center()
    counterLabel.position.y = 150
    counterLabel.append(style: labelStyle)
    
    let counterRunning = AsyncCurrentValueSubject(false)
    
    Task {
        for await _ in button.events {
            counterRunning.value.toggle()
        }
    }
    
    Task {
        var task: Task<Void, Never>? = nil
        
        for await state in counterRunning {
            if state {
                buttonLabel.text = "Stop Counter"
                task = Task {
                    for await count in Counter(limit: nil) {
                        counterLabel.text = "\(count)"
                        try? await Task.sleep(nanoseconds: 500_000_000)
                    }
                }
            } else {
                if let task {
                    task.cancel()
                    buttonLabel.text = "Start Counter"
                    counterLabel.text = "Stopped"
                }
                task = nil
            }
        }
    }
}

@MainActor
private func GridDemo() {
    let screenStyle = LVStyle()
    screenStyle.backgroundColor = LVColor.black
    screenStyle.backgroundOpacity = lv_opa_t(LV_OPA_COVER)

    let labelStyle = LVStyle()
    labelStyle.backgroundColor = LVColor(hexValue: 0x333300)
    labelStyle.backgroundOpacity = lv_opa_t(LV_OPA_COVER)
    labelStyle.textFont = LVFont(size: 48)
    labelStyle.textColor = LVColor.white
    labelStyle.radius = 0
    
    let textStyle = LVStyle()

    let screen = LVScreen.active
    let theme = LVTheme { theme, object in
        if object is LVScreen {
            object.append(style: screenStyle)
        }
    }
    LVDisplay.default.theme = theme

    let rowCount: UInt8 = 2, columnCount: UInt8 = 8
    let grid = LVGrid(with: screen, rows: rowCount, columns: columnCount)
    grid.size = screen.size
    grid.center()

    for x in 0..<columnCount {
        for y in 0..<rowCount {
            let object = LVButton(with: grid)
            object.append(style: labelStyle)
            object.size = LVSize(width: screen.size.width / Int16(columnCount),
                                 height: screen.size.height / Int16(rowCount))
            grid.set(cell: object, at: (x, y))

            let label = LVLabel(with: object)
            label.text = "\(y * columnCount + x + 1)"
            label.append(style: textStyle)
            label.longMode = lv_label_long_mode_t(LV_LABEL_LONG_CLIP)
            label.center()
        }
    }
}

@main
struct App {
    @MainActor
    static func main() {
        let runLoop = LVRunLoop.shared // FIXME: needs to be called at top to do global initialization
        
        //CounterDemo()
        GridDemo()
        
        runLoop.run()
    }
}

/// https://www.avanderlee.com/concurrency/asyncsequence/
private struct Counter: AsyncSequence, AsyncIteratorProtocol {
    typealias Element = Int

    let limit: Int?
    var current = 1

    mutating func next() async -> Int? {
        guard !Task.isCancelled else {
            return nil
        }

        if let limit {
            guard current <= limit else {
                return nil
            }
        }
        
        let result = current
        current += 1
        return result
    }

    func makeAsyncIterator() -> Counter {
        self
    }
}
