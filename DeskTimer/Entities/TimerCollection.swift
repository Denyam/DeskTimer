//
//  TimerCollection.swift
//  DeskTimer
//
//  Created by Denis on 31.01.2023.
//

import Combine
import Foundation

class TimerCollection: ObservableObject {
    @Published var timers = [TimerArrangement]()
    
    func addArrangement(_ timerArrangement: TimerArrangement) {
        timers.append(timerArrangement)
    }
    
    func removeArrangement(_ timerArrangement: TimerArrangement) {
        if let index = timers.firstIndex(of: timerArrangement) {
            timers.remove(at: index)
        }
    }
}
