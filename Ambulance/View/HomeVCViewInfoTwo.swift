//
//  ViewInfoTwo.swift
//  Ambulance
//
//  Created by Ramy on 12/7/18.
//  Copyright © 2018 Ramy. All rights reserved.
//

import UIKit

class HomeVCViewInfoTwo: NSObject {
     let ViewTwo = UIView()
     var selectedEmergencyType: String = "Accident"
      var buttons: [UIButton]?
    var width: CGFloat?
     var height: CGFloat?
    override init() {
        super.init()
        buttons = [ButtonInfo1, ButtonInfo2, ButtonInfo3, ButtonInfo4, ButtonInfo5, ButtonInfo6]
        
        buttons?.forEach { $0.addTarget(self, action: #selector(EmergencyTypeButtonTapped), for: .touchUpInside)}
 
    }
    
    
    func show(){
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(ViewTwo)
            
            ViewTwo.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 330)
            ViewTwo.backgroundColor = UIColor.white
            ViewTwo.layer.cornerRadius = 10
            ViewTwo.alpha = 0
            
            width = (ViewTwo.frame.width-40)/3
            width = width!/1.8
            height = (ViewTwo.frame.height-40)/3
            height = height!/1.8
            setupConstrains()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.ViewTwo.alpha = 1
                self.ViewTwo.anchor(top: nil, leading: window.leadingAnchor, bottom: window.safeAreaLayoutGuide.bottomAnchor, trailing: window.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 85, right: 20),size: CGSize(width: 0, height: 330))
            })
        }
    }
    
    
    
    
    func hide() {
        UIView.animate(withDuration: 0.5) {
            self.ViewTwo.alpha = 0
        }
    }
    
    func hideAndResetToDefualt(){
         self.ViewTwo.alpha = 0
            self.selectedEmergencyType = "Accident"
            self.buttons?.forEach { $0.isSelected = false }
            self.ButtonInfo2.isSelected = true
    }
    
    @objc func EmergencyTypeButtonTapped(sender:UIButton){
        buttons?.forEach { $0.isSelected = false }
        sender.isSelected = true
        
        switch sender.tag
        {
        case 1:
            selectedEmergencyType = "Pregnent"
            break
        case 2:
            selectedEmergencyType = "Accident"
            break
        case 3:
            selectedEmergencyType = "Fire"
            break
        case 4:
            selectedEmergencyType = "Else"
            break
        case 5:
            selectedEmergencyType = "Head Injury"
            break
        case 6:
            selectedEmergencyType = "Heart Attack"
            break
        default:
            break
        }
    }
    
    
    private func setupConstrains(){
        [ButtonInfo1,ButtonInfo2, ButtonInfo3, ButtonInfo4, ButtonInfo5, ButtonInfo6].forEach { ViewTwo.addSubview($0) }
        [TitleButtonInfo1,TitleButtonInfo2,TitleButtonInfo3,TitleButtonInfo4,TitleButtonInfo5,TitleButtonInfo6,InfoTwoTitle].forEach { ViewTwo.addSubview($0) }
        
        
        
        ButtonInfo1.anchor(top: ViewTwo.topAnchor, leading: ButtonInfo2.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 25, left: 50, bottom: 0, right: 0),size: CGSize(width: width!, height: height!))
        TitleButtonInfo1.anchor(top: ButtonInfo1.bottomAnchor, leading: ButtonInfo1.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        
        ButtonInfo2.anchor(top: ViewTwo.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 25, left: 0, bottom: 0, right: 0),size: CGSize(width: width!, height: height!))
        ButtonInfo2.centerXAnchor.constraint(equalTo: self.ViewTwo.centerXAnchor).isActive = true
        TitleButtonInfo2.anchor(top: ButtonInfo2.bottomAnchor, leading: ButtonInfo2.leadingAnchor, bottom: nil, trailing: ButtonInfo2.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        ButtonInfo3.anchor(top: ViewTwo.topAnchor, leading: nil, bottom: nil, trailing: ButtonInfo2.leadingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 50),size: CGSize(width: width!, height: height!))
        TitleButtonInfo3.anchor(top: ButtonInfo3.bottomAnchor, leading: ButtonInfo3.leadingAnchor, bottom: nil, trailing: ButtonInfo3.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        
        ButtonInfo4.anchor(top: ButtonInfo1.bottomAnchor, leading: nil, bottom: nil, trailing: ButtonInfo1.trailingAnchor, padding: .init(top: 65, left: 0, bottom: 0, right: 0),size: CGSize(width: width!, height: height!))
        TitleButtonInfo4.anchor(top: ButtonInfo4.bottomAnchor, leading: ButtonInfo4.leadingAnchor, bottom: nil, trailing: ButtonInfo4.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        ButtonInfo5.anchor(top: ButtonInfo2.bottomAnchor, leading: nil, bottom: nil, trailing: ButtonInfo2.trailingAnchor, padding: .init(top: 65, left: 0, bottom: 0, right: 0),size: CGSize(width: width!, height: height!))
        TitleButtonInfo5.anchor(top: ButtonInfo5.bottomAnchor, leading: ButtonInfo5.leadingAnchor, bottom: nil, trailing: ButtonInfo5.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        
        ButtonInfo6.anchor(top: ButtonInfo3.bottomAnchor, leading: nil, bottom: nil, trailing: ButtonInfo3.trailingAnchor, padding: .init(top: 65, left: 0, bottom: 0, right: 0),size: CGSize(width: width!, height: height!))
        TitleButtonInfo6.anchor(top: ButtonInfo6.bottomAnchor, leading: ButtonInfo6.leadingAnchor, bottom: nil, trailing: ButtonInfo6.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        InfoTwoTitle.anchor(top: nil, leading: nil, bottom: ViewTwo.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 20, right: 0),size: CGSize(width: 0, height: 0))
        InfoTwoTitle.centerXAnchor.constraint(equalTo: self.ViewTwo.centerXAnchor).isActive = true
        
    }
    
    
    
    let TitleButtonInfo1 : UILabel = {
        var label = UILabel()
        label.text = "Pregnency"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    let TitleButtonInfo2 : UILabel = {
        var label = UILabel()
        label.text = "Accident"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    let TitleButtonInfo3 : UILabel = {
        var label = UILabel()
        label.text = "Fire"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    let TitleButtonInfo4 : UILabel = {
        var label = UILabel()
        label.text = "Else"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    let TitleButtonInfo5 : UILabel = {
        var label = UILabel()
        label.text = "Head Injury"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    let TitleButtonInfo6 : UILabel = {
        var label = UILabel()
        label.text = "Heart Attack"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    let InfoTwoTitle : UILabel = {
        var label = UILabel()
        label.text = "Choose Emergency Type"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        
        return label
    }()
    let ButtonInfo1: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "PregnantNotSelected"), for: .normal)
        button.setBackgroundImage(UIImage(named: "PregnantICON"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 1
        return button
    }()
    let ButtonInfo2: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.isSelected = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "AccidentNotSelected"), for: .normal)
        button.setBackgroundImage(UIImage(named: "CrashedICON"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 2
        return button
    }()
    let ButtonInfo3: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "FireNotSelected"), for: .normal)
        button.setBackgroundImage(UIImage(named: "FireICON"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 3
        return button
    }()
    let ButtonInfo4: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "ElseNotSelected"), for: .normal)
        button.setBackgroundImage(UIImage(named: "ElseICON"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 4
        return button
    }()
    let ButtonInfo5: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "HeadInjuryNotSelected"), for: .normal)
        button.setBackgroundImage(UIImage(named: "HeadInjuryICON"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 5
        return button
    }()
    let ButtonInfo6: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "HeartAttackNotSelected"), for: .normal)
        button.setBackgroundImage(UIImage(named: "HeartAttackICON"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 6
        return button
    }()
    let subTitleInfoLabel : UILabel = {
        var label = UILabel()
        label.text = "Select Emergency Type"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    
    
    
    
}
