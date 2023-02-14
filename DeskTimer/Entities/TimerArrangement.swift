//
//  TimerArrangement.swift
//  DeskTimer
//
//  Created by Denis on 01.02.2023.
//

import Foundation
import Combine

protocol TimerArrangementProtocol: AnyObject, Identifiable, Equatable {
    var timers: [DTimer] { get }
}

class TimerArrangement: TimerArrangementProtocol, ObservableObject {
    var id = UUID()
    
    static func == (lhs: TimerArrangement, rhs: TimerArrangement) -> Bool {
        return lhs === rhs
    }
}

extension TimerArrangementProtocol {
    var timers: [DTimer] {
        return []
    }
}
