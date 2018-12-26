
import UIKit

extension UIViewController {
    func openShareDilog(`with` viewController : UIViewController) {
        let text = "Try now #Ambulance app - the app that help you requesting ambulance in emergency!"
        
        // set up activity view controller
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
        
        viewController.present(activityViewController, animated: true, completion: nil)
        
    }
}
