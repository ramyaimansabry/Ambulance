

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
         if isLoggedIn() {
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
 
}

