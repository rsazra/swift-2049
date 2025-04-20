//
//  StatsView.swift
//  swift-2049
//
//  Created by Rajbir Singh Azra on 2025-04-19.
//
import SwiftUI

struct StatsView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("secondStat") var secondStat: SecondStat = .highScore
    
    var body: some View {
        Form {
            Section(header: Text("History")) {
                StatRow(label: SecondStat.highScore.rawValue, value: Stats.getHighScore(context: modelContext))
                StatRow(label: SecondStat.averageScore.rawValue, value: Stats.getAverageScore(context: modelContext))
                StatRow(label: SecondStat.lowScore.rawValue, value: Stats.getLowScore(context: modelContext))
            }
            Section(header: Text("Home Screen")) {
                Picker("Display Stat", selection: $secondStat) {
                    ForEach(SecondStat.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            }
        }
        .navigationTitle("Stats")
    }
}

struct StatRow: View {
    let label: String
    let value: Int?
    
    var body: some View {
        HStack {
            Text("\(label)")
            Spacer()
            Text("\(value == nil ? "-" : String(value!))")
        }
    }
}
