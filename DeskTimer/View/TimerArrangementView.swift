//
//  TimerArrangementView.swift
//  DeskTimer
//
//  Created by Denis on 01.02.2023.
//

import SwiftUI

protocol TimerArrangementView: View {
    associatedtype ConcreteTimerArrangement: TimerArrangementProtocol
    
    init(_ timerArrangement: ConcreteTimerArrangement)
}

struct ArrangementView: TimerArrangementView {
    @ObservedObject private var timerArrangement: TimerArrangement
    
    var body: some View {
        if let singleTimerArrangement = timerArrangement as? SingleTimerArrangement {
            SingleTimerArrangementView(singleTimerArrangement)
        } else {
            EmptyView()
        }
    }
    
    init(_ timerArrangement: TimerArrangement) {
        self.timerArrangement = timerArrangement
    }
}

struct ArrangementView_Previews: PreviewProvider {
    static var previews: some View {
        ArrangementView(SingleTimerArrangement())
    }
}
