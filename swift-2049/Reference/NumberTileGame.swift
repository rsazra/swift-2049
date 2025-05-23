//
//  NumberTileGame.swift
//  swift-2048
//
//  Created by Austin Zheng on 6/3/14.
//  Copyright (c) 2014 Austin Zheng. Released under the terms of the MIT license.
//

import UIKit

/// A view controller representing the swift-2048 game. It serves mostly to tie a GameModel and a GameboardView
/// together. Data flow works as follows: user input reaches the view controller and is forwarded to the model. Move
/// orders calculated by the model are returned to the view controller and forwarded to the gameboard view, which
/// performs any animations to update its state.
class NumberTileGameViewController : UIViewController, GameModelProtocol {
    // How many tiles in both directions the gameboard contains
    var dimension: Int
    // The value of the winning tile
    var threshold: Int
    
    var board: GameboardView?
    var model: GameModel?
    
    var scoreView: ScoreViewProtocol?
    
    // Width of the gameboard
    let boardWidth: CGFloat = 325.0
    // Font size in tiles
    let fontSize: CGFloat = 30.0
    // How much padding to place between the tiles
    let thinPadding: CGFloat = 3.0
    let thickPadding: CGFloat = 6.0
    
    // Amount of space to place between the different component views (gameboard, score view, etc)
    let viewPadding: CGFloat = 10.0
    
    // Amount that the vertical alignment of the component views should differ from if they were centered
    let verticalViewOffset: CGFloat = 0.0
    
    init(dimension d: Int, threshold t: Int) {
        dimension = d > 2 ? d : 2
        threshold = t > 8 ? t : 8
        super.init(nibName: nil, bundle: nil)
        model = GameModel(dimension: dimension, threshold: threshold, delegate: self)
        view.backgroundColor = UIColor.clear
        setupSwipeControls()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func setupSwipeControls() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(NumberTileGameViewController.upCommand(_:)))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(NumberTileGameViewController.downCommand(_:)))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(NumberTileGameViewController.leftCommand(_:)))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(NumberTileGameViewController.rightCommand(_:)))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(rightSwipe)
    }
    
    
    // View Controller
    override func viewDidLoad()  {
        super.viewDidLoad()
        setupGame()
    }
    
    // copy this function for loading from a saved game state
    func reset() {
        assert(board != nil && model != nil)
        let b = board!
        let m = model!
        b.reset()
        m.reset()
        m.insertTileAtRandomLocation(withValue: 2)
        m.insertTileAtRandomLocation(withValue: 2)
//        loadGame(tiles: [0, 0, 0, 0, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096])
//        print(dumpGame())
    }
    
    func dumpGame() -> [Int] {
        assert(model != nil)
        let m = model!
        let boardArray = m.gameboard.boardArray
        var boardDump: [Int] = []
        
        for tile in boardArray {
            switch tile {
            case .empty:
                boardDump.append(0)
            case .tile(let v):
                boardDump.append(v)
            }
        }
        
        return boardDump
    }
    
    func loadGame(tiles: [Int]) {
        assert(board != nil && model != nil)
        let b = board!
        let m = model!
        b.reset()
        m.reset()
        var row = 0
        var col = 0
        for tile in tiles {
            if tile != 0 {
                m.insertTile(at: (row, col), value: tile)
            }
            col += 1
            if col == 4 {
                row += 1
                col = 0
            }
        }
    }
    
    func setupGame() {
        //        let vcHeight = view.bounds.size.height
        //        let vcWidth = view.bounds.size.width
        
        // This nested function provides the x-position for a component view
        func xPositionToCenterView(_ v: UIView) -> CGFloat {
            //            let viewWidth = v.bounds.size.width
            //            let tentativeX = 0.5*(vcWidth - viewWidth)
            //            return tentativeX >= 0 ? tentativeX : 0
            return 0
        }
        // This nested function provides the y-position for a component view
        func yPositionForViewAtPosition(_ order: Int, views: [UIView]) -> CGFloat {
            assert(views.count > 0)
            assert(order >= 0 && order < views.count)
            //      let viewHeight = views[order].bounds.size.height
            //            let totalHeight = CGFloat(views.count - 1)*viewPadding + views.map({ $0.bounds.size.height }).reduce(verticalViewOffset, { $0 + $1 })
            //            let viewsTop = 0.5*(vcHeight - totalHeight) >= 0 ? 0.5*(vcHeight - totalHeight) : 0
            
            // Not sure how to slice an array yet
            var acc: CGFloat = 0
            for i in 0..<order {
                acc += viewPadding + views[i].bounds.size.height
            }
            //            return viewsTop + acc
            return acc
        }
        
        // Create the score view
        //        let scoreView = ScoreView(backgroundColor: UIColor.black,
        //                                  textColor: UIColor.white,
        //                                  font: UIFont(name: "HelveticaNeue-Bold", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0),
        //                                  radius: 6)
        //        scoreView.score = 0
        
        // Create the gameboard
        let padding: CGFloat = dimension > 5 ? thinPadding : thickPadding
        let v1 = boardWidth - padding*(CGFloat(dimension + 1))
        let width: CGFloat = CGFloat(floorf(CFloat(v1)))/CGFloat(dimension)
        let gameboard = GameboardView(dimension: dimension,
                                      tileWidth: width,
                                      tilePadding: padding,
                                      cornerRadius: 6,
                                      fontSize: fontSize,
                                      backgroundColor: UIColor.black,
                                      foregroundColor: UIColor.darkGray)
        
        // Set up the frames
        //        let views = [scoreView, gameboard]
        //
        //        var f = scoreView.frame
        //        f.origin.x = xPositionToCenterView(scoreView)
        //        f.origin.y = yPositionForViewAtPosition(0, views: views)
        //        scoreView.frame = f
        
        var f = gameboard.frame
        f.origin.x = xPositionToCenterView(gameboard)
        f.origin.y = yPositionForViewAtPosition(0, views: [gameboard])
        gameboard.frame = f
        
        
        // Add to game state
        view.addSubview(gameboard)
        board = gameboard
        //        view.addSubview(scoreView)
        //        self.scoreView = scoreView
        
        assert(model != nil)
        let m = model!
        m.insertTileAtRandomLocation(withValue: 2)
        m.insertTileAtRandomLocation(withValue: 2)
    }
    
    // Misc
    func followUp() {
        assert(model != nil)
        let m = model!
        //        let (userWon, _) = m.userHasWon()
        //        if userWon {
        //            // alerting delegate is done in m.userHasWon
        //            return
        //        }
        
        // Now, insert more tiles
        let randomVal = Int(arc4random_uniform(10))
        m.insertTileAtRandomLocation(withValue: randomVal == 1 ? 4 : 2)
        
        // At this point, the user may lose
        if m.userHasLost() {
            // alerting delegate is done in m.userHasLost
            return
        }
    }
    
    // Commands
    @objc(up:)
    func upCommand(_ r: UIGestureRecognizer!) {
        assert(model != nil)
        let m = model!
        m.queueMove(direction: MoveDirection.up,
                    onCompletion: { (changed: Bool) -> () in
            if changed {
                self.followUp()
            }
        })
    }
    
    @objc(down:)
    func downCommand(_ r: UIGestureRecognizer!) {
        assert(model != nil)
        let m = model!
        m.queueMove(direction: MoveDirection.down,
                    onCompletion: { (changed: Bool) -> () in
            if changed {
                self.followUp()
            }
        })
    }
    
    @objc(left:)
    func leftCommand(_ r: UIGestureRecognizer!) {
        assert(model != nil)
        let m = model!
        m.queueMove(direction: MoveDirection.left,
                    onCompletion: { (changed: Bool) -> () in
            if changed {
                self.followUp()
            }
        })
    }
    
    @objc(right:)
    func rightCommand(_ r: UIGestureRecognizer!) {
        assert(model != nil)
        let m = model!
        m.queueMove(direction: MoveDirection.right,
                    onCompletion: { (changed: Bool) -> () in
            if changed {
                self.followUp()
            }
        })
    }
    
    // Protocol
    func gameOver(won: Bool) {
        return
    }
    
    func scoreChanged(to score: Int) {
        if scoreView == nil {
            return
        }
        let s = scoreView!
        s.scoreChanged(to: score)
    }
    
    func moveOneTile(from: (Int, Int), to: (Int, Int), value: Int) {
        assert(board != nil)
        let b = board!
        b.moveOneTile(from: from, to: to, value: value)
    }
    
    func moveTwoTiles(from: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int) {
        assert(board != nil)
        let b = board!
        b.moveTwoTiles(from: from, to: to, value: value)
    }
    
    func insertTile(at location: (Int, Int), withValue value: Int) {
        assert(board != nil)
        let b = board!
        b.insertTile(at: location, value: value)
    }
}
