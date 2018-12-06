

import UIKit
import Firebase
import FirebaseAuth
import NotificationCenter
import SCLAlertView

class SignUpController: UIViewController,UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
         self.navigationController?.isNavigationBarHidden = true
        setupConstrains()
       SetupComponentDelegetes()
    }
    func SetupComponentDelegetes(){
        NameTextField.delegate = self
        lasrNameTextField.delegate = self
        PasswordTextField.delegate = self
        ConfirmPasswordTextField.delegate = self
        PhoneTextField.delegate = self
        EmailTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("1111111111")
        return true
    }

    
    // MARK :-   Main Methods
    /********************************************************************************************/
    @objc func SignUpButtonAction(sender: UIButton!) {
//        let new = MedicalInfoOne()
//        self.navigationController?.pushViewController(new, animated: true)
         checkEmptyFields()
    }
    
    func AddNewuser(){
        guard let name = NameTextField.text,let email = EmailTextField.text, let password = PasswordTextField.text, let phone = PhoneTextField.text, let lastName = lasrNameTextField.text  else {
            print("Form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (res, error) in
            if let error = error {
                print(error)
                SCLAlertView().showError("Error", subTitle: error.localizedDescription)
                return
            }
            
            guard let uid = res?.user.uid else {
                return
            }
            
            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(uid)
            let values = ["First Name": name,"Last Name": lastName, "Email": email, "Phone": phone]
            usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                
                if error != nil {
                    let showError:String = error?.localizedDescription ?? ""
                    SCLAlertView().showError("Error", subTitle: showError)
                    return
                }
                // succeed ..
                let new = MedicalInfoOne()
                self.navigationController?.pushViewController(new, animated: true)
            })
        }
    }
    
    @objc func backButtonAction(sender: UIButton!) {
        print("Back")
        dismiss(animated: true, completion: nil)
    }
    
   
    func checkEmptyFields(){
        guard let password = PasswordTextField.text,  PasswordTextField.text?.characters.count != 0 else {
             SCLAlertView().showError("Error", subTitle: "Enter Password!")
            return
        }
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
        guard let confirmPassword = ConfirmPasswordTextField.text,  ConfirmPasswordTextField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Confirm Password!")
            return
        }
        if PasswordTextField.text != ConfirmPasswordTextField.text {
            SCLAlertView().showError("Error", subTitle: "Password and Confirm Password not Match!")
            return
        }
        guard let phone = PhoneTextField.text, (PhoneTextField.text?.characters.count)! == 11 else {
              SCLAlertView().showError("Error", subTitle: "Write Valid Phone Number!")
            return
        }

       AddNewuser()
    }
    
    
    //   MARK :- Constrains
    /**********************************************************************************************/
    private func setupConstrains(){
//        [NameTextField,lasrNameTextField,EmailTextField,PhoneTextField,PasswordTextField,ConfirmPasswordTextField].forEach { view.addSubview($0) }
//        [IconImage,titleLabel,subTitleLabel,backButton,LogInLabel,SignUpButton].forEach { view.addSubview($0) }
        
        view.addSubview(backButton)
        view.addSubview(stackView2)
        view.addSubview(stackView1)
        view.addSubview(stackView3)
        view.addSubview(stackView4)
        view.addSubview(stackView5)
        
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 30, bottom: 0, right: 0),size: CGSize(width: 35, height: 35))
        
//          LogInLabel.anchor(top: backButton.bottomAnchor, leading: backButton.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
//        LogInLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//
//        IconImage.anchor(top: LogInLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 60, left: 0, bottom: 0, right: 0),size: CGSize(width: 110, height: 110))
//
//        titleLabel.anchor(top: IconImage.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0))
//        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//
//
//        subTitleLabel.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
//        subTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        stackView4.anchor(top: backButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 10, right: 0))
        
       
        
         stackView3.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: stackView4.frame.height/3) )
        
        
        stackView2.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30))
        
        
        stackView5.addArrangedSubview(NameTextField)
         stackView5.addArrangedSubview(lasrNameTextField)
        
        
        stackView1.addArrangedSubview(titleLabel)
        stackView1.addArrangedSubview(subTitleLabel)
        
        
        stackView3.addArrangedSubview(LogInLabel)
        stackView3.addArrangedSubview(IconImage)
        stackView3.addArrangedSubview(stackView1)
        
        stackView4.addArrangedSubview(stackView3)
        stackView4.addArrangedSubview(stackView2)
        stackView4.addArrangedSubview(SignUpButton)
        
        
        stackView2.addArrangedSubview(stackView5)
       // stackView2.addArrangedSubview(lasrNameTextField)
        stackView2.addArrangedSubview(EmailTextField)
        stackView2.addArrangedSubview(PhoneTextField)
        stackView2.addArrangedSubview(PasswordTextField)
        stackView2.addArrangedSubview(ConfirmPasswordTextField)
        
        
       
        
         NameTextField.anchor(top: stackView5.topAnchor, leading: nil, bottom: stackView5.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
         lasrNameTextField.anchor(top: stackView5.topAnchor, leading: nil, bottom: stackView5.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))


         stackView5.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        EmailTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        PhoneTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        PasswordTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
         ConfirmPasswordTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        
        
  
        SignUpButton.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30),size: CGSize(width: 0, height: 50))
        
//        NameTextField.anchor(top: subTitleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 30, left: 20, bottom: 0, right: 0),size: CGSize(width: (self.view.frame.width/2)-20, height: 45))
//
//        lasrNameTextField.anchor(top: subTitleLabel.bottomAnchor, leading: NameTextField.trailingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 20, bottom: 0, right: 10),size: CGSize(width: (self.view.frame.width/2)-20, height: 45))
//
//        EmailTextField.anchor(top: NameTextField.bottomAnchor, leading: NameTextField.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 10),size: CGSize(width: 0, height: 45))
//
//        PhoneTextField.anchor(top: EmailTextField.bottomAnchor, leading: EmailTextField.leadingAnchor, bottom: nil, trailing: EmailTextField.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 45))
//
//        PasswordTextField.anchor(top: PhoneTextField.bottomAnchor, leading: PhoneTextField.leadingAnchor, bottom: nil, trailing: PhoneTextField.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 45))
//
//        ConfirmPasswordTextField.anchor(top: PasswordTextField.bottomAnchor, leading: PasswordTextField.leadingAnchor, bottom: SignUpButton.topAnchor, trailing: PasswordTextField.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 15, right: 0),size: CGSize(width: 0, height: 45))
        
        
        
        
        
//        SignUpButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20),size: CGSize(width: 0, height: 50))
//
        
    }
    
    
    
    // MARK :-  Setup Component
    /********************************************************************************************/
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
        sv.spacing   = 2.0
        return sv
    }()
    let stackView3: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.fill
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 20.0
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
    
    let stackView5: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.horizontal
        sv.distribution  = UIStackView.Distribution.fillEqually
        sv.alignment = UIStackView.Alignment.center
        sv.spacing  = 20
        return sv
    }()
    
    let LogInLabel : UILabel = {
        var label = UILabel()
        label.text = "Signup"
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
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let PasswordTextField: UITextField = {
        let tx = UITextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Password"
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
    let PhoneTextField: UITextField = {
        let tx = UITextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Phone"
        tx.font = UIFont.systemFont(ofSize: 15)
        tx.borderStyle = UITextField.BorderStyle.roundedRect
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.numberPad
        tx.returnKeyType = UIReturnKeyType.done
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
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let titleLabel : UILabel = {
        var label = UILabel()
        label.text = "Welcome Aboard!"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        //   label.backgroundColor = UIColor.gray
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
    }()
    let subTitleLabel : UILabel = {
        var label = UILabel()
        label.text = "Signup with Ambulance in simple steps"
        label.font = UIFont.systemFont(ofSize: 16)
        //   label.backgroundColor = UIColor.gray
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    let IconImage : UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "ambulance")
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
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()
    let SignUpButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.frame.size = CGSize(width: 80, height: 50)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: ""), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(SignUpButtonAction), for: .touchUpInside)
        return button
    }()
    
    
}

extension String {
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
