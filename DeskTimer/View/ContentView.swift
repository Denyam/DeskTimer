//
//  ContentView.swift
//  DeskTimer
//
//  Created by Denis on 31.01.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var timerCollection = {
        let collection = TimerCollection()
        collection.timers.append(SingleTimerArrangement(timer: DTimer()))

        return collection
    }()
    
    var body: some View {
        List {
            ForEach(timerCollection.timers) { arrangement in
                ArrangementView(arrangement)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
