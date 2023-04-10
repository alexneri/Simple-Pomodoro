//
//  ContentView.swift
//  Simple Pomodoro
//
//  Created by Alexander Nicholas Neri on 10/04/2023.
//

import SwiftUI
import AudioToolbox

struct ContentView: View {
    @State private var timer: Timer? = nil
    @State private var remainingTime = 1500
    @State private var isRunning = false
    @State private var backgroundColor = Color.white
    @State private var scaleEffect: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    @State private var editTime = false
    @State private var newTime = ""
    @State private var editTaskName = false
    @State private var taskName = ""
    @State private var newTaskName = ""

    var body: some View {
        VStack {
            Text("Pomodoro Timer")
                .font(.largeTitle)
                .padding()
            
            Text("Task: \(taskName)")
                .font(.title2)
                .padding()

            Text(timeFormatted(remainingTime))
                .font(.system(size: 80, design: .monospaced))
                .padding()

            HStack {
                Button(action: startTimer) {
                    Text("Start")
                        .font(.title)
                }
                .disabled(isRunning)
                .padding()

                Button(action: pauseTimer) {
                    Text("Pause")
                        .font(.title)
                }
                .disabled(!isRunning)
                .padding()

                Button(action: resetTimer) {
                    Text("Reset")
                        .font(.title)
                }
                .padding()
            }
        }
        Button(action: {
            editTime.toggle()
        }) {
            Text("Edit Time")
                .font(.title)
        }
        .sheet(isPresented: $editTime) {
            VStack {
                Text("Edit Remaining Time")
                    .font(.largeTitle)
                    .padding()

                TextField("Enter time in seconds", text: $newTime)
                    .keyboardType(.numberPad)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    if let time = Int(newTime) {
                        remainingTime = time
                    }
                    editTime.toggle()
                }) {
                    Text("Update Time")
                        .font(.title)
                }
                .padding()
            }
            .padding()
        }
        
        Button(action: {
            if !isRunning { // Only allow editing if the timer is not running
                editTaskName.toggle()
            }
        }) {
            Text("Edit Task Name")
                .font(.title)
        }
        .disabled(isRunning)
        .sheet(isPresented: $editTaskName) {
            VStack {
                Text("Edit Task Name")
                    .font(.largeTitle)
                    .padding()

                TextField("Enter task name", text: $newTaskName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    taskName = newTaskName
                    editTaskName.toggle()
                }) {
                    Text("Update Task Name")
                        .font(.title)
                }
                .padding()
            }
            .padding()
    // ... Existing modifiers

// ... Existing functions
}
        
        .padding()
        .background(backgroundColor)
        .scaleEffect(scaleEffect)
        .opacity(opacity)
        .animation(.easeInOut(duration: 0.3), value: scaleEffect)
        .animation(.easeInOut(duration: 0.3), value: opacity)
        .animation(.easeInOut(duration: 0.3), value: backgroundColor)
    }

    // Remaining functions are the same as previous code snippet, with the following modifications:

    func startTimer() {
        isRunning = true
        backgroundColor = Color.orange
        scaleEffect = 1.2
        opacity = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scaleEffect = 1.0
            self.opacity = 1.0
        }
        // Start the timer logic
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timer?.invalidate()
                isRunning = false
            }
        }
    }

    func pauseTimer() {
        timer?.invalidate()
        isRunning = false
        backgroundColor = Color.orange
        opacity = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.opacity = 1.0
        }
    }

    func resetTimer() {
        timer?.invalidate()
        isRunning = false
        remainingTime = 1500
        backgroundColor = Color.white
        scaleEffect = 1.2
        opacity = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scaleEffect = 1.0
            self.opacity = 1.0
        }
    }
    
    func playAlertAndVibrate() {
        // Vibrate the phone 4 times
        for i in 0..<4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 1.0) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
        }

        // Play alert tone twice
        for i in 0..<2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 1.0) {
                AudioServicesPlaySystemSound(1005) // 1005 is the ID for a default alert tone
            }
        }
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60 % 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    // Add this function to handle the timer reaching zero
    func timerFinished() {
        timer?.invalidate()
        isRunning = false
        backgroundColor = Color.green
        scaleEffect = 1.2
        opacity = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scaleEffect = 1.0
            self.opacity = 1.0
        }
        playAlertAndVibrate()
    }
}
