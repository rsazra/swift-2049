//
//  Results.swift
//  swift-2049
//
//  Created by Rajbir Singh Azra on 2025-04-16.
//

import Foundation
import SwiftData

@Model
class Stats {
    var gamesPlayed: Int
    var averageScore: Double
    var highScore: Int
    var lowScore: Int
    
    init(firstScore: Int) {
        self.gamesPlayed = 1
        self.averageScore = Double(firstScore)
        self.highScore = firstScore
        self.lowScore = firstScore
    }
    
    static func updateStats(with newScore: Int, context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<Stats>()
        guard let stats = (try? context.fetch(fetchDescriptor).first) else {
            let stats = Stats(firstScore: newScore)
            context.insert(stats)
            return
        }
        
        stats.gamesPlayed += 1
        
        if newScore > stats.highScore {
            stats.highScore = newScore
        }
        if newScore < stats.lowScore {
            stats.lowScore = newScore
        }
        
        let totalScore = stats.averageScore * Double(stats.gamesPlayed - 1) + Double(newScore)
        stats.averageScore = totalScore / Double(stats.gamesPlayed)
        
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
