//
//  MainView.swift
//  swift-2049
//
//  Created by Rajbir Singh Azra on 2025-03-24.
//

import SwiftUI
import UIKit

struct SwiftUINumberTileController: UIViewControllerRepresentable {
    @Binding var score: Int
    // reset: false by default, true if reset requested
    @Binding var reset: Bool
    // result: nil if ongoing, False if lost, True if won
    @Binding var gameOver: Bool
    
    func makeUIViewController(context: Context) -> NumberTileGameViewController {
        let game = NumberTileGameViewController(dimension: 4, threshold: 8)
        let originalDelegate = game.model?.delegate
        context.coordinator.originalDelegate = originalDelegate!
        game.model?.delegate = context.coordinator
        return game
    }
    
    func updateUIViewController(_ uiViewController: NumberTileGameViewController, context: Context) {
        if self.reset == true {
            uiViewController.model?.delegate.reset()
            DispatchQueue.main.async {
                self.reset = false
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GameModelProtocol {
        // setup
        init(_ parent: SwiftUINumberTileController) {
            self.parent = parent
        }
        
        var parent: SwiftUINumberTileController
        var originalDelegate: GameModelProtocol?
        
        // unchanged protocol functions
        func reset() {
            DispatchQueue.main.async {
                self.parent.gameOver = false
            }
            originalDelegate?.reset()
        }
        func moveOneTile(from: (Int, Int), to: (Int, Int), value: Int) {
            originalDelegate?.moveOneTile(from: from, to: to, value: value)
        }
        func moveTwoTiles(from: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int) {
            originalDelegate?.moveTwoTiles(from: from, to: to, value: value)
        }
        func insertTile(at location: (Int, Int), withValue value: Int) {
            originalDelegate?.insertTile(at: location, withValue: value)
        }
        
        // protocol functions with new side effects
        func scoreChanged(to newScore: Int) {
            originalDelegate?.scoreChanged(to: newScore)
            DispatchQueue.main.async {
                self.parent.score = newScore
            }
        }
        func gameOver(won: Bool) {
            originalDelegate?.gameOver(won: won)
            DispatchQueue.main.async {
                self.parent.gameOver = true
            }
        }
    }
}

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var score: Int = 0
    @State private var reset: Bool = false
    @State private var showReset: Bool = false
    @State private var gameOver: Bool = false
    @State private var waiting: Bool = false
    @AppStorage("secondStat") var secondStat: SecondStat = .highScore
    let boardSize: CGFloat = 325
    
    var body: some View {
        NavigationStack {
            VStack {
                Scoreboard(score: score, secondary: secondStat)
                SwiftUINumberTileController(score: $score, reset: $reset, gameOver: $gameOver)
                    .frame(width: boardSize, height: boardSize)
            }
            .alert(isPresented: $gameOver) {
                Alert(
                    title: Text("Game Over!"),
                    primaryButton: .default(Text("Play Again")) {
                        reset = true
                    },
                    secondaryButton: .cancel(Text("Cancel")) {
                        waiting = true
                    }
                )
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            if waiting {
                                Stats.updateStats(with: score, context: modelContext)
                                waiting = false
                                reset = true
                            }
                            else {
                                showReset = true
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise.circle.fill")
                        }
                        .alert(isPresented: $showReset) {
                            Alert(
                                title: Text("Reset"),
                                message: Text("Are you sure?"),
                                primaryButton: .cancel(),
                                secondaryButton:
                                        .destructive(Text("Reset"),
                                                     action: {
                                                         Stats.updateStats(with: score, context: modelContext)
                                                         reset = true
                                                     }))
                        }
                        Spacer()
                        NavigationLink {
                            StatsView()
                        } label: {
                            //                            Image(systemName: "gear.circle.fill")
                            Image(systemName: "list.bullet.circle.fill")
                        }
                    }
                }
            }
        }
    }
}


enum SecondStat: String, CaseIterable {
    case highScore = "High Score"
    case lowScore = "Worst Score"
    case averageScore = "Average Score"
    case none = "None"
}

#Preview {
    MainView()
        .modelContainer(for: Stats.self, inMemory: true)
}
