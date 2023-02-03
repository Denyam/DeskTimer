//
//  DTimer.swift
//  DeskTimer
//
//  Created by Denis on 31.01.2023.
//

import Combine
import Foundation

class DTimer: ObservableObject {
    @Published var isRunning = false
    @Published var remainingSeconds = 0
    @Published var remainingMinutes = 0
    @Published var remainingHours = 0

    private var totalTime = TimeInterval(0.0)
    
    private var timerPublisher: Timer.TimerPublisher?
    private var cancellableTimer: Cancellable?
    
    private var remainingTime = TimeInterval(0.0) {
        didSet {
            let intTime = Int(remainingTime)
            
            remainingSeconds = intTime % 60
            remainingMinutes = (intTime / 60) % 60
            remainingHours = intTime / 3600
        }
    }
    
    func start() {
        guard !isRunning else {
            return
        }
        
        totalTime = TimeInterval(remainingSeconds) + TimeInterval(remainingMinutes) * 60.0 + TimeInterval(remainingHours) * 3600.0
        remainingTime = totalTime
        
        timerPublisher = Timer.publish(every: 0.1, on: .main, in: .default)
        cancellableTimer = timerPublisher?.autoconnect().sink { [weak self] timerOutput in
            self?.remainingTime -= 0.1
        }
        
        isRunning = true
    }
}

extension DTimer: Equatable {
    static func == (lhs: DTimer, rhs: DTimer) -> Bool {
        return lhs.totalTime == rhs.totalTime
    }
}
