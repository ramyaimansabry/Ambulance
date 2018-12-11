//
//  EditProfileController.swift
//  Ambulance
//
//  Created by Ramy on 12/10/18.
//  Copyright © 2018 Ramy. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import SVProgressHUD


class EditProfileController: UIViewController {
    var changed: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupViews()
        LoadUserInfo()
        AddtextfieldDelegete()
    }
    override func viewWillDisappear(_ animated: Bool) {
        changed = false
        EditModeOff()
    }
    
    // MARK :-  Main Methods
    /********************************************************************************************/
    @objc func textFieldDidChange(_ textField: UITextField) {
        changed = true
        SaveButtonn.isEnabled = true
    }
    var fullName:String = ""
    
    func LoadUserInfo(){
        let userID = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference().child("users").child(userID)
        ref.observe(.value, with: { (snapshot) in
            
            if !snapshot.exists() { return }
            
            if let name: String = snapshot.childSnapshot(forPath: "First Name").value as? String {
                DispatchQueue.main.async {
                    self.fullName = String(name)
                    self.NameTextField.text = String(name)
                }
            }
            if let email: String = snapshot.childSnapshot(forPath: "Email").value as? String {
                DispatchQueue.main.async {
                    self.EmailTextField.text = String(email)
                    self.subTitleLabel.text = String(email)
                }
            }
            if let lastName: String = snapshot.childSnapshot(forPath: "Last Name").value as? String {
                DispatchQueue.main.async {
                    self.lasrNameTextField.text = String(lastName)
                    self.fullName.append(" \(String(lastName))")
                }
            }
            if let phone: String = snapshot.childSnapshot(forPath: "Phone").value as? String {
                DispatchQueue.main.async {
                    self.PhoneTextField.text = String(phone)
                }
            }
            DispatchQueue.main.async {
                self.TitleLabel.text = self.fullName  
            }
          
            
        }) { (error) in
            SCLAlertView().showError("Error", subTitle: error.localizedDescription)
        }
        
        
    }
    
    func updateUserInfo(){
        guard let name = NameTextField.text,let email = EmailTextField.text, let phone = PhoneTextField.text, let lastName = lasrNameTextField.text  else {
            print("Form is not valid")
            return
        }
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
            if let error = error {
                print(error)
                self.dismissRingIndecator()
                SCLAlertView().showError("Error", subTitle: error.localizedDescription)
                return
            }
        }
        let userID = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference().child("users").child(userID)

        let values = ["First Name": name,"Last Name": lastName, "Email": email, "Phone": phone]
        ref.updateChildValues(values, withCompletionBlock: { (error, ref) in

            if error != nil {
                let showError:String = error?.localizedDescription ?? ""
                SCLAlertView().showError("Error", subTitle: showError)
                return
            }

            // succeed ..
            self.dismissRingIndecator()
            SCLAlertView().showSuccess("Done", subTitle: "Info Saved Correctly")
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func AddtextfieldDelegete(){
        NameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lasrNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        EmailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        PhoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
     @objc func SaveButtonAction(){
        if changed {
            checkEmptyFields()
        }else {
             self.navigationController?.popViewController(animated: true)
        }
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
        guard let name = NameTextField.text,  NameTextField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Enter your Name!")
            return
        }
        guard let lastname = lasrNameTextField.text,  lasrNameTextField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Enter your Last Name!")
            return
        }
        guard let email = EmailTextField.text,  EmailTextField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Enter your Email!")
            return
        }
        guard let phone = PhoneTextField.text, (PhoneTextField.text?.characters.count)! == 11 else {
            SCLAlertView().showError("Error", subTitle: "Write Valid Phone Number!")
            return
        }
        
        updateUserInfo()
    }
    
    @objc func EditButtonAction() {
       EditButton.isEnabled = false
        EditButton.isHidden = true
        EditModeOn()
    
    }
    
    func EditModeOn(){
        SaveButtonn.isEnabled = true
        NameTextField.isEnabled = true
        lasrNameTextField.isEnabled = true
        PhoneTextField.isEnabled = true
        EmailTextField.isEnabled = true
    }
    func EditModeOff(){
        EditButton.isEnabled = true
        EditButton.isHidden = false
        SaveButtonn.isEnabled = false
        
        NameTextField.isEnabled = false
        lasrNameTextField.isEnabled = false
        PhoneTextField.isEnabled = false
        EmailTextField.isEnabled = false
    }
    @objc func ChangePasswordButtonAction(){
        let viewController = ChanagePasswordController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //   MARK :- Constrains
    /**********************************************************************************************/
    private func setupViews(){
        view.addSubview(backButton)
        view.addSubview(EditButton)
        view.addSubview(stackView1)
        view.addSubview(stackView2)
        view.addSubview(stackView3)
        view.addSubview(stackView4)
        view.addSubview(stackView5)
        view.addSubview(stackView7)
        
         backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 30, bottom: 0, right: 0),size: CGSize(width: 35, height: 35))
        
        EditButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 30),size: CGSize(width: 35, height: 35))
        
        stackView5.addArrangedSubview(NameTextField)
        stackView5.addArrangedSubview(lasrNameTextField)
        
        stackView3.addArrangedSubview(CancelButton)
        stackView3.addArrangedSubview(SaveButtonn)
        
        stackView2.addArrangedSubview(stackView5)
        stackView2.addArrangedSubview(EmailTextField)
        stackView2.addArrangedSubview(PhoneTextField)
        stackView2.addArrangedSubview(ChangePasswordButton)

        
        stackView7.addArrangedSubview(TitleLabel)
        stackView7.addArrangedSubview(subTitleLabel)
        
         stackView1.addArrangedSubview(IconImage)
        stackView1.addArrangedSubview(stackView7)
        
        
        stackView4.addArrangedSubview(stackView1)
        stackView4.addArrangedSubview(stackView2)
        stackView4.addArrangedSubview(stackView3)
        
          stackView4.anchor(top: backButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 10, right: 0))
        
            stackView2.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30))
        
        CancelButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 160, height: 45))
        SaveButtonn.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 160, height: 45))
        
        
        NameTextField.anchor(top: stackView5.topAnchor, leading: nil, bottom: stackView5.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        lasrNameTextField.anchor(top: stackView5.topAnchor, leading: nil, bottom: stackView5.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        
        stackView5.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        EmailTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        PhoneTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        ChangePasswordButton.anchor(top: nil, leading: nil, bottom: nil, trailing: stackView2.trailingAnchor)

              IconImage.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 85, height: 85))
    
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
        sv.distribution  = UIStackView.Distribution.fillEqually
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 15
        return sv
    }()
    let stackView1: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.equalSpacing
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 25.0
        return sv
    }()
    let stackView5: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.horizontal
        sv.distribution  = UIStackView.Distribution.fillEqually
        sv.alignment = UIStackView.Alignment.center
        sv.spacing  = 20
        return sv
    }()
    let stackView7: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.equalSpacing
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 2.0
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
        label.text = "Error"
        label.tintColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    let EmailTextField: UITextField = {
        let tx = UITextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Email"
        tx.font = UIFont.systemFont(ofSize: 15)
        tx.borderStyle = UITextField.BorderStyle.roundedRect
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.emailAddress
        tx.returnKeyType = UIReturnKeyType.done
        tx.isEnabled = false
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let PhoneTextField: UITextField = {
        let tx = UITextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Phone"
        tx.font = UIFont.systemFont(ofSize: 15)
        tx.borderStyle = UITextField.BorderStyle.roundedRect
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.numberPad
        tx.returnKeyType = UIReturnKeyType.done
        tx.isEnabled = false
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let NameTextField: UITextField = {
        let tx = UITextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "First Name"
        tx.font = UIFont.systemFont(ofSize: 15)
        tx.borderStyle = UITextField.BorderStyle.roundedRect
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.default
        tx.returnKeyType = UIReturnKeyType.done
        tx.isEnabled = false
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let lasrNameTextField: UITextField = {
        let tx = UITextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "last Name"
        tx.font = UIFont.systemFont(ofSize: 15)
        tx.borderStyle = UITextField.BorderStyle.roundedRect
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.default
        tx.isEnabled = false
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let subTitleLabel : UILabel = {
        var label = UILabel()
        label.text = "Error"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        //   label.backgroundColor = UIColor.gray
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        return label
    }()

    let IconImage : UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "DefualtProfileImage")
        image.layer.cornerRadius = 1
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        return image
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
    let EditButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Edit", for: .normal)
        button.frame.size = CGSize(width: 35, height: 35)
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.blue, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(EditButtonAction), for: .touchUpInside)
        return button
    }()
    let ChangePasswordButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Change Password", for: .normal)
        button.frame.size = CGSize(width: 35, height: 35)
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.blue, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(ChangePasswordButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    
}
