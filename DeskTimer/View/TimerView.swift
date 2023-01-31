//
//  TimerView.swift
//  DeskTimer
//
//  Created by Denis on 31.01.2023.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var timer: DTimer
    
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timer: DTimer())
    }
}
