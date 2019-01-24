//
//  SessionGameNode.swift
//  MessagingApp MessagesExtension
//
// Class representing the moving dots in the Session. Will remove itself from the screen and increment the fail count if it leaves the screen
//
//  Created by Phillip OReggio on 12/28/18.
//  Copyright © 2018 phillip. All rights reserved.
//

import UIKit
import SpriteKit

class SessionGameNode: SKShapeNode, Updatable {
    
    weak var sessionGameDelegate: SessionGameDelegate?
    
    func update(currentTime: TimeInterval) {
        // Only run if node has parent
        guard let _ = self.scene else { return }
        
        // Check out of bounds
        let position = self.position
        let size = self.frame.size
        let sceneSize = self.scene!.frame.size
        let outOfBounds: Bool =
            position.x + size.width / 2 < 0                   || // Left
                position.x - size.width / 2 > sceneSize.width || // Right
                position.y + size.height / 2 < 0              || // Bottom
                position.y - size.height / 2 > sceneSize.height  // Top
        
        if outOfBounds {
            let parentScene = self.scene as? SessionScene
            sessionGameDelegate?.incrementFailCount()
            self.removeFromParent()
            parentScene?.removeMovingDot(self)
        }
    }
}

// MARK: - Delegation
/// So the dot can update the amount of missed dots in the SessionScene
protocol SessionGameDelegate: class {
    func incrementFailCount()
}

extension SessionScene: SessionGameDelegate {
    func incrementFailCount() {
        failCount += 1
        failLabel.text = "Lives: \(failsForGameOver - failCount)"
        // Check game over
        if failCount >= failsForGameOver && !gameDone {
            print("***Lost the session***")
            endGame(didWin: false)
        }
    }
}
