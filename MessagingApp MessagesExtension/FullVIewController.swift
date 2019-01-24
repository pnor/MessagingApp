//
//  FullViewController.swift
//  MessagingApp MessagesExtension
//
//  Created by Phillip OReggio on 12/20/18.
//  Copyright © 2018 phillip. All rights reserved.
//

import UIKit
import SnapKit
import Messages
import Photos

class FullViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Parameters
    // The Conversation
    let conversation: MSConversation?
    
    // UI Elements
    var basicMessage: UIButton!
    var appMessage: UIButton!
    var sendARawImage: UIButton!
    var sendAnImage: UIButton!
    var sendASticker: UIButton!
    var startSession: UIButton!
    var backButton: UIButton!
    
    // Display Data
    let hueColor: CGFloat = 0.6
    let cornerRad: CGFloat = 10
    let padding = 20
    let vertPadding = 30
    var buttonHeight: CGFloat!
    let numButtonsDisplayed = 6//7
    
    // Image Controls
    var imagePicker: UIImagePickerController!
    var imageAlert: UIAlertController!
    var messageType: MessageType!
    
    // Delegates
    weak var presentationDelegate: PresentationStyleDelegate?
    weak var sessionDelegate: SessionDelegate?
    
    // MARK: - Initializers
    init(with conversation: MSConversation?) {
        self.conversation = conversation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.conversation = nil
        super.init(coder: aDecoder)
        fatalError("not implemented")
    }
    
    // MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hue: hueColor, saturation: 0.4, brightness: 1, alpha: 1)
        let primaryButtonColor = UIColor(hue: hueColor, saturation: 1, brightness: 0.8, alpha: 1)
        let viewHeight = view.bounds.height
        buttonHeight = (viewHeight - CGFloat((numButtonsDisplayed + 2) * vertPadding)) / CGFloat(numButtonsDisplayed + 1)
        
        basicMessage = UIButton()
        basicMessage.setTitle("Send A Basic Message", for: .normal)
        basicMessage.setTitleColor(primaryButtonColor, for: .normal)
        basicMessage.backgroundColor = .white
        basicMessage.layer.cornerRadius = cornerRad
        basicMessage.addTarget(self, action: #selector(messageButtonPressed), for: .touchDown)
        view.addSubview(basicMessage)
        
        appMessage = UIButton()
        appMessage.setTitle("Send A MSMessage using the Template", for: .normal)
        appMessage.setTitleColor(primaryButtonColor, for: .normal)
        appMessage.backgroundColor = .white
        appMessage.layer.cornerRadius = cornerRad
        appMessage.addTarget(self, action: #selector(appBasedMessageButtonPressed), for: .touchDown)
        view.addSubview(appMessage)
        
        sendAnImage = UIButton()
        sendAnImage.setTitle("Send An Image", for: .normal)
        sendAnImage.setTitleColor(primaryButtonColor, for: .normal)
        sendAnImage.backgroundColor = .white
        sendAnImage.layer.cornerRadius = cornerRad
        sendAnImage.addTarget(self, action: #selector(imageButtonPressed(sender:)), for: .touchDown)
        view.addSubview(sendAnImage)
        
        sendARawImage = UIButton()
        sendARawImage.setTitle("Send A Raw Image", for: .normal)
        sendARawImage.setTitleColor(primaryButtonColor, for: .normal)
        sendARawImage.backgroundColor = .white
        sendARawImage.layer.cornerRadius = cornerRad
        sendARawImage.addTarget(self, action: #selector(imageButtonPressed(sender:)), for: .touchDown)
        view.addSubview(sendARawImage)
        
        /*
        sendASticker = UIButton()
        sendASticker.setTitle("Send A Sticker", for: .normal)
        sendASticker.setTitleColor(primaryButtonColor, for: .normal)
        sendASticker.backgroundColor = .white
        sendASticker.layer.cornerRadius = cornerRad
        sendASticker.addTarget(self, action: #selector(imageButtonPressed(sender:)), for: .touchDown)
        view.addSubview(sendASticker)
        */
        
        startSession = UIButton()
        startSession.setTitle("Start A Session", for: .normal)
        startSession.setTitleColor(primaryButtonColor, for: .normal)
        startSession.backgroundColor = .white
        startSession.layer.cornerRadius = cornerRad
        startSession.addTarget(self, action: #selector(sesionButtonPressed), for: .touchDown)
        view.addSubview(startSession)
        
        backButton = UIButton()
        backButton.setTitle("Go Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = primaryButtonColor
        backButton.layer.cornerRadius = cornerRad
        backButton.addTarget(self, action: #selector(goBack), for: .touchDown)
        view.addSubview(backButton)
        
        // Image Related
        imageAlert = UIAlertController(title: "Choose Option", message: "Would you like to take an image using the camera or the Photo Library?", preferredStyle: .alert)
        imageAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.imagePicker.sourceType = .camera
            // check if has access and if it does proceed with the operation
            switch(PHPhotoLibrary.authorizationStatus()) {
            case .authorized:
                self.presentChoice()
            case .restricted:
                return
            case .denied:
                fallthrough
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == .authorized {
                        self.presentChoice()
                    } else {
                        return
                    }
                })
            }
        }))
        imageAlert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.imagePicker.sourceType = .photoLibrary
            // check if has access and if it does proceed with the operation
            switch(PHPhotoLibrary.authorizationStatus()) {
            case .authorized:
                self.presentChoice()
            case .restricted:
                return
            case .denied:
                fallthrough
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == .authorized {
                        self.presentChoice()
                    } else {
                        return
                    }
                })
            }
        }))

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        setupConstraints()
    }
    
    func setupConstraints() {
        basicMessage.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.height.equalTo(buttonHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(vertPadding)
        }
        
        appMessage.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.height.equalTo(buttonHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(basicMessage.snp.bottom).offset(vertPadding)
        }
        
        sendAnImage.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.height.equalTo(buttonHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(appMessage.snp.bottom).offset(vertPadding)
        }
        
        sendARawImage.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.height.equalTo(buttonHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(sendAnImage.snp.bottom).offset(vertPadding)
        }
        
        /*
        sendASticker.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.height.equalTo(buttonHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(sendARawImage.snp.bottom).offset(vertPadding)
        }
         */
        
        startSession.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.height.equalTo(buttonHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(sendARawImage.snp.bottom).offset(vertPadding)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.height.equalTo(buttonHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(startSession.snp.bottom).offset(vertPadding)
        }
    }
    
    // MARK: - Button Methods
    @objc func messageButtonPressed() {
        conversation?.sendText("This string was sent automatically")
    }
    
    @objc func appBasedMessageButtonPressed() {
        sendMSMessageText(string: "This is a MSMessage!")
    }
    
    @objc func imageButtonPressed(sender: UIButton) {
        if sender == sendAnImage {
            messageType = .image
        } else if sender == sendARawImage {
            messageType = .rawImage
        } else if sender == sendASticker {
            messageType = .sticker
        }
        choosePhotoMode()
    }
    
    @objc func sesionButtonPressed() {
        sendSession()
    }
    
    @objc func goBack() {
        presentationDelegate?.requestStyle(style: .compact)
    }
    
    // MARK: - Image Picking Methods
    @objc func choosePhotoMode() {
        present(imageAlert, animated: true, completion: nil)
    }

    @objc func presentChoice() {
        switch(imagePicker.sourceType) {
        case UIImagePickerController.SourceType.camera:
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                present(imagePicker, animated: true, completion: nil)
            }
        case UIImagePickerController.SourceType.photoLibrary:
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                present(imagePicker, animated: true, completion: nil)
            }
        default:
            print("This only works with Camera and Photo Library")
        }
    }

    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicked = info[UIImagePickerController.InfoKey.editedImage]
        let imageURL = info[UIImagePickerController.InfoKey.imageURL]
        switch messageType! {
        case .image:
            sendImage(image: imagePicked as! UIImage)
        case .rawImage:
            sendRawImage(url: imageURL as! URL)
        case .sticker:
            sendSticker(url: imageURL as! URL)
        default:
            print("!!! Some case was unhandled")
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Sending Methods
    
    func sendText(string: String) {
        conversation?.sendText(string, completionHandler: { (error) in
            if error != nil {
                print("!!! Error: \(String(describing: error?.localizedDescription))")
            } else {
                self.presentationDelegate?.requestStyle(style: .compact)
            }
        })
    }
    
    func sendMSMessageText(string: String) {
        let message = MSMessage()
        let template = MSMessageTemplateLayout()
        template.caption = string
        template.subcaption = "MessagingApp says..."
        template.trailingCaption = "🐾"
        message.layout = template
        conversation?.send(message, completionHandler: { (error) in
            self.presentationDelegate?.requestStyle(style: .compact)
            if error != nil {
                print("Error: \(String(describing: error?.localizedDescription))")
            } else {
                self.presentationDelegate?.requestStyle(style: .compact)
            }
        })
    }
    
    func sendRawImage(url: URL) {
        conversation?.sendAttachment(url, withAlternateFilename: "Image Chosen?", completionHandler: { (error) in
            self.presentationDelegate?.requestStyle(style: .compact)
            if error != nil {
                print("Error: \(String(describing: error?.localizedDescription))")
            } else {
                self.presentationDelegate?.requestStyle(style: .compact)
            }
        })
    }
    
    func sendSticker(url: URL) {
        var sticker: MSSticker
        do {
            sticker = try MSSticker(contentsOfFileURL: url, localizedDescription: "A Sticker")
        } catch  {
            print("But the Sticker Creation Failed!")
            return
        }
        conversation?.send(sticker, completionHandler: { (error) in
            self.presentationDelegate?.requestStyle(style: .compact)
            if error != nil {
                print("Error: \(String(describing: error?.localizedDescription))")
            } else {
                self.presentationDelegate?.requestStyle(style: .compact)
            }
        })
    }
    
    func sendImage(image: UIImage) {
        let message = MSMessage()
        let template = MSMessageTemplateLayout()
        let userName = conversation?.localParticipantIdentifier
        template.image = image
        template.caption = "Your Picture: "
        template.imageSubtitle = "(with ❤️)"
        template.imageTitle = "$\(userName!.uuidString))"
        template.trailingCaption = "From MessagingApp"
        message.layout = template
        
        conversation?.send(message) { (error) in
            self.presentationDelegate?.requestStyle(style: .compact)
            if error != nil {
                print("Error: \(String(describing: error?.localizedDescription))")
            } else {
                self.presentationDelegate?.requestStyle(style: .compact)
            }
        }
    }
    
    func sendSession() {
        let message = MSMessage(session: sessionDelegate!.getMainSession())
        let layout = MSMessageTemplateLayout()
        
        layout.caption = "Lets do a session!"
        layout.image = UIImage(named: "wiiFitTrainer")
        message.layout = layout
        message.url = Streak().streakURL()
        
        conversation?.send(message) { (error) in
            self.presentationDelegate?.requestStyle(style: .compact)
            if error != nil {
                print("Error: \(String(describing: error?.localizedDescription))")
            } else {
                self.presentationDelegate?.requestStyle(style: .compact)
            }
        }
    }
}

enum MessageType {
    case image
    case rawImage
    case sticker
    case session
}
