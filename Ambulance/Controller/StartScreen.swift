

import UIKit
import Firebase
class StartScreen: UINavigationController {
    
    func setupViews(){
        view.backgroundColor = UIColor.white
        navigationBar.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        
        // if user not logged in
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else if isLoggedIn() {
            let homeController = HomeVC()
            viewControllers = [homeController]
        }
       
        else {                                                            // 0.01
            perform(#selector(showLoginComponent), with: nil, afterDelay: 0.01)
        }
    }
    
    @objc func showLoginComponent(){
        let controller = LoginSplashScreen()
        present(controller, animated: true, completion: nil)
    }
    
    fileprivate func isLoggedIn() -> Bool {
        if UserDefaults.standard.bool(forKey: "IsLoggedIn"){
            return true
        }
        else {
            return false
        }
    }
    
    @objc func  handleLogout() {
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "IsLoggedIn")
            UserDefaults.standard.synchronize()
        }catch let logError{
            print(logError)
        }
        
        let AddNewviewController = LoginSplashScreen()
        present(AddNewviewController, animated: true, completion: nil)
        
    }
    
    
}

