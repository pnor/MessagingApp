//
//  Streak.swift
//  MessagingApp MessagesExtension
//
//  Created by Phillip OReggio on 12/24/18.
//  Copyright © 2018 phillip. All rights reserved.
//

import Foundation

struct Streak: CustomStringConvertible {
    var count: Int = 0
    var gameEnd = false
    
    var description: String { get {
        return "Count: \(count)| Game End: \(gameEnd)"
        }
    }
    
    init(count: Int = 0, gameDidEnd: Bool = false) {
        self.count = count
        gameEnd = gameDidEnd
    }
}

//MARK: - URL
extension Streak {
    func streakURL() -> URL {
        var components = URLComponents()
        let countURL = URLQueryItem(name: "count", value: "\(self.count)")
        let winURL = URLQueryItem(name: "win", value: self.gameEnd.description)
        components.queryItems = [countURL, winURL]
        return components.url!
    }
}
