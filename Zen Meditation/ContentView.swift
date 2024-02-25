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
    @State private var timerIsRunning = false // Changed to false to prevent auto-start
    @State private var showMenu = false
    @State private var hasTimerStarted = false // Keep track of the timer's start state
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                Text(timeString(time: remainingTime))
                    .font(.system(size: 24, weight: .bold))
                    .onReceive(timer) { _ in
                        if self.remainingTime > 0 && self.timerIsRunning {
                            self.remainingTime -= 1
                        } else if self.remainingTime <= 0 {
                            self.timerIsRunning = false
                            self.hasTimerStarted = false // Reset the start state when the timer ends
                        }
                    }
                    .padding()
                
                Button(action: {
                    if !hasTimerStarted || remainingTime <= 0 {
                        // Start the timer
                        self.remainingTime = self.countdownDuration
                        self.timerIsRunning = true
                        self.hasTimerStarted = true
                    } else if self.timerIsRunning {
                        // Pause the timer
                        self.timerIsRunning = false
                    } else {
                        // Resume the timer
                        self.timerIsRunning = true
                    }
                }) {
                    Text(getButtonLabel())
                }
                .padding()
                .background(timerIsRunning ? Color.blue : Color.green)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                if hasTimerStarted { // Show this VStack only if the timer has started
                    VStack {
                        Text("First")
                            .foregroundColor(sectionColor(section: 1))
                        Text("Second")
                            .foregroundColor(sectionColor(section: 2))
                        Text("Third")
                            .foregroundColor(sectionColor(section: 3))
                    }
                }
            }
            .padding()
            .navigationTitle("Zen")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                self.showMenu.toggle()
            }) {
                Image(systemName: "line.horizontal.3")
                    .imageScale(.large)
            })
            .sheet(isPresented: $showMenu) {
                MenuView(showMenu: $showMenu)
            }
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    func sectionColor(section: Int) -> Color {
        let thirdDuration = countdownDuration / 3
        let currentSection = Int((countdownDuration - remainingTime) / thirdDuration) + 1
        return currentSection == section ? .blue : .gray
    }
    
    func getButtonLabel() -> String {
        if !hasTimerStarted {
            return "Start"
        } else if timerIsRunning {
            return "Pause"
        } else if remainingTime > 0 {
            return "Resume"
        } else {
            return "Restart"
        }
    }
}

struct MenuView: View {
    @Binding var showMenu: Bool

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showMenu = false
                }) {
                    Image(systemName: "xmark")
                        .imageScale(.large)
                        .padding()
                }
                Spacer()
                Text("Settings")
                    .font(.headline)
                    .padding()
                Spacer()
                Spacer()
            }
            
            Divider()

            Spacer()
            Text("Menu Items")
                .frame(maxWidth: .infinity)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


