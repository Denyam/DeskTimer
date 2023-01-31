//
//  DTimerCollection.swift
//  DeskTimer
//
//  Created by Denis on 31.01.2023.
//

import Combine

enum DTimerArrangement {
    case single(DTimer)
    case repeatable(DTimer, Int)
    case sequence([DTimer])
}

class DTimerCollection: ObservableObject {
    @Published var timers = [DTimerArrangement]()
}
