//
//  Simple_PomodoroApp.swift
//  Simple Pomodoro
//
//  Created by Alexander Nicholas Neri on 10/04/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 1500 // 25 minutes in seconds
    @State private var timerActive = false

    var body: some View {
        VStack(spacing: 30) {
            Text("Pomodoro Timer")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("\(timeString(timeRemaining))")
                .font(.system(size: 84))

            HStack(spacing: 30) {
                Button(action: {
                    timerActive.toggle()
                    if timerActive {
                        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    } else {
                        timer.upstream.connect().cancel()
                    }
                }) {
                    Text(timerActive ? "Pause" : "Start")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background(timerActive ? Color.orange : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }

                Button(action: {
                    timeRemaining = 1500
                    timerActive = false
                    timer.upstream.connect().cancel()
                }) {
                    Text("Reset")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
        }
        .onReceive(timer) { _ in
            if timerActive {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
        }
    }

    func timeString(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60 % 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
