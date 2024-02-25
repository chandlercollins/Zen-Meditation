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
                    .font(.largeTitle) // Makes the font size larger
                    .fontWeight(.bold) // Makes the text bold
                    .onReceive(timer) { _ in
                        if self.remainingTime > 0 && self.timerIsRunning {
                            self.remainingTime -= 1
                        } else if self.remainingTime <= 0 {
                            self.timerIsRunning = false
                        }
                    }
                    .padding()

                
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
                
                .padding()
                VStack {
                    Text("First")
                        .foregroundColor(sectionColor(section: 1))
                    Text("Second")
                        .foregroundColor(sectionColor(section: 2))
                    Text("Third")
                        .foregroundColor(sectionColor(section: 3))
                }
    
            }
            .padding()
            .navigationTitle("Zen") // Set the title
            .navigationBarTitleDisplayMode(.inline) // Ensure the title is displayed inline for left alignment
            .navigationBarItems(trailing: Button(action: {
                self.showMenu.toggle() // Toggle the side menu visibility
            }) {
                Image(systemName: "line.horizontal.3") // Hamburger menu icon
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
    
    // Determine the section color based on the remaining time
    func sectionColor(section: Int) -> Color {
        let thirdDuration = countdownDuration / 3
        let currentSection = Int((countdownDuration - remainingTime) / thirdDuration) + 1
        return currentSection == section ? .blue : .gray
    }
}

struct MenuView: View {
    @Binding var showMenu: Bool // Binding to the parent view's showMenu state

    var body: some View {
        VStack {
            // Simulated Navigation Bar
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
                Spacer() // Extra spacer for balancing the X button
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
