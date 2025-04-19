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
    @Binding var result: Bool?
    
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
                self.parent.result = nil
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
                self.parent.result = won
            }
        }
    }
}

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var score: Int = 0
    @State private var showReset: Bool = false
    @State private var reset: Bool = false
    @State private var result: Bool? = nil
    @State private var highScore: Int = 0
    let boardSize: CGFloat = 325
    
    var body: some View {
        VStack {
            Text("Score: \(score)")
            Text("Result: \(String(describing: result))")
            Text("High score: \(max(highScore, score))")
            Spacer()
            SwiftUINumberTileController(score: $score, reset: $reset, result: $result)
                .frame(width: boardSize, height: boardSize)
            Spacer()
            Button("Restart") {
                showReset = true
            }
            .alert(isPresented: $showReset) {
                Alert(
                    title: Text("Reset"),
                    message: Text("Are you sure?"),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Reset"),
                    action: {
                        Stats.updateStats(with: score, context: modelContext)
                        highScore = Stats.getHighScore(context: modelContext)
                        reset = true
                    }))
            }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: Stats.self, inMemory: true)
}
