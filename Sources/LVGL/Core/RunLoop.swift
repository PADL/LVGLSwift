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

public class LVRunLoop {
    public static let shared = LVRunLoop()

    private var task: Task<Void, Never>
    
    public init(width: UInt32 = LV_HOR_RES, height: UInt32 = LV_VER_RES) {
        lv_init()
        LVGLSwiftDriverInit(width, height)

        // set user data for active screen (perhaps we should do for all screens?)
        let _ = LVScreen.active

        task = Task.detached {
            repeat {
                try? await Task.sleep(nanoseconds: 5 * 1_000_000)
                lv_tick_inc(5)
            } while !Task.isCancelled
        }
    }

    deinit {
        task.cancel()
        lv_deinit()
    }

    public func run() {
        precondition(self.isInitialized)
        
        let timer = Timer(timeInterval: Double(LV_DISP_DEF_REFR_PERIOD) / 1000, repeats: true) { timer in
            lv_task_handler()
        }
        let runLoop = RunLoop.main
        runLoop.add(timer, forMode: .common)
        runLoop.run()
    }

    public var isInitialized: Bool {
        lv_is_initialized()
    }
}
