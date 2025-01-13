//
//  ContentView.swift
//  2025
//
//  Created by Hamza Osama on 1/13/25.
//

import SwiftUI

struct ContentView: View {
    @State private var timeRemaining: TimeInterval = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let columns = 22
    let rows = 17 // Increased rows to accommodate 365 days (22 x 17 ≈ 374)
    
    var daysElapsedIn2025: Int {
        let calendar = Calendar.current
        let now = Date()
        let year2025Start = calendar.date(from: DateComponents(year: 2025, month: 1, day: 1))!
        let year2025End = calendar.date(from: DateComponents(year: 2026, month: 1, day: 1))!
        
        if now < year2025Start {
            return 0
        } else if now >= year2025End {
            return 365
        } else {
            return calendar.dateComponents([.day], from: year2025Start, to: now).day ?? 0
        }
    }
    
    var daysRemaining: Int {
        Int(timeRemaining) / 86400
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Text("2025")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 60)
                
                Spacer()
                
                // Dot Matrix Pattern
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: columns), spacing: 15) {
                    ForEach(0..<(columns * rows), id: \.self) { index in
                        Circle()
                            .fill(Color.white.opacity(getDotOpacity(for: index)))
                            .frame(width: 4, height: 4)
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                // Countdown Display
                HStack {
                    Text("\(daysRemaining)")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(.white)
                    
                    Text("days left")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            calculateTimeRemaining()
        }
        .onReceive(timer) { _ in
            calculateTimeRemaining()
        }
    }
    
    private func getDotOpacity(for index: Int) -> Double {
        let totalDays = 365
        
        // If the index is beyond the total days, don't show the dot
        if index >= totalDays {
            return 0.0
        }
        
        // If this dot represents a passed day in 2025, make it brighter
        if index < daysElapsedIn2025 {
            return 0.8
        } else {
            return 0.2
        }
    }
    
    private func calculateTimeRemaining() {
        let calendar = Calendar.current
        let components = DateComponents(year: 2026, month: 1, day: 1)
        guard let date2026 = calendar.date(from: components) else { return }
        timeRemaining = date2026.timeIntervalSince(Date())
    }
}

#Preview {
    ContentView()
}
