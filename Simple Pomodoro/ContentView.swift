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
    @State private var timerEditMode: Bool = false
    @State private var timerEnded: Bool = false
    @State private var todoItem: String = "I am working on something amazing!"

    var body: some View {
        VStack {
            VStack {
                VStack(spacing: 30) {
                    Text("Simple Pomo")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("What are you working on?")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .onTapGesture {
                            // Enable edit mode when user taps the header
                            withAnimation {
                                self.todoItem = ""
                            }
                        }
                    TextField("Enter text here", text: $todoItem)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10.0)
                        .padding(.horizontal, 60.0)
                    
                    if timerEditMode {
                        EditCountdownView(duration: $timeRemaining, timerEditMode: $timerEditMode)
                    } else {
                        Text("\(timeString(timeRemaining))")
                            .font(.system(size: 84))
                            .onTapGesture {
                                timerEditMode.toggle()
                            }
                    }

                    //            Text("\(timeString(timeRemaining))")
                    //                .font(.system(size: 84))

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
                .padding(.vertical, 100.0)
                .onReceive(timer) { _ in
                    if timerActive {
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        }
                    }
                }
                .onChange(of: timeRemaining) { newValue in
                    if newValue == 0 {
                        timerEnded = true
                        // Other code for timer reaching zero
                    }
            }
        }
            
            VStack {
                Text("Made with <3 by Alex Neri in Amsterdam")
                    .multilineTextAlignment(.center)
                    .padding(.top, 200.0)
            }
        }
    }
    func timeString(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60 % 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct EditCountdownView: View {
    @Binding var duration: Int
    @Binding var timerEditMode: Bool
    private let minuteOptions = Array(1...60)

    var body: some View {
        VStack {
            Text("Edit Countdown Duration (in minutes)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom)

            Picker(selection: $duration, label: Text("Minutes")) {
                ForEach(minuteOptions, id: \.self) { minute in
                    Text("\(minute) min").tag(minute * 60)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxWidth: 200)

            Button(action: {
                timerEditMode = false
            }) {
                Text("Done")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 25)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
