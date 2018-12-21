

import UIKit
import Firebase
import FirebaseAuth
import NotificationCenter
import SCLAlertView
import SVProgressHUD
import SkyFloatingLabelTextField

class SignUpController: UIViewController,UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
         self.navigationController?.isNavigationBarHidden = true
        SVProgressHUD.setForegroundColor(UIColor.red)

        setupConstrains()
        SetupComponentDelegetes()
        ShowVisibleButton()
    }
    func SetupComponentDelegetes(){
        NameTextField.delegate = self
        lastNameTextField.delegate = self
        PasswordTextField.delegate = self
        ConfirmPasswordTextField.delegate = self
        PhoneTextField.delegate = self
        EmailTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    // MARK :-   Main Methods
    /********************************************************************************************/
    @objc func SignUpButtonAction(sender: UIButton!) {
         checkEmptyFields()
    }
    
    @objc func AddNewuser(){
        guard let name = NameTextField.text,let email = EmailTextField.text, let password = PasswordTextField.text, let phone = PhoneTextField.text, let lastName = lastNameTextField.text  else {
            print("Form is not valid")
            return
        }
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        Auth.auth().createUser(withEmail: email, password: password) { (res, error) in
            if let error = error {
                print(error)
                self.dismissRingIndecator()
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
               self.dismissRingIndecator()
                // succeed ..
                let new = MedicalInformation()
                self.navigationController?.pushViewController(new, animated: true)
            })
        }
    }
    
    @objc func backButtonAction(sender: UIButton!) {
        print("Back")
        dismiss(animated: true, completion: nil)
    }
    
   
    func checkEmptyFields(){
        guard let _ = PasswordTextField.text,  !(PasswordTextField.text?.isEmpty)! else {
             SCLAlertView().showError("Error", subTitle: "Enter Password!")
            return
        }
        guard let _ = NameTextField.text,  !(NameTextField.text?.isEmpty)! else {
            SCLAlertView().showError("Error", subTitle: "Enter your Name!")
            return
        }
        guard let _ = lastNameTextField.text,  !(lastNameTextField.text?.isEmpty)! else {
            SCLAlertView().showError("Error", subTitle: "Enter your Last Name!")
            return
        }
        guard let _ = EmailTextField.text,  !(EmailTextField.text?.isEmpty)!else {
            SCLAlertView().showError("Error", subTitle: "Enter your Email!")
            return
        }
        guard let _ = ConfirmPasswordTextField.text,  !(ConfirmPasswordTextField.text?.isEmpty)! else {
            SCLAlertView().showError("Error", subTitle: "Confirm Password!")
            return
        }
        if PasswordTextField.text != ConfirmPasswordTextField.text {
            SCLAlertView().showError("Error", subTitle: "Password and Confirm Password not Match!")
            return
        }
        guard let _ = PhoneTextField.text, (PhoneTextField.text?.count)! == 11 else {
              SCLAlertView().showError("Error", subTitle: "Write Valid Phone Number!")
            return
        }
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Agree", target: self, selector: #selector(AddNewuser))
        alertView.addButton("disagree") {    }
        alertView.showWarning("Warning", subTitle: "All your information saved in external database, that can be viewed by the admin, Agree?")
    }
    
    func dismissRingIndecator(){
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            SVProgressHUD.setDefaultMaskType(.none)
        }
    }
    
    
    
    //     MARK :- eye button on textfield
    /**********************************************************************************************/
    func ShowVisibleButton(){
        view.addSubview(rightButtonToggle)
        rightButtonToggle.anchor(top: nil, leading: nil, bottom: nil, trailing: PasswordTextField.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 15), size: CGSize(width: 25, height: 25))
        rightButtonToggle.centerYAnchor.constraint(equalTo: self.PasswordTextField.centerYAnchor).isActive = true
        
    }
    let rightButtonToggle: UIButton = {
        let rightButton  = UIButton(type: .custom)
        rightButton.frame = CGRect(x:0, y:0, width: 25, height: 25)
        rightButton.setBackgroundImage(UIImage(named: "invisibleICON"), for: .normal)
        rightButton.setBackgroundImage(UIImage(named: "visibleICON"), for: .selected)
        rightButton.isSelected = false
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        rightButton.addTarget(self, action: #selector(PasswordTogglekButtonAction), for: .touchUpInside)
        return rightButton
    }()
    
    var secure = true
    @objc func PasswordTogglekButtonAction(){
        if(secure == false) {
            PasswordTextField.isSecureTextEntry = false
            ConfirmPasswordTextField.isSecureTextEntry = false
            rightButtonToggle.isSelected = true
        } else {
            PasswordTextField.isSecureTextEntry = true
             ConfirmPasswordTextField.isSecureTextEntry = true
            rightButtonToggle.isSelected = false
        }
        secure = !secure
    }

    
    //   MARK :- Constrains
    /**********************************************************************************************/
    private func setupConstrains(){
        view.addSubview(backButton)
        view.addSubview(stackView1)
        view.addSubview(stackView3)
        view.addSubview(stackView4)
        view.addSubview(stackView5)
        view.addSubview(scrollView)
        
        stackView5.addArrangedSubview(NameTextField)
         stackView5.addArrangedSubview(lastNameTextField)

        stackView1.addArrangedSubview(titleLabel)
        stackView1.addArrangedSubview(subTitleLabel)
        
        stackView3.addArrangedSubview(LogInLabel)
        stackView3.addArrangedSubview(IconImage)
        stackView3.addArrangedSubview(stackView1)
        
        stackView4.addArrangedSubview(stackView3)
        stackView4.addArrangedSubview(scrollView)
        stackView4.addArrangedSubview(SignUpButton)
        
        stackView2.addArrangedSubview(stackView5)
        stackView2.addArrangedSubview(EmailTextField)
        stackView2.addArrangedSubview(PhoneTextField)
        stackView2.addArrangedSubview(PasswordTextField)
        stackView2.addArrangedSubview(ConfirmPasswordTextField)
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 30, bottom: 0, right: 0),size: CGSize(width: 35, height: 35))
        
       //   IconImage.anchor(top: nil, leading: nil, bottom: nil, trailing: nil,size: CGSize(width: 60, height: 60))
        
        
        stackView4.anchor(top: backButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 20, right: 0))
        
            stackView3.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0) )
        
        
          scrollView.anchor(top: stackView3.bottomAnchor, leading: stackView4.leadingAnchor, bottom: SignUpButton.topAnchor, trailing: stackView4.trailingAnchor, padding: .init(top: 15, left: 20, bottom: 15, right: 20))
         scrollView.addSubview(stackView2)
      
        
        stackView2.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor)
        stackView2.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0).isActive = true
        
         NameTextField.anchor(top: stackView5.topAnchor, leading: nil, bottom: stackView5.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
         lastNameTextField.anchor(top: stackView5.topAnchor, leading: nil, bottom: stackView5.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))


         stackView5.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        EmailTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        PhoneTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        PasswordTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
         ConfirmPasswordTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        SignUpButton.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30),size: CGSize(width: 0, height: 50))
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
        sv.distribution  = UIStackView.Distribution.fillEqually
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 2.0
        return sv
    }()
    let stackView3: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.equalSpacing
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 20.0
        return sv
    }()
    let stackView4: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.equalSpacing
        sv.alignment = UIStackView.Alignment.center
        sv.spacing  = 30
        return sv
    }()
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.backgroundColor = UIColor.white
        v.isScrollEnabled = true
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentSize.height = 2000
        return v
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
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.backgroundColor = UIColor.white
         label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let EmailTextField: SkyFloatingLabelTextField = {
        let tx = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Email"
        tx.title = "Email"
        tx.lineHeight = 1.0
        tx.selectedLineHeight = 2.0
        tx.tintColor = UIColor.red // the color of the blinking cursor
        tx.textColor = UIColor.black
        tx.lineColor = UIColor.lightGray
        tx.selectedTitleColor = UIColor.red
        tx.selectedLineColor = UIColor.red
        tx.font = UIFont(name: "FontAwesome", size: 15)
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.emailAddress
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let PasswordTextField: SkyFloatingLabelTextField = {
        let tx = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Password"
        tx.title = "Password"
        tx.lineHeight = 1.0
        tx.selectedLineHeight = 2.0
        tx.tintColor = UIColor.red // the color of the blinking cursor
        tx.textColor = UIColor.black
        tx.lineColor = UIColor.lightGray
        tx.selectedTitleColor = UIColor.red
        tx.selectedLineColor = UIColor.red
        tx.isSecureTextEntry = true
        tx.font = UIFont(name: "FontAwesome", size: 15)
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.default
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.never
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let ConfirmPasswordTextField: SkyFloatingLabelTextField = {
        let tx = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Confirm Password"
        tx.title = "Confirm Password"
        tx.lineHeight = 1.0
        tx.selectedLineHeight = 2.0
        tx.tintColor = UIColor.red // the color of the blinking cursor
        tx.textColor = UIColor.black
        tx.lineColor = UIColor.lightGray
        tx.selectedTitleColor = UIColor.red
        tx.selectedLineColor = UIColor.red
         tx.isSecureTextEntry = true
        tx.font = UIFont(name: "FontAwesome", size: 15)
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.default
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.never
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let PhoneTextField: SkyFloatingLabelTextField = {
        let tx = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Phone"
        tx.title = "Phone"
        tx.lineHeight = 1.0
        tx.selectedLineHeight = 2.0
        tx.tintColor = UIColor.red // the color of the blinking cursor
        tx.textColor = UIColor.black
        tx.lineColor = UIColor.lightGray
        tx.selectedTitleColor = UIColor.red
        tx.selectedLineColor = UIColor.red
        tx.font = UIFont(name: "FontAwesome", size: 15)
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.numberPad
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let NameTextField: SkyFloatingLabelTextField = {
        let tx = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "First Name"
        tx.title = "First Name"
        tx.lineHeight = 1.0
        tx.selectedLineHeight = 2.0
        tx.tintColor = UIColor.red // the color of the blinking cursor
        tx.textColor = UIColor.black
        tx.lineColor = UIColor.lightGray
        tx.selectedTitleColor = UIColor.red
        tx.selectedLineColor = UIColor.red
        tx.font = UIFont(name: "FontAwesome", size: 15)
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.default
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let lastNameTextField: SkyFloatingLabelTextField = {
        let tx = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Last Name"
        tx.title = "Last Name"
        tx.lineHeight = 1.0
        tx.selectedLineHeight = 2.0
        tx.tintColor = UIColor.red // the color of the blinking cursor
        tx.textColor = UIColor.black
        tx.lineColor = UIColor.lightGray
        tx.selectedTitleColor = UIColor.red
        tx.selectedLineColor = UIColor.red
        tx.font = UIFont(name: "FontAwesome", size: 15)
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
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
         label.numberOfLines = 0
        label.textColor = UIColor.gray
        return label
    }()
    let subTitleLabel : UILabel = {
        var label = UILabel()
        label.text = "Signup with Ambulance in simple steps"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
         label.numberOfLines = 0
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

