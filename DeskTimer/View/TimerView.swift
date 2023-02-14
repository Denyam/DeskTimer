//
//  TimerView.swift
//  DeskTimer
//
//  Created by Denis on 31.01.2023.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var timer: DTimer
    
    var body: some View {
        Form {
            HStack {
                TextField("Hours", value: $timer.remainingHours, formatter: NumberFormatter())
                    .disabled(timer.isRunning)
                
                Text(":")
                TextField("Minutes", value: $timer.remainingMinutes, formatter: NumberFormatter())
                    .disabled(timer.isRunning)
                
                Text(":")
                TextField("Seconds", value: $timer.remainingSeconds, formatter: NumberFormatter())
                    .disabled(timer.isRunning)
            }
            
            Button("Start") {
                timer.start()
            }
        }
        .alert(isPresented: $timer.isRinging) {
            Alert(title: Text("Timer elapsed"))
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timer: DTimer())
    }
}
