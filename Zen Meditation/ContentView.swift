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
    @State private var showMenu = false // To control the visibility of the side menu
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                Text(timeString(time: remainingTime))
                    .onReceive(timer) { _ in
                        if self.remainingTime > 0 && self.timerIsRunning {
                            self.remainingTime -= 1
                        } else if self.remainingTime <= 0 {
                            self.timerIsRunning = false
                        }
                    }
                
                HStack {
                    Text("First")
                        .foregroundColor(sectionColor(section: 1))
                    Text("Second")
                        .foregroundColor(sectionColor(section: 2))
                    Text("Third")
                        .foregroundColor(sectionColor(section: 3))
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
            }
            .padding()
            .navigationBarItems(trailing: Button(action: {
                self.showMenu.toggle() // Toggle the side menu visibility
            }) {
                Image(systemName: "line.horizontal.3") // Hamburger menu icon
                    .imageScale(.large)
            })
            .sheet(isPresented: $showMenu) {
                // Your menu content here
                Text("Menu Items")
            }
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    // Determine the section color based on the remaining time
    func sectionColor(section: Int) -> Color {
        let thirdDuration = countdownDuration / 3
        let currentSection = Int((countdownDuration - remainingTime) / thirdDuration) + 1
        return currentSection == section ? .blue : .gray
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
