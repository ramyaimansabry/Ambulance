//
//  LeftSideMenuController.swift
//  Ambulance
//
//  Created by Ramy on 12/8/18.
//  Copyright © 2018 Ramy. All rights reserved.
//

import UIKit

class LeftSideMenuController: NSObject,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout  {
    var homeController: HomeVC?
    let leftView = UIView()
     let blackView = UIView()
     let cellId = "cellId"
    var rows: [Row] = []
    
    override init() {
       
        super.init()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.leftView.addGestureRecognizer(swipeLeft)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTabGesture)))
        
        declareRows()
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
    }
   func declareRows(){
    let Row1 = Row(title: "My profile", imageName: "MyProfileICON")
    let Row2 = Row(title: "Settings", imageName: "SettingICON")
    let Row3 = Row(title: "Logout",  imageName: "LogoutICON")
    let Row4 = Row(title: "Rate us", imageName: "RateusICON")
    let Row5 = Row(title: "Call 123", imageName: "PhoneCallICON")
    let Row6 = Row(title: "Refer your friends", imageName: "ShareICON")
    let Row7 = Row(title: "Medical information", imageName: "MedicalInfo2ICON")
    rows.append(Row1)
    rows.append(Row7)
    rows.append(Row5)
    rows.append(Row4)
    rows.append(Row6)
    rows.append(Row2)
    rows.append(Row3)
    }
    func show(){
       
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
         if let window = UIApplication.shared.keyWindow {
            let widthValue = (window.frame.width/3)*2
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            window.addSubview(leftView)
            leftView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
            leftView.backgroundColor = UIColor.white
            leftView.layer.cornerRadius = 10
            
            
            let collectionViewYValue = (window.frame.height/6)+self.leftView.safeAreaInsets.top
            leftView.addSubview(collectionView)
            setupConstrains()
            
            
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.leftView.addSubview(self.collectionView)
                self.setupConstrains()
                self.blackView.alpha = 1
                self.leftView.frame = CGRect(x: 0, y: 0, width: widthValue, height: window.frame.height)
                self.collectionView.frame = CGRect(x: 10, y: collectionViewYValue, width: self.leftView.frame.width-20, height: self.leftView.frame.height-70)
               
            }, completion: nil)
        }
    }
    
    func hide() {
         if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.3, animations: {
                //  self.leftView.alpha = 0
                self.blackView.alpha = 0
                //   self.collectionView.alpha = 0
                self.leftView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
                self.collectionView.frame = CGRect(x: 0, y: 0, width: 0, height: self.leftView.frame.height-70)
            }) { (Completed: Bool) in
                // do stuff her ...........
                print("completion block")
               
                
            }
        }
    }
   
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            print("Swipe Left")
            hide()
        }
    }
    
    @objc func handleTabGesture(){
        hide()
        }
    
    
    func setupConstrains(){
      [shadowView].forEach { leftView.addSubview($0) }
    
        shadowView.anchor(top: leftView.topAnchor, leading: nil, bottom: leftView.bottomAnchor, trailing: leftView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 3, height: 0))
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        let row = rows[indexPath.item]
        cell.row = row
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-10, height: 65)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Rows = rows[indexPath.item]
        print(Rows.title)
        if indexPath.item == 0 {
             hide()
        }
        switch indexPath.item {
        case 0:
            self.homeController?.setViewToDefault()
            self.homeController?.ShowMyProfileViewController()
            self.hide()
           
            break
        case 1:
            self.homeController?.setViewToDefault()
            self.homeController?.ShowMyMediicalInfoController()
            self.hide()
            break
        case 2:
            self.hide()
            self.homeController?.Call123()
            break
        case 3:
            
            break
        case 4:
            
            break
        case 5:
             self.homeController?.setViewToDefault()
             self.homeController?.ShowSettingController()
             self.hide()
            break
        case 6:
            self.hide()
            self.homeController?.logMeOut()
            break
        default:
            break
        }
       
    }
    
    
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = false
        return cv
    }()
    let shadowView: UIView = {
        let window = UIApplication.shared.keyWindow!
        let line = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: window.frame.height))
        line.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        line.layer.cornerRadius = 10
        return line
    }()
    let IconImage : UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "DefualtProfileImage")
        image.layer.cornerRadius = 1
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
}
