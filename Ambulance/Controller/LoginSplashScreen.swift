
import UIKit
import NVActivityIndicatorView

class LoginSplashScreen: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupConstrains()
    }
    // MARK :-   Main Methods
    /********************************************************************************************/
    @objc func SignInButtonAction(sender: UIButton!) {
        let AddNewviewController = SignInController()
        present(AddNewviewController, animated: true, completion: nil)
    }
    @objc func SignUpButtonAction(sender: UIButton!) {
        let SignUp = SignUpController()
        let SignUpNavigationController = UINavigationController(rootViewController: SignUp)
        self.present(SignUpNavigationController, animated: true, completion: nil)
        let AddNewviewController = SignUpController()
        present(AddNewviewController, animated: true, completion: nil)
    }
    
    // MARK :-  Setup Component
    /********************************************************************************************/
    let TitleLabel : UILabel = {
        var label = UILabel()
        label.text = "Welcome To Ambulance"
        label.tintColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.backgroundColor = UIColor.white
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
    let SignInButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Log In", for: .normal)
        button.frame.size = CGSize(width: 80, height: 100)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitleColor(UIColor.red, for: .normal)
        button.setBackgroundImage(UIImage(named: ""), for: .normal)
        button.addTarget(self, action: #selector(SignInButtonAction), for: .touchUpInside)
        return button
    }()
    let SignUpButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.frame.size = CGSize(width: 80, height: 100)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitleColor(UIColor.red, for: .normal)
        button.setBackgroundImage(UIImage(named: ""), for: .normal)
        button.addTarget(self, action: #selector(SignUpButtonAction), for: .touchUpInside)
        return button
    }()
    
   
    //   MARK :- Constrains
    /**********************************************************************************************/
    private func setupConstrains(){
        
        view.addSubview(SignInButton)
        view.addSubview(SignUpButton)
        view.addSubview(TitleLabel)
        view.addSubview(IconImage)
        
        SignUpButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 20, right: 15),size: CGSize(width: 0, height: 50))
        
        SignInButton.anchor(top: nil, leading: view.leadingAnchor, bottom: SignUpButton.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 15, right: 15),size: CGSize(width: 0, height: 50))
        
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        TitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        TitleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    
        IconImage.anchor(top: nil, leading: view.leadingAnchor, bottom: TitleLabel.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 50, right: 15),size: CGSize(width: 110, height: 110))
        
    }
    
    
}

