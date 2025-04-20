//
//  Scoreboard.swift
//  swift-2049
//
//  Created by Rajbir Singh Azra on 2025-04-19.
//
import SwiftUI

struct Scoreboard: View {
    @Environment(\.modelContext) private var modelContext
    var score: Int
    var secondary: SecondStat
    var secondaryValue: Int? {
        switch secondary {
        case .highScore:
            return max(score, Stats.getHighScore(context: modelContext) ?? 0)
        case .lowScore:
            return Stats.getLowScore(context: modelContext)
        case .averageScore:
            return Stats.getAverageScore(context: modelContext)
        case .none:
            return nil
        }
    }
    
    var body: some View {
        HStack {
            ScoreDisplay(score: score, label: "Current", width: CGFloat((secondary == SecondStat.none) ? 300 : 150))
            if secondary != SecondStat.none {
                ScoreDisplay(score: secondaryValue, label: secondary.rawValue, width: 150)
            }
        }
    }
}

struct ScoreDisplay: View {
    var score: Int?
    let label: String
    let width: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: width, height: 50)
                .foregroundColor(.accentColor)
            Text("\(label): \(score == nil ? "-" : String(score!))")
                .foregroundColor(.white)
        }
    }
}
