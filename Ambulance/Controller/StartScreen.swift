

import UIKit
class StartScreen: UINavigationController {
    
    func setupViews(){
        view.backgroundColor = UIColor.white
        navigationBar.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        // MARK:- reemove later for onboarding screens
        // ***************************************************************************
        //        let homeController = CustomTabBarController()
        //        viewControllers = [homeController]
        
//        UserDefaults.standard.set(true, forKey: "IsLoggedIn")
//        UserDefaults.standard.synchronize()
        
        if isLoggedIn() {
            let homeController = HomeVC()
            viewControllers = [homeController]
        }else {                                                            // 0.01
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

