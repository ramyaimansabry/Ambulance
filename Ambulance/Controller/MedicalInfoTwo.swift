//
//  TestOne.swift
//  Ambulance
//
//  Created by Ramy on 12/1/18.
//  Copyright © 2018 Ramy. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class MedicalInfoTwo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupConstrains()
}
   
    
    //   MARK :-  Main Methods
    /**********************************************************************************************/
    @objc func SignUpButtonAction(sender: UIButton!) {
        checkEmptyFields()
    }
    
    func SaveMedicalInfo(){
        guard let diseasses = DiseasesTextView.text,let surgery = SurgeryTextView.text, let notes = NotesTextView.text  else {
            print("Form is not valid")
            return
        }
        let userID = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(userID)
        let values = ["Any Diseases?": diseasses,"Had Surgery?": surgery, "Notes?": notes]
        usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                let showError:String = error?.localizedDescription ?? ""
                SCLAlertView().showError("Error", subTitle: showError)
                return
            }
           //  success ..
            print("Saved user successfully into Firebase db")
            UserDefaults.standard.set(true, forKey: "IsLoggedIn")
            UserDefaults.standard.synchronize()
             SCLAlertView().showSuccess("Done", subTitle: "Successfully Signed up")
                let homeController = HomeVC()
                 self.present(homeController, animated: true, completion: nil)
        })
    }
    
    
    
    func checkEmptyFields(){
        if DiseasesTextView.text?.isEmpty == true  || SurgeryTextView.text?.isEmpty == true || NotesTextView.text?.isEmpty == true  {
            SCLAlertView().showError("Error", subTitle: "Fill All Fields!")
            return
        }
        
        SaveMedicalInfo()
    }
    
    //   MARK :- Constrains
    /**********************************************************************************************/
    private func setupConstrains(){
        view.addSubview(IconImage)
        view.addSubview(LogInLabel)
        view.addSubview(SignUpButton)
        view.addSubview(DiseasesTextView)
        view.addSubview(SurgeryTextView)
        view.addSubview(NotesTextView)
        view.addSubview(FirstQuestionLabel)
        view.addSubview(SecandQuestionLabel)
        view.addSubview(ThirdQuestionLabel)
        
        LogInLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 40, left: 0, bottom: 0, right: 0))
        
        IconImage.anchor(top: LogInLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0),size: CGSize(width: 110, height: 110))
        IconImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
        FirstQuestionLabel.anchor(top: IconImage.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 30, left: 20, bottom: 0, right: 20),size: CGSize(width: 0, height: 0))
        DiseasesTextView.anchor(top: FirstQuestionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 20, bottom: 0, right: 20),size: CGSize(width: 110, height: 110))
        
        SecandQuestionLabel.anchor(top: DiseasesTextView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 20, bottom: 0, right: 20),size: CGSize(width: 0, height: 0))
        SurgeryTextView.anchor(top: SecandQuestionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 20, bottom: 0, right: 20),size: CGSize(width: 110, height: 110))
        
        ThirdQuestionLabel.anchor(top: SurgeryTextView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 20, bottom: 0, right: 20),size: CGSize(width: 0, height: 0))
        NotesTextView.anchor(top: ThirdQuestionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 20, bottom: 0, right: 20),size: CGSize(width: 110, height: 110))
        
        SignUpButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 60, right: 20),size: CGSize(width: 0, height: 50))
    }
    
    
    // MARK :-  Setup Component
    /********************************************************************************************/
    let FirstQuestionLabel : UILabel = {
        var label = UILabel()
        label.text = "Do you suffer from any diseases?"
        label.tintColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()
    let SecandQuestionLabel : UILabel = {
        var label = UILabel()
        label.text = "Do you had any surgery before?"
        label.tintColor = UIColor.black
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    let ThirdQuestionLabel : UILabel = {
        var label = UILabel()
        label.text = "Any notes about your overall health condition?"
        label.tintColor = UIColor.black
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()
    let DiseasesTextView: UITextView = {
        let tv = UITextView(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tv.textAlignment = NSTextAlignment.justified
        tv.textColor = UIColor.black
        tv.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        tv.font =  UIFont.systemFont(ofSize: 15)
        tv.isEditable = true
        return tv
    }()
    let SurgeryTextView: UITextView = {
        let tv = UITextView(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tv.textAlignment = NSTextAlignment.justified
        tv.textColor = UIColor.black
        tv.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        tv.font =  UIFont.systemFont(ofSize: 15)
        tv.isEditable = true
        return tv
    }()
    let NotesTextView: UITextView = {
        let tv = UITextView(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tv.textAlignment = NSTextAlignment.justified
        tv.textColor = UIColor.black
        tv.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        tv.font =  UIFont.systemFont(ofSize: 15)
        tv.isEditable = true
        return tv
    }()
    let IconImage : UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "MedicalICON")
        image.layer.cornerRadius = 1
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    let LogInLabel : UILabel = {
        var label = UILabel()
        label.text = "Medical Information"
        label.tintColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let SignUpButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Save", for: .normal)
        button.frame.size = CGSize(width: 80, height: 100)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: ""), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(SignUpButtonAction), for: .touchUpInside)
        return button
    }()
    
}
