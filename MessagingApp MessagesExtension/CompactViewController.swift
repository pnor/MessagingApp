//
//  CompactViewController.swift
//  MessagingApp MessagesExtension
//
//  Created by Phillip OReggio on 12/16/18.
//  Copyright © 2018 phillip. All rights reserved.
//

import UIKit
import Messages
import SnapKit

class CompactViewController: UIViewController {
    
    // MARK: - Parameters
    // The Conversation
    var conversation: MSConversation?
    
    // UI Elements
    var messageButton: UIButton!
    var openFullButton: UIButton!
   
    // Display Data
    let cornerRad: CGFloat = 10
    let padding = 40
    let smallPadding = 10
    let buttonSize = CGSize(width: 140, height: 60)
    let hueColor: CGFloat = 0.4
    
    // Delegates
    weak var presentationDelegate: PresentationStyleDelegate?
    
    init(with conversation: MSConversation?) {
        self.conversation = conversation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hue: hueColor, saturation: 0.4, brightness: 1, alpha: 1)
        
        let primaryButtonColor = UIColor(hue: hueColor, saturation: 1, brightness: 0.8, alpha: 1)
        
        messageButton = UIButton()
        messageButton.setTitle("Say Hello", for: .normal)
        messageButton.layer.cornerRadius = cornerRad
        messageButton.layer.masksToBounds = true
        messageButton.backgroundColor = .white
        messageButton.layer.borderColor = primaryButtonColor.cgColor
        messageButton.setTitleColor(primaryButtonColor, for: .normal)
        messageButton.addTarget(self, action: #selector(sendABasicMessage), for: .touchDown)
        view.addSubview(messageButton)
        
        openFullButton = UIButton()
        openFullButton.setTitle("Open Full", for: .normal)
        openFullButton.layer.cornerRadius = cornerRad
        openFullButton.layer.masksToBounds = true
        openFullButton.backgroundColor = .white
        openFullButton.layer.borderColor = primaryButtonColor.cgColor
        openFullButton.setTitleColor(primaryButtonColor, for: .normal)
        openFullButton.addTarget(self, action: #selector(goToFullView), for: .touchDown)
        view.addSubview(openFullButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        messageButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(padding)
            make.trailing.equalTo(view.snp.centerX).offset(-smallPadding)
        }
        
        openFullButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.leading.equalTo(view.snp.centerX).offset(smallPadding)
        }
    }
    
    @objc func sendABasicMessage() {
        if let activeConvo = conversation {
            activeConvo.insertText("This string was supplied by MessagingApp (with ❤️)") { (error) in
                if error != nil {
                    fatalError("ERROR: \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
    @objc func goToFullView() {
        presentationDelegate?.requestStyle(style: .expanded)
    }
}
