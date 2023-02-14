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
        collection.addArrangement(SingleTimerArrangement())

        return collection
    }()
    
    var body: some View {
        List {
            ForEach(timerCollection.timers) { arrangement in
                HStack {
                    ArrangementView(arrangement)
                    Button("Delete") {
                        timerCollection.removeArrangement(arrangement)
                    }
                }
            }
            
            Button("Add") {
                timerCollection.addArrangement(SingleTimerArrangement())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
