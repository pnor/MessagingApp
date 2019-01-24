//
//  SessionScene.swift
//  MessagingApp MessagesExtension
//
// Where the Session game and much of the logic occurs. Sending the Session is handled through delegation. Uses SpriteKit for most of the UI.
//
//  Created by Phillip OReggio on 12/28/18.
//  Copyright © 2018 phillip. All rights reserved.
//

import UIKit
import SpriteKit

class SessionScene: SKScene {
    
    // MARK: - Parameters
    // Game Elements
    private var updating: [Updatable] = []
    var goalNode: SKShapeNode!
    var failLabel: SKLabelNode!
    var tapsAvailableLabel: SKLabelNode!
    var tapRecognizer: UITapGestureRecognizer!
    
    // Display Info
    var sceneSize: CGSize!
    var dotSize: CGFloat = 20.0
    var goalSize: CGFloat = 60.0
    var backColor: UIColor!
    var dotColor: UIColor!
    var goalColor: UIColor!
    
    // Streak Difficulty Scaling
    var streakCount: Int { get { return streakDelegate?.streak.count ?? 0}}
    var randomDotDirection: MovementDirection { get {
        return streakCount < 10 ?
            MovementDirection(rawValue: (0...3).randomElement()! * 2)! :
            MovementDirection(rawValue: (0...7).randomElement()!)!
        }
    }
    var dotTimeToTravel: Double { get { return Double((0.6...2.4).clamp(2.4 - Double(streakCount) * 0.04)) }}
    var dotInterval: Double { get { return Double((0.05...1.5).clamp(1.5 - Double(streakCount) * 0.03)) }}
    var timeForScene: Double { get { return (dotInterval + dotTimeToTravel) * Double(streakCount + 1) }}
    
    // Game Information
    /// Current Time Spent on Scene
    var lastUpdateTimeInterval: TimeInterval = 0 /// To compute delta time
    var totalTime: Double = 0.0
    var curTimeBetweenMovingDots: Double = 0.0
    var failCount = 0
    let failsForGameOver = 3
    var tapCount = 0
    var tapsAvailableForStreak: Int = 3
    var gameDone = false
    
    // Delegation
    weak var messagingDelegate: MessagingDelegate?
    weak var streakDelegate: StreakDelegate?

    // MARK: - Override methods
    override func didMove(to view: SKView) {
        super.sceneDidLoad()
        
        let backAndDotHue = Double((50 + (streakCount * 2)) % 100) / 100.0
        let goalHue =       Double((90 + (streakCount * 2)) % 100) / 100.0
        
        backColor = UIColor(hue: CGFloat(backAndDotHue), saturation: 0.1, brightness: 1, alpha: 1)
        dotColor = UIColor(hue: CGFloat(backAndDotHue), saturation: 1, brightness: 1, alpha: 1)
        goalColor = UIColor(hue: CGFloat(goalHue), saturation: 1, brightness: 1, alpha: 1)
        
        self.size = view.frame.size
        sceneSize = self.size
        self.backgroundColor = backColor

        goalNode = SKShapeNode(circleOfRadius: goalSize / 2)
        goalNode.fillColor = goalColor
        goalNode.strokeColor = goalColor
        goalNode.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)
        addChild(goalNode)
        
        failLabel = SKLabelNode()
        failLabel.horizontalAlignmentMode = .left
        failLabel.text = "Lives: \(failsForGameOver - failCount)"
        failLabel.fontSize = 14
        failLabel.fontColor = .black
        failLabel.position = CGPoint(x: sceneSize.width * 0.025, y: sceneSize.height * 0.8875)
        failLabel.zPosition = 1
        addChild(failLabel)
        
        tapsAvailableLabel = SKLabelNode()
        tapsAvailableLabel.horizontalAlignmentMode = .left
        tapsAvailableLabel.text = "Taps: \(tapsAvailableForStreak - tapCount)"
        tapsAvailableLabel.fontSize = 14
        tapsAvailableLabel.fontColor = .black
        tapsAvailableLabel.position = CGPoint(x: sceneSize.width * 0.025, y: sceneSize.height * 0.855)
        tapsAvailableLabel.zPosition = 1
        addChild(tapsAvailableLabel)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(sceneTapped))
        view.addGestureRecognizer(tapRecognizer)
        
        // Set up so a dot spawns shortly after scene begins
        curTimeBetweenMovingDots = dotInterval / 1.5
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        let delta = currentTime - lastUpdateTimeInterval // Time between last update() was called
        lastUpdateTimeInterval = currentTime
        updateWithDeltaTime(delta: delta > 1.0 ? 0.01666666 : delta)
    }
    
    func updateWithDeltaTime(delta: TimeInterval) {
        // Update all nodes in updating
        updating.forEach { $0.update(currentTime: delta) }
        
        // Update game status based on time spent on screen
        totalTime += delta
        if totalTime >= timeForScene { // User survived long enough; won this session
            endGame(didWin: true)
        }
        
        // Spawn a moving dot if its time
        curTimeBetweenMovingDots += delta
        if curTimeBetweenMovingDots >= dotInterval {
            curTimeBetweenMovingDots = 0
            makeDot(from: randomDotDirection)
        }
    }
    
    // MARK: - Managing Updating Nodes / Moving Dots
    /// Adds a new Updatable Node to the end of the array
    func addUpdating(_ node: Updatable) {
        updating.append(node)
    }
    
    /// Removes a SKShapeNode from the array of updating nodes. SKShapeNode must conform to Updatable
    func removeMovingDot(_ node: SKShapeNode) {
        guard let _ = node as? Updatable else { fatalError("SKShapeNode must conform to Updatable") }
        // Get index of node
        for i in 0...updating.count {
            if updating[i] as? SKShapeNode === node {
                updating.remove(at: i)
                break
            }
        }
    }
    
    func clearUpdating() {
        updating = []
    }
    
    // MARK: - Session Game Logic
    /// Ends the game and puts the message in the text input
    func endGame(didWin: Bool) {
        gameDone = true
        if didWin {
            streakDelegate?.streak = Streak(count: streakCount + 1, gameDidEnd: false)
            messagingDelegate?.sendMessageSession()
        } else {
            streakDelegate?.streak = Streak(count: streakCount, gameDidEnd: true)
            messagingDelegate?.sendMessageSession()
        }
    }
    
    /// Remove any nodes that are in the goal area
    @objc func sceneTapped() {
        updating.forEach { (updatable) in
            if let node = updatable as? SKShapeNode {
                if checkIntersection(between: goalNode, and: node) {
                    node.removeFromParent()
                    self.removeMovingDot(node)
                    pulseAnimation()
                } else { // Missed tap
                    tapCount += 1
                    tapsAvailableLabel.text = "Taps: \(tapsAvailableForStreak - tapCount)"
                    if tapCount >= tapsAvailableForStreak {
                        endGame(didWin: false)
                    }
                }
            }
        }
    }
    
    /// Checks whether 2 nodes intersect eachother
    func checkIntersection(between node1: SKNode, and node2: SKNode) -> Bool {
        return node1.intersects(node2)
    }
    
    // MARK: - Effects and Animations
    /// Creates the dot that moves across the screen
    func makeDot(from direction: MovementDirection) {
        let movingDot = SessionGameNode(circleOfRadius: dotSize / 2)
        movingDot.fillColor = dotColor
        movingDot.strokeColor = dotColor
        var distance: CGFloat = 0.0
        // Position
        switch direction {
        case .right:
            movingDot.position = CGPoint(x: 0, y: sceneSize.height / 2.0)
            distance = sceneSize.width + dotSize
        case .up:
            movingDot.position = CGPoint(x: sceneSize.width / 2.0, y: 0)
            distance = sceneSize.height + dotSize
        case .left:
            movingDot.position = CGPoint(x: sceneSize.width, y: sceneSize.height / 2.0)
            distance = sceneSize.width + dotSize
        case .down:
            movingDot.position = CGPoint(x: sceneSize.width / 2.0, y: sceneSize.height)
            distance = sceneSize.height + dotSize
            
        case .diagRightUp:
            movingDot.position = CGPoint(x: 0, y: sceneSize.height / 5)
            distance = sceneSize.diagonal + dotSize
        case .diagrightDown:
            movingDot.position = CGPoint(x: 0, y: sceneSize.height * (4 / 5))
            distance = sceneSize.diagonal + dotSize
        case .diagLeftUp:
            movingDot.position = CGPoint(x: sceneSize.width, y: sceneSize.height / 5)
            distance = sceneSize.diagonal + dotSize
        case .diagLeftDown:
            movingDot.position = CGPoint(x: sceneSize.width, y: sceneSize.height * (4 / 5))
            distance = sceneSize.diagonal + dotSize
        }
        // Motion
        movingDot.run(.move(by: direction.unitVector * Double(distance), duration: dotTimeToTravel))
        
        // Add to updating list and delegation
        movingDot.sessionGameDelegate = self
        addUpdating(movingDot)
        addChild(movingDot)
    }
    
    /// Creates the pulse that spawns when a succesful tap is made. (Moving dot lands in the goal)
    func pulseAnimation() {
        let shapeNode = SKShapeNode(circleOfRadius: goalSize / 2)
        shapeNode.strokeColor = goalColor
        addChild(shapeNode)
        // Location
        shapeNode.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)
        // Animation
        let removeAction = SKAction.customAction(withDuration: 0.01) { (node, time) in
            node.removeFromParent()
        }
        shapeNode.run(.sequence([
            .scale(by: 30, duration: 0.8),
            removeAction
        ]))
    }
}

/// Classes that conform to Updatable are updating with the time between frames during the render loop
protocol Updatable {
    func update(currentTime: TimeInterval)
}
