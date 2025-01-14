//
//  ContentView.swift
//  2025
//
//  Created by Hamza Osama on 1/13/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
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
            return (calendar.dateComponents([.day], from: year2025Start, to: now).day ?? 0) + 1
        }
    }
    
    var daysRemaining: Int {
        Int(timeRemaining) / 86400
    }
    
    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color.black : Color.white)
                .ignoresSafeArea()
            
            VStack {
                Text("2025")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .padding(.top, 60)
                
                Spacer()
                
                // Dot Matrix Pattern
                VStack(spacing: 15) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: 15) {
                            ForEach(0..<columns, id: \.self) { column in
                                let index = row * columns + column
                                Circle()
                                    .fill(getDotColor(for: index))
                                    .frame(width: 4, height: 4)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .scaleEffect(0.8)
                
                Spacer()
                
                // Countdown Display
                HStack {
                    Text("\(daysRemaining)")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    
                    Text("days left")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor((colorScheme == .dark ? Color.white : Color.black).opacity(0.5))
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
    
    private func getDotColor(for index: Int) -> Color {
        let totalDays = 365
        
        if index >= totalDays {
            return .clear
        }
        
        let baseColor = colorScheme == .dark ? Color.white : Color.black
        
        if index < daysElapsedIn2025 {
            return baseColor.opacity(1.0)
        } else {
            return baseColor.opacity(0.3)
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
