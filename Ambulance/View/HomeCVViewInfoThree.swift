//
//  HomeCVViewInfoThree.swift
//  Ambulance
//
//  Created by Ramy on 12/8/18.
//  Copyright © 2018 Ramy. All rights reserved.
//

import UIKit

class HomeCVViewInfoThree: NSObject {
    let ViewThree = UIView()
    var requestOwner: Bool = false
    
    override init() {
        super.init()
        
         ButtonInfoThree1.addTarget(self, action: #selector(ButtonInfoThreeTapped), for: .touchUpInside)
         ButtonInfoThree2.addTarget(self, action: #selector(ButtonInfoThreeTapped), for: .touchUpInside)
    }
    
    
    func show(){
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(ViewThree)
            
            ViewThree.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 200)
            ViewThree.backgroundColor = UIColor.white
            ViewThree.layer.cornerRadius = 10
            ViewThree.alpha = 0
            
          
            setupConstrains()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.ViewThree.alpha = 1
                self.ViewThree.anchor(top: nil, leading: window.leadingAnchor, bottom: window.safeAreaLayoutGuide.bottomAnchor, trailing: window.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 85, right: 20),size: CGSize(width: 0, height: 150))
            })
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5) {
            self.ViewThree.alpha = 0
        }
    }
    
    @objc func  ButtonInfoThreeTapped(sender: UIButton!){
        switch sender {
        case ButtonInfoThree1:
            ButtonInfoThree1.backgroundColor = UIColor.red
            ButtonInfoThree1.setTitleColor(UIColor.white, for: .normal)
            ButtonInfoThree2.backgroundColor = UIColor.white
            ButtonInfoThree2.setTitleColor(UIColor.gray, for: .normal)
            requestOwner = true
            break
        case ButtonInfoThree2:
            ButtonInfoThree2.backgroundColor = UIColor.red
            ButtonInfoThree2.setTitleColor(UIColor.white, for: .normal)
            ButtonInfoThree1.backgroundColor = UIColor.white
            ButtonInfoThree1.setTitleColor(UIColor.gray, for: .normal)
            requestOwner = false
            break
        default:
            break
        }
        print(requestOwner)
    }
    
    private func setupConstrains(){
        [ButtonInfoThree1,ButtonInfoThree2,InfoThreeTitle].forEach { ViewThree.addSubview($0) }
        
        InfoThreeTitle.anchor(top: ViewThree.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        InfoThreeTitle.centerXAnchor.constraint(equalTo: self.ViewThree.centerXAnchor).isActive = true
        
        ButtonInfoThree1.anchor(top: InfoThreeTitle.bottomAnchor, leading: nil, bottom: nil, trailing: ViewThree.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 70),size: CGSize(width: 60, height: 60))
        
        ButtonInfoThree2.anchor(top: InfoThreeTitle.bottomAnchor, leading: ViewThree.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 70, bottom: 0, right: 0),size: CGSize(width: 60, height: 60))
        
    }
    
    let ButtonInfoThree1: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Yes", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = button.frame.width
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.gray, for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    let ButtonInfoThree2: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("No", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = button.frame.width
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    let InfoThreeTitle : UILabel = {
        var label = UILabel()
        label.text = "Emergency For You ?"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()
    
    
    
    
    
}
