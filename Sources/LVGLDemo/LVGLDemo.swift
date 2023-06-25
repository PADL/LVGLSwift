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
import ArgumentParser

@main
struct App {
    static func main() {
        let runLoop = LVRunLoop.shared

        /// example based on https://github.com/scottandrew/LVGLSwift
        /// used with permission from author

        let screenStyle = LVStyle()
        screenStyle.backgroundColor = LVColor.black
        screenStyle.backgroundOpacity = lv_opa_t(LV_OPA_COVER)
        screenStyle.textColor = LVColor.white

        let buttonStyle = LVStyle()
        buttonStyle.backgroundColor = LVColor(red: 0, green: 0, blue: 255)
        buttonStyle.borderWidth = 0
        buttonStyle.radius = 5
        buttonStyle.topPadding = 10
        buttonStyle.leftPadding = 10
        buttonStyle.backgroundOpacity = lv_opa_t(LV_OPA_COVER)

        let arcStyle = LVStyle()
        arcStyle.arcColor = LVColor(hexValue: 0x909090)
        arcStyle.arcWidth = 15
        arcStyle.arcIsRounded = true

        let theme = LVTheme { theme, object in
            switch object {
            case is LVScreen:
                object.append(style: screenStyle, selector: lv_style_selector_t(LV_STATE_ANY))
                break
            case is LVButton:
                object.append(style: buttonStyle, selector: lv_style_selector_t(LV_STATE_PRESSED))
                break
            case is LVSlider:
                object.append(style: arcStyle, selector: lv_style_selector_t(LV_STATE_ANY))
                object.append(style: arcStyle, selector: lv_style_selector_t(LV_PART_INDICATOR))
                break
            case is LVArc:
                object.append(style: arcStyle, selector: lv_style_selector_t(LV_STATE_ANY))
                object.append(style: arcStyle, selector: lv_style_selector_t(LV_PART_INDICATOR))
                break
            default:
                break
            }
        }
        
        var display = LVDisplay()
        display.theme = theme
        
        let screen = LVScreen.current
        let button = LVButton(with: screen)
        let label = LVLabel(with: button)
        let arc = LVArc(with: screen)
        let slider = LVSlider(with: screen)
        
        arc.size = LVSize(width: 250, height: 100)
        slider.size = LVSize(width: 150, height: 10)
        
        button.center()
        slider.center()
        
        label.text = "Hello, world!"
        
        screen.load()

        Task { @MainActor in
            for await event in screen.events {
                debugPrint("\(event)")
            }
        }

        runLoop.run()
    }
}
