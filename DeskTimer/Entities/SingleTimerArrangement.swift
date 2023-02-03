//
//  SingleTimerArrangement.swift
//  DeskTimer
//
//  Created by Denis on 01.02.2023.
//

import SwiftUI

class SingleTimerArrangement: TimerArrangement {
    private var timer: DTimer

    init(timer: DTimer) {
        self.timer = timer
        super.init()
    }
}

extension SingleTimerArrangement {
    var timers: [DTimer] {
        return [timer]
    }
}
