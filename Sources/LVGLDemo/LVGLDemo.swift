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

@main
struct App {
    static func main() async throws {
        let runLoop = LVRunLoop.shared
        
        var style = LVStyle()
    
        style.radius = 5
        style.textColor = LVColor.white
        style.backgroundColor = LVColor.black
        
        var theme = LVTheme { theme, object in
            object.append(style: style, selector: lv_style_selector_t(LV_STATE_PRESSED))
        }
        
        var display = LVDisplay()
        display.theme = theme
        
        let screen = LVScreen.current
        
        let button = LVButton(with: screen)
        let label = LVLabel(with: button)
        let arc = LVArc(with: screen)
        let slider = LVSlider(with: screen)
        
        arc.size = LVSize(width: 250, height: 500)
        slider.size = LVSize(width: 150, height: 10)
        
        button.center()
        slider.center()
        
        label.text = "Hello"
        
        screen.load()
        
        for await event in screen.events {
            debugPrint("received event \(event)")
        }
        
        await runLoop.run()
    }
}
