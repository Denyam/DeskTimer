//
//  SingleTimerArrangementView.swift
//  DeskTimer
//
//  Created by Denis on 01.02.2023.
//

import SwiftUI

struct SingleTimerArrangementView: TimerArrangementView {
    @ObservedObject private var timer: DTimer
    
    var body: some View {
        TimerView(timer: DTimer())
    }
    
    init(_ timerArrangement: SingleTimerArrangement) {
        timer = timerArrangement.timers[0]
    }

}

struct SingleTimerArrangementView_Previews: PreviewProvider {
    static var previews: some View {
        SingleTimerArrangementView(SingleTimerArrangement(timer: DTimer()))
    }
}
