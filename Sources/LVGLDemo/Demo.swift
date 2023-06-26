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

@main
struct App {
    static func main() {
        let runLoop = LVRunLoop.shared // FIXME: needs to be called at top to do global initialization
        
        let screenStyle = LVStyle()
        screenStyle.backgroundColor = LVColor(hexValue: 0x663300)
        screenStyle.backgroundOpacity = lv_opa_t(LV_OPA_COVER)
        screenStyle.textColor = LVColor.white
        
        let buttonStyle = LVStyle()
        buttonStyle.backgroundColor = LVColor(red: 0, green: 100, blue: 0)
        buttonStyle.backgroundOpacity = lv_opa_t(LV_OPA_COVER)
        buttonStyle.textFont = LVFont(size: 18)

        let labelStyle = LVStyle()
        labelStyle.backgroundColor = LVColor(red: 0, green: 0, blue: 0)
        labelStyle.backgroundOpacity = 0
        labelStyle.textFont = LVFont(size: 24)
        
        let theme = LVTheme { theme, object in
            debugPrint("Callback for theme \(theme) object \(object)")
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
        button.append(style: buttonStyle, selector: lv_style_selector_t(LV_PART_MAIN))
        button.center()

        let buttonLabel = LVLabel(with: button)
        buttonLabel.text = "Stop Counter"
        buttonLabel.center()
        //buttonLabel.append(style: labelStyle, selector: lv_style_selector_t(LV_PART_MAIN))
        
        let anotherLabel = LVLabel(with: screen)
        anotherLabel.text = "Stopped"
        anotherLabel.center()
        anotherLabel.position.y = 150
        anotherLabel.append(style: labelStyle, selector: lv_style_selector_t(LV_PART_MAIN))
        
        let counterRunning = AsyncCurrentValueSubject(false)
        
        Task { @MainActor in
            for await _ in button.events {
                counterRunning.value.toggle()
            }
        }
        
        Task { @MainActor in
            var task: Task<Void, Never>? = nil
            
            for await state in counterRunning {
                debugPrint("state: \(state)")
                if state {
                    buttonLabel.text = "Stop Counter"
                    task = Task { @MainActor in
                        for await count in Clock(limit: nil) {
                            anotherLabel.text = "\(count)"
                        }
                    }
                } else {
                    if let task {
                        buttonLabel.text = "Start Counter"
                        anotherLabel.text = "Stopped"
                        task.cancel()
                    }
                    task = nil
                }
            }
        }
        

        runLoop.run()
    }
}

struct Clock: AsyncSequence, AsyncIteratorProtocol {
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
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return result
    }

    func makeAsyncIterator() -> Clock {
        self
    }
}
