//
//  HomeVCInfoFour.swift
//  Ambulance
//
//  Created by Ramy on 12/8/18.
//  Copyright © 2018 Ramy. All rights reserved.
//

import UIKit

class HomeVCInfoFour: NSObject {
    let ViewFour = UIView()
     var homeController: HomeVC?
    
    override init() {
        super.init()
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeUp.direction = .up
        self.ViewFour.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.ViewFour.addGestureRecognizer(swipeDown)
        CallButton.addTarget(self, action: #selector(CallButtonTapped), for: .touchUpInside)
        FinishedButton.addTarget(self, action: #selector(FinishedButtonTapped), for: .touchUpInside)

    }
    
    func show(){
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(ViewFour)
            
            ViewFour.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 250)
            ViewFour.backgroundColor = UIColor.white
            ViewFour.layer.cornerRadius = 10
            ViewFour.alpha = 0
            
            
            setupConstrains()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.ViewFour.alpha = 1
                self.ViewFour.anchor(top: window.bottomAnchor, leading: window.leadingAnchor, bottom: nil, trailing: window.trailingAnchor, padding: .init(top: -70, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 250))
            })
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5) {
            self.ViewFour.alpha = 0
        }
    }
    func hideAndResetToDefualt(){
         self.ViewFour.alpha = 0
    }
    
    
    @objc func CallButtonTapped(){
        homeController?.callAcceptedDriver()
    }
    @objc func FinishedButtonTapped(){
      homeController?.finishRequest()
    }
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            let window = UIApplication.shared.keyWindow!
            UIView.animate(withDuration: 0.3, animations: {
                let y = window.frame.height-250-self.ViewFour.safeAreaInsets.bottom
                let x = window.frame.width-self.ViewFour.frame.width
                self.ViewFour.frame = CGRect(x: x, y: y, width: window.frame.width, height: 320)
            })
            
        }
         else if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            let window = UIApplication.shared.keyWindow!
            UIView.animate(withDuration: 0.3, animations: {
                let y = window.frame.height-self.ViewFour.safeAreaInsets.bottom-70
                let x = window.frame.width-self.ViewFour.frame.width
                self.ViewFour.frame = CGRect(x: x, y: y, width: window.frame.width, height: 320)
            })
            
        }
    }
    func setupConstrains(){
        [TitleLabel,IconImage,stackView5,lineView1].forEach { ViewFour.addSubview($0) }
        stackView5.addArrangedSubview(FinishedButton)
        stackView5.addArrangedSubview(CallButton)
        
        lineView1.anchor(top: ViewFour.topAnchor, leading: ViewFour.leadingAnchor, bottom: nil, trailing: ViewFour.trailingAnchor, padding: .init(top: 8, left: 15, bottom: 0, right: 15),size: CGSize(width: 0, height: 5))
        
        
        IconImage.anchor(top: lineView1.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 40, left: 0, bottom: 0, right: 0),size: CGSize(width: 40, height: 40))
        IconImage.centerXAnchor.constraint(equalTo: self.ViewFour.centerXAnchor).isActive = true
        
        
        TitleLabel.anchor(top: IconImage.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        TitleLabel.centerXAnchor.constraint(equalTo: self.ViewFour.centerXAnchor).isActive = true
        
        
        stackView5.anchor(top: TitleLabel.bottomAnchor, leading: ViewFour.leadingAnchor, bottom: ViewFour.safeAreaLayoutGuide.bottomAnchor, trailing: ViewFour.trailingAnchor, padding: .init(top: 30, left: 30, bottom: 20, right: 30),size: CGSize(width: 0, height: 45))
        stackView5.centerXAnchor.constraint(equalTo: self.ViewFour.centerXAnchor).isActive = true
        
        FinishedButton.anchor(top: stackView5.topAnchor, leading: nil, bottom: stackView5.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        CallButton.anchor(top: stackView5.topAnchor, leading: nil, bottom: stackView5.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
    }
    
    let TitleLabel : UILabel = {
        var label = UILabel()
        label.text = "Ambulance On the Way!"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    let IconImage : UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "ambulance")
        image.frame.size = CGSize(width: 25, height: 25)
        image.layer.cornerRadius = 1
        image.backgroundColor = UIColor.clear
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    let CallButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Call Paramedic", for: .normal)
        button.contentHorizontalAlignment = .center
        button.frame.size = CGSize(width: 150, height: 25)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    let FinishedButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Finish Request", for: .normal)
        button.contentHorizontalAlignment = .center
        button.frame.size = CGSize(width: 150, height: 25)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitleColor(UIColor.red, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    let lineView1: UIView = {
        let line = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 5))
        line.backgroundColor = UIColor.gray
        line.layer.cornerRadius = 10
        return line
    }()
    let stackView5: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.horizontal
        sv.distribution  = UIStackView.Distribution.fillEqually
        sv.alignment = UIStackView.Alignment.center
        sv.spacing  = 20
        return sv
    }()
}
