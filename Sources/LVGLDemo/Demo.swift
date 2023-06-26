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
    @MainActor
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
        counterLabel.append(style: labelStyle, selector: lv_style_selector_t(LV_PART_MAIN))
        
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

        runLoop.run()
    }
}

/// https://www.avanderlee.com/concurrency/asyncsequence/
fileprivate struct Counter: AsyncSequence, AsyncIteratorProtocol {
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
