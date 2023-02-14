//
//  SingleTimerArrangement.swift
//  DeskTimer
//
//  Created by Denis on 01.02.2023.
//

import Combine

class SingleTimerArrangement: TimerArrangement {
    private lazy var timer = DTimer()
}

extension SingleTimerArrangement {
    var timers: [DTimer] {
        return [timer]
    }
}
