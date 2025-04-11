//
//  MainView.swift
//  swift-2049
//
//  Created by Rajbir Singh Azra on 2025-03-24.
//

import SwiftUI
import UIKit

struct SwiftUINumberTileController: UIViewControllerRepresentable {
    @Binding var score: Int?
    @Binding var reset: Bool?
    
    func makeUIViewController(context: Context) -> NumberTileGameViewController {
        let game = NumberTileGameViewController(dimension: 4, threshold: 16)
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
        func reset() {
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
        
        var parent: SwiftUINumberTileController
        var originalDelegate: GameModelProtocol?
        
        init(_ parent: SwiftUINumberTileController) {
            self.parent = parent
        }
        
        func scoreChanged(to newScore: Int) {
            originalDelegate?.scoreChanged(to: newScore)
            DispatchQueue.main.async {
                self.parent.score = newScore
            }
        }
        
        // add func here for hooking into gameOver
    }
}

struct MainView: View {
    @State private var score: Int? = 0
    @State private var reset: Bool? = false
    
    var body: some View {
        VStack {
            Text("Score: \(score ?? 1)")
            SwiftUINumberTileController(score: $score, reset: $reset)
            Button("Restart") {reset = true}
        }
    }
}

#Preview {
    MainView()
}
