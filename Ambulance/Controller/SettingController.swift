//
//  SettingController.swift
//  Ambulance
//
//  Created by Ramy on 12/9/18.
//  Copyright © 2018 Ramy. All rights reserved.
//


import UIKit
import Firebase
import SCLAlertView
import SVProgressHUD

class SettingController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
        setupViews()
    }
    override func viewDidAppear(_ animated: Bool) {
    
    }
    
    // MARK :-  Main Methods
    /********************************************************************************************/
    @objc func backButtonAction(sender: UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //   MARK :- Constrains
    /**********************************************************************************************/
    private func setupViews(){
        view.addSubview(backButton)
    
    
         backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 30, bottom: 0, right: 0),size: CGSize(width: 35, height: 35))
        
    }
    // MARK :-  Setup Component
    /********************************************************************************************/
    let backButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 35, height: 35)
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "backICON"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()
}
