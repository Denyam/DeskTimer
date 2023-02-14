//
//  DTimer.swift
//  DeskTimer
//
//  Created by Denis on 31.01.2023.
//

import Combine
import Foundation

class DTimer: ObservableObject {
    // MARK: - Constants
    
    private static let tickStep = 0.1
    
    // MARK: - Properties
    
    @Published var isRunning = false
    
    @Published var isRinging = false {
        didSet {
            if isRinging {
                isRunning = false
            }
        }
    }
    
    @Published var remainingSeconds = 0
    @Published var remainingMinutes = 0
    @Published var remainingHours = 0

    private var totalTime = TimeInterval(0.0)
    
    private var tickTimer: Cancellable?
    private var overallTimer: Cancellable?
    
    private var remainingTime = TimeInterval(0.0) {
        didSet {
            let intTime = Int(remainingTime)
            
            remainingSeconds = intTime % 60
            remainingMinutes = (intTime / 60) % 60
            remainingHours = intTime / 3600
        }
    }
    
    // MARK: - Methods
    
    func start() {
        guard !isRunning else {
            return
        }
        
        totalTime = TimeInterval(remainingSeconds) + TimeInterval(remainingMinutes) * 60.0 + TimeInterval(remainingHours) * 3600.0
        remainingTime = totalTime
        
        tickTimer = Timer.publish(every: Self.tickStep, on: .main, in: .default)
            .autoconnect()
            .prefix(Int(totalTime) * 10)
            .sink { [weak self] timerOutput in
            guard let self = self else {
                return
            }
            
                self.remainingTime -= Self.tickStep
        }
        
        overallTimer = Timer.publish(every: totalTime, on: .main, in: .default)
            .autoconnect()
            .first()
            .map { _ in true }
            .assign(to: \.isRinging, on: self)
        
        isRunning = true
    }
}

extension DTimer: Equatable {
    static func == (lhs: DTimer, rhs: DTimer) -> Bool {
        return lhs.totalTime == rhs.totalTime
    }
}
