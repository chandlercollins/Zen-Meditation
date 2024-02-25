//
//  ContentView.swift
//  Zen Meditation
//
//  Created by Chandler Collins on 2/25/24.
//

import SwiftUI

struct ContentView: View {
    @State private var countdownDuration: TimeInterval = 15 * 60
    @State private var remainingTime: TimeInterval = 15 * 60
    @State private var timerIsRunning = true
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text(timeString(time: remainingTime))
                .onReceive(timer) { _ in
                    if self.remainingTime > 0 && self.timerIsRunning {
                        self.remainingTime -= 1
                    } else if self.remainingTime <= 0 {
                        self.timerIsRunning = false
                    }
                }
            Button(action: {
                if self.timerIsRunning {
                    self.timerIsRunning = false
                } else {
                    if self.remainingTime <= 0 {
                        self.remainingTime = self.countdownDuration
                    }
                    self.timerIsRunning = true
                }
            }) {
                Text(timerIsRunning ? "Pause" : (remainingTime <= 0 ? "Restart" : "Resume"))
            }
            .padding()
            .background(timerIsRunning ? Color.blue : Color.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            
            // Icons for each third of the timer
            HStack {
                Text("First")
                    .foregroundColor(currentThird() == 1 ? .blue : .gray)
                Text("Second")
                    .foregroundColor(currentThird() == 2 ? .blue : .gray)
                Text("Third")
                    .foregroundColor(currentThird() == 3 ? .blue : .gray)
            }
            .padding()
        }
        .padding()
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    // Determine the current third of the timer
    func currentThird() -> Int {
        let thirdDuration = countdownDuration / 3
        if remainingTime > 2 * thirdDuration {
            return 1 // First third
        } else if remainingTime > thirdDuration {
            return 2 // Second third
        } else {
            return 3 // Final third
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
