

import UIKit
import Firebase
import SCLAlertView
import SVProgressHUD
import SkyFloatingLabelTextField
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
                print(error as Any)
                let showError:String = error?.localizedDescription ?? ""
                self.dismissRingIndecator()
                SCLAlertView().showError("Error", subTitle: showError)
                return
            }
            // suceess
           self.dismissRingIndecator()
            UserDefaults.standard.set(true, forKey: "IsLoggedIn")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(true, forKey: "AddMedicalInfo")
            UserDefaults.standard.synchronize()
            let homeController = HomeVC()
            let HomeNavigationController = UINavigationController(rootViewController: homeController)
            HomeNavigationController.navigationController?.isNavigationBarHidden = true
            self.present(HomeNavigationController, animated: true, completion: nil)
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
        view.addSubview(stackView1)
        view.addSubview(stackView2)
        view.addSubview(stackView3)
        view.addSubview(stackView4)
        
        stackView3.addArrangedSubview(EmailTextField)
        stackView3.addArrangedSubview(PasswordTextField)
        
        stackView2.addArrangedSubview(LogInLabel)
        stackView2.addArrangedSubview(IconImage)
        stackView2.addArrangedSubview(stackView1)
        
        stackView1.addArrangedSubview(titleLabel)
        stackView1.addArrangedSubview(subTitleLabel)
        
        stackView4.addArrangedSubview(stackView2)
        stackView4.addArrangedSubview(stackView3)
        stackView4.addArrangedSubview(SignInButton)
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 30, bottom: 0, right: 0),size: CGSize(width: 35, height: 35))
        
        
        stackView4.anchor(top: backButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 20, right: 0))
        
        
          stackView3.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30),size: CGSize(width: 0, height: 0))
        
            stackView2.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: stackView4.frame.height/3) )
        
        
        EmailTextField.anchor(top: nil, leading: stackView3.leadingAnchor, bottom: nil, trailing: stackView3.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        PasswordTextField.anchor(top: nil, leading: stackView3.leadingAnchor, bottom: nil, trailing: stackView3.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        
  SignInButton.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30),size: CGSize(width: 0, height: 50))
        
    }
    
    
    
    // MARK :-  Setup Component
    /********************************************************************************************/
    let stackView2: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.fill
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 20.0
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
        sv.distribution  = UIStackView.Distribution.fillEqually
        sv.alignment = UIStackView.Alignment.center
        sv.spacing = 15
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
        label.font = UIFont.boldSystemFont(ofSize: 18)
        //   label.backgroundColor = UIColor.gray
        label.textAlignment = .center
         label.numberOfLines = 0
        label.textColor = UIColor.gray
        return label
    }()
    let subTitleLabel : UILabel = {
        var label = UILabel()
        label.text = "Login to continue using Ambulance"
        label.font = UIFont.systemFont(ofSize: 14)
        //   label.backgroundColor = UIColor.gray
         label.numberOfLines = 0
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
         label.numberOfLines = 0
        label.tintColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.backgroundColor = UIColor.white
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
        tx.font = UIFont(name: "FontAwesome", size: 15)
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

