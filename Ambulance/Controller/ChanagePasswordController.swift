//
//  ChanagePasswordController.swift
//  Ambulance
//
//  Created by Ramy on 12/11/18.
//  Copyright © 2018 Ramy. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import SVProgressHUD


class ChanagePasswordController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupViews()
 
    }

    
    // MARK :-  Main Methods
    /********************************************************************************************/
  
    func updateUserInfo(){
        guard  let newPassword = PasswordTextField.text, let confirmPassword = ConfirmPasswordTextField.text  else {
            print("Form is not valid")
            return
        }
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)

        
        Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
            if let error = error {
                print(error)
                self.dismissRingIndecator()
                SCLAlertView().showError("Error", subTitle: error.localizedDescription)
                return
            }
            // succeed ..
             self.dismissRingIndecator()
            SCLAlertView().showSuccess("Done", subTitle: "Password Changed Correctly")
            self.navigationController?.popViewController(animated: true)

        })
    }
    
    
    @objc func SaveButtonAction(){
            checkEmptyFields()
    }
    @objc func CancelButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func backButtonAction(sender: UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    func dismissRingIndecator(){
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            SVProgressHUD.setDefaultMaskType(.none)
        }
    }
    func checkEmptyFields(){
//        guard let oldpassword = OldPasswordTextField.text,  OldPasswordTextField.text?.characters.count != 0 else {
//            SCLAlertView().showError("Error", subTitle: "Check old password!")
//            return
//        }
        guard let password = PasswordTextField.text,  PasswordTextField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Check New Password!")
            return
        }
        guard let confirmPassword = ConfirmPasswordTextField.text,  ConfirmPasswordTextField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Check New Password!")
            return
        }
        if PasswordTextField.text != ConfirmPasswordTextField.text {
            SCLAlertView().showError("Error", subTitle: "Password and Confirm Password not Match!")
            return
        }

        updateUserInfo()
    }

    
    //   MARK :- Constrains
    /**********************************************************************************************/
    private func setupViews(){
        view.addSubview(backButton)
        view.addSubview(stackView2)
        view.addSubview(stackView3)
        view.addSubview(stackView4)
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 30, bottom: 0, right: 0),size: CGSize(width: 35, height: 35))
        
        stackView3.addArrangedSubview(CancelButton)
        stackView3.addArrangedSubview(SaveButtonn)
        
      //  stackView2.addArrangedSubview(OldPasswordTextField)
        stackView2.addArrangedSubview(PasswordTextField)
        stackView2.addArrangedSubview(ConfirmPasswordTextField)
    
        stackView4.addArrangedSubview(TitleLabel)
        stackView4.addArrangedSubview(stackView2)
        stackView4.addArrangedSubview(stackView3)
        
        stackView4.anchor(top: backButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 20, right: 0))
        
        stackView2.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        CancelButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 160, height: 45))
        SaveButtonn.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 160, height: 45))
        
        
       
   //     OldPasswordTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        PasswordTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        ConfirmPasswordTextField.anchor(top: nil, leading: nil, bottom: nil, trailing: stackView2.trailingAnchor)

    }
    
    
    // MARK :-  Setup Component
    /********************************************************************************************/
    let stackView3: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.horizontal
        sv.distribution  = UIStackView.Distribution.fillEqually
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 30.0
        return sv
    }()
    let stackView2: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.equalCentering
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 15
        return sv
    }()

    let stackView4: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.equalCentering
        sv.alignment = UIStackView.Alignment.center
        sv.spacing  = 30
        return sv
    }()
    
    let CancelButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Cancel", for: .normal)
        // button.frame.size = CGSize(width: 100, height: 40)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(CancelButtonAction), for: .touchUpInside)
        return button
    }()
    let SaveButtonn: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Save", for: .normal)
        //     button.frame.size = CGSize(width: 100, height: 40)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(SaveButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    
    let TitleLabel : UILabel = {
        var label = UILabel()
        label.text = "Change Password"
        label.tintColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    let OldPasswordTextField: UITextField = {
        let tx = UITextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Old Password"
        tx.font = UIFont.systemFont(ofSize: 15)
        tx.borderStyle = UITextField.BorderStyle.roundedRect
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.emailAddress
        tx.returnKeyType = UIReturnKeyType.done
        tx.isEnabled = true
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let PasswordTextField: UITextField = {
        let tx = UITextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "New Password"
        tx.font = UIFont.systemFont(ofSize: 15)
        tx.borderStyle = UITextField.BorderStyle.roundedRect
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.default
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let ConfirmPasswordTextField: UITextField = {
        let tx = UITextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Confirm Password"
        tx.font = UIFont.systemFont(ofSize: 15)
        tx.borderStyle = UITextField.BorderStyle.roundedRect
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.default
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let backButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 35, height: 35)
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "backICON"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isEnabled = true
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()
    
}
