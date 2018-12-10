

import UIKit
import Firebase
import SCLAlertView
import SVProgressHUD

class SignInController: UIViewController,UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
         SVProgressHUD.setForegroundColor(UIColor.red)
        setupViews()
        ShowVisibleButton()
        SetupComponentDelegetes()
    }

    func SetupComponentDelegetes(){
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
    }
    
    // MARK :-  Main Methods
    /********************************************************************************************/
    @objc func SignInButtonAction(sender: UIButton!) {
         checkEmptyFields()
    }
    func checkEmptyFields(){
        if EmailTextField.text?.isEmpty == true  || PasswordTextField.text?.isEmpty == true{
            SCLAlertView().showError("Error", subTitle: "Fill All Fields!")
            return
        }
        handelLogin()
    }
    
    func handelLogin(){
        guard let email = EmailTextField.text, let password = PasswordTextField.text else {
            print("form is not valid *****ERROR*****")
            return
        }
       
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error)
                let showError:String = error?.localizedDescription ?? ""
                self.dismissRingIndecator()
                SCLAlertView().showError("Error", subTitle: showError)
                return
            }
            // suceess
           self.dismissRingIndecator()
            UserDefaults.standard.set(true, forKey: "IsLoggedIn")
            UserDefaults.standard.synchronize()
            let homeController = HomeVC()
            self.present(homeController, animated: true, completion: nil)
        }
    }
  
    @objc func backButtonAction(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
            rightButtonToggle.isSelected = true
        } else {
            PasswordTextField.isSecureTextEntry = true
            rightButtonToggle.isSelected = false
        }
        secure = !secure
    }
    
    
    //   MARK :- Constrains
    /**********************************************************************************************/
    private func setupViews(){
        view.addSubview(backButton)
        view.addSubview(LogInLabel)
        view.addSubview(EmailTextField)
        view.addSubview(PasswordTextField)
        view.addSubview(SignInButton)
        view.addSubview(IconImage)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 30, bottom: 0, right: 0),size: CGSize(width: 35, height: 35))
        
        LogInLabel.anchor(top: backButton.bottomAnchor, leading: backButton.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
          LogInLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        EmailTextField.anchor(top: nil, leading: PasswordTextField.leadingAnchor, bottom: PasswordTextField.topAnchor, trailing: PasswordTextField.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 20, right: 0),size: CGSize(width: 0, height: 45))
        
        PasswordTextField.anchor(top: nil, leading: SignInButton.leadingAnchor, bottom: SignInButton.topAnchor, trailing: SignInButton.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 50, right: 0),size: CGSize(width: 0, height: 45))
        
        SignInButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 60, right: 20),size: CGSize(width: 0, height: 50))
        
             IconImage.anchor(top: LogInLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 60, left: 0, bottom: 0, right: 0),size: CGSize(width: 110, height: 110))
        
        titleLabel.anchor(top: IconImage.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0))
         titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
         subTitleLabel.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
         subTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
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
    let SignInButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("log In", for: .normal)
        button.frame.size = CGSize(width: 80, height: 100)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: ""), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(SignInButtonAction), for: .touchUpInside)
        return button
    }()
    let titleLabel : UILabel = {
        var label = UILabel()
        label.text = "Welcome Back!"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        //   label.backgroundColor = UIColor.gray
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
    }()
    let subTitleLabel : UILabel = {
        var label = UILabel()
        label.text = "Login to continue using Ambulance"
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
    let LogInLabel : UILabel = {
        var label = UILabel()
        label.text = "Signin"
        label.tintColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        //  label.font = UIFont (name: "Rockwell-Bold", size: 30)
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
        tx.clearButtonMode = UITextField.ViewMode.never
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        tx.rightViewMode = .always
        tx.isSecureTextEntry = true
        return tx
    }()
}

