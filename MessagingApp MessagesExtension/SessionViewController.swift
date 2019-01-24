//
//  SessionViewController.swift
//  MessagingApp MessagesExtension
//
// Where the SessionScene is displayed.
//
//  Created by Phillip OReggio on 12/24/18.
//  Copyright © 2018 phillip. All rights reserved.
//

import UIKit
import Messages
import SnapKit
import SpriteKit

class SessionViewController: UIViewController {
    
    // MARK: - Parameters
    // Conversation Information
    let conversation: MSConversation?
    var streak: Streak
    
    // UI Elements
    var scene: SessionScene!
    var sceneView: SKView!
    
    // Delegation
    weak var presentationStyleDelegate: PresentationStyleDelegate?
    weak var sessionDelegate: SessionDelegate?
    
    // MARK: - Init
    init(with conversation: MSConversation?, streak: Streak) {
        self.streak = streak
        self.conversation = conversation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Implemented")
    }
    
    // MARK: - Arranging and Creating UI Elements
    override func viewDidLoad() {
        super.viewDidLoad()
        scene = SessionScene()
        scene.streakDelegate = self
        
        sceneView = SKView()
        sceneView.frame.size = view.safeAreaLayoutGuide.layoutFrame.size
        sceneView.presentScene(scene)
        sceneView.scene?.scaleMode = .aspectFill
        view.addSubview(sceneView)
        
        // Delegates for scene
        scene.messagingDelegate = self
        scene.streakDelegate = self
        
        // Debug
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        sceneView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Delegation
/// Conforming to this means its a protocol that uses parameters from the SessionViewController
protocol StreakDelegate: class {
    var streak: Streak { get set }
}

/// Allows SessionScene to access this to send the session message
protocol MessagingDelegate: class {
    func sendMessageSession()
}

extension SessionViewController: StreakDelegate {}

extension SessionViewController: MessagingDelegate {
    func killScene() {
        sceneView.presentScene(nil)
    }
    
    func sendMessageSession() {
        killScene()
        let message = MSMessage(session: sessionDelegate!.getMainSession())
        let layout = MSMessageTemplateLayout()
        layout.caption = streak.gameEnd ? "I Missed" : "Let's have a Session"
        layout.subcaption = "Current Streak: \(streak.count)"
        layout.image = UIImage(named: "wiiFitTrainer")
        message.layout = layout
        message.url = streak.streakURL()
        print(streak)
        conversation?.insert(message, completionHandler: { (error) in
            self.presentationStyleDelegate?.requestStyle(style: .compact)
        })
    }
}
