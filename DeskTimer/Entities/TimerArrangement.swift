//
//  TimerArrangement.swift
//  DeskTimer
//
//  Created by Denis on 01.02.2023.
//

import SwiftUI

protocol TimerArrangementProtocol: Identifiable {
    var timers: [DTimer] { get }
}

class TimerArrangement: TimerArrangementProtocol, ObservableObject {
    var id = UUID()
}

extension TimerArrangementProtocol {
    var timers: [DTimer] {
        return []
    }
}
