//
//  EndSessionViewController.swift
//  MessagingApp MessagesExtension
//
//  Created by Phillip OReggio on 1/3/19.
//  Copyright © 2019 phillip. All rights reserved.
//

import UIKit
import SnapKit

class EndSessionViewController: UIViewController {
    
    // MARK: - Parameters
    let streak: Streak
    
    var parentView: UIView!
    var mainImage: UIImageView!
    var maxStreakLabel: UILabel!
    var maxStreakNumber: UILabel!
    
    let padding: CGFloat = 20
    let imageSize = CGSize(width: 200, height: 200)

    // Mark: - Initializers
    init(streak: Streak) {
        self.streak = streak
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Implemented")
    }
    
    // MARK: - Set Up
    override func viewDidLoad() {
        super.viewDidLoad()

        parentView = UIView()
        parentView.backgroundColor = .clear
        view.addSubview(parentView)
        
        mainImage = UIImageView(image: UIImage(named: "wiiFitTrainer"))
        mainImage.contentMode = .scaleAspectFit
        parentView.addSubview(mainImage)
        
        maxStreakLabel = UILabel()
        maxStreakLabel.font = UIFont.systemFont(ofSize: 16)
        parentView.addSubview(maxStreakLabel)
        
        maxStreakNumber = UILabel()
        maxStreakNumber.font = UIFont.systemFont(ofSize: 32)
        maxStreakNumber.textColor = UIColor(
            hue: 0.02 * CGFloat((0...50).clamp(streak.count)),
            saturation: 1,
            brightness: 1,
            alpha: 1)
        parentView.addSubview(maxStreakNumber)
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        parentView.snp.makeConstraints { (make) in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        mainImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(padding)
            make.centerX.equalToSuperview()
            make.size.equalTo(imageSize)
        }
        
        maxStreakLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainImage.snp.bottom).offset(padding)
            make.centerX.equalToSuperview()
        }
        
        maxStreakNumber.snp.makeConstraints { (make) in
            make.top.equalTo(maxStreakLabel).offset(padding)
            make.centerX.equalToSuperview()
        }
    }
}
