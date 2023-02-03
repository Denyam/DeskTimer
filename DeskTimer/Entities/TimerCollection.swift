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
}

