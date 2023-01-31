//
//  ContentView.swift
//  DeskTimer
//
//  Created by Denis on 31.01.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var timers = DTimerCollection()
    
    var body: some View {
        TimerView(timer: DTimer())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
