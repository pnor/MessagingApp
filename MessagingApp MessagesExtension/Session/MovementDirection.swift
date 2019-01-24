//
//  MovementDirection.swift
//  MessagingApp MessagesExtension
//
// Contains unit vectors for movement from various directions. 
//
//  Created by Phillip OReggio on 12/28/18.
//  Copyright © 2018 phillip. All rights reserved.
//

import UIKit

enum MovementDirection: Int {
    case right = 0
    case diagRightUp = 1
    case up = 2
    case diagLeftUp = 3
    case left = 4
    case diagLeftDown = 5
    case down = 6
    case diagrightDown = 7
    
    var unitVector: CGVector { get {
        switch self {
        case .right:
            return CGVector(dx: 1, dy: 0)
        case .diagRightUp:
            return CGVector(dx: sqrt(2) / 2, dy: sqrt(2) / 2)
        case .up:
            return CGVector(dx: 0, dy: 1)
        case .diagLeftUp:
            return CGVector(dx: -sqrt(2) / 2, dy: sqrt(2) / 2)
        case .left:
            return CGVector(dx: -1, dy: 0)
        case .diagLeftDown:
            return CGVector(dx: -sqrt(2) / 2, dy: -sqrt(2) / 2)
        case .down:
            return CGVector(dx: 0, dy: -1)
        case .diagrightDown:
            return CGVector(dx: sqrt(2) / 2, dy: -sqrt(2) / 2)
        }
        }
    }
}
