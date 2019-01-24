//
//  Extensions.swift
//  MessagingApp MessagesExtension
//
//  Created by Phillip OReggio on 1/3/19.
//  Copyright © 2019 phillip. All rights reserved.
//

import UIKit

extension ClosedRange {
    func clamp(_ value : Bound) -> Bound {
        return self.lowerBound > value ? self.lowerBound
            : self.upperBound < value ? self.upperBound
            : value
    }
}

extension CGVector {
    static func +(lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }
    
    static func -(lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
    
    static func *(lhs: CGVector, rhs: Double) -> CGVector {
        return CGVector(dx: Double(lhs.dx) * rhs, dy: Double(lhs.dy) * rhs)
    }
}

extension CGSize {
    /// Length of the hypotenuse of a right traingle formed by the width and height of the CGSize object
    var diagonal: CGFloat { get { return sqrt(pow(width, 2) + pow(height, 2)) }}
}
