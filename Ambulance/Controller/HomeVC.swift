//
//  HomeVC.swift
//  Ambulance
//
//  Created by Ramy on 11/28/18.
//  Copyright © 2018 Ramy. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation
import AudioToolbox
import NVActivityIndicatorView
import SCLAlertView
import SVProgressHUD

class HomeVC: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate, NVActivityIndicatorViewable{
  let locationManager = CLLocationManager()
    let firstView = HomeVCViewInfoOne()
    let secandView = HomeVCViewInfoTwo()
    let thirdView = HomeCVViewInfoThree()
   // let fourthView = HomeVCInfoFour()
    
    var RequestEmergencyCounter: Int = 1
    var centerLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        SVProgressHUD.setForegroundColor(UIColor.red)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        
        // if user not logged in
            if Auth.auth().currentUser?.uid == nil {
                perform(#selector(handleLogout), with: nil, afterDelay: 0)
            }
        
        SetupComponentDelegetes()
        setupConstrains()
        SetupLoadingActivity()
         checkLocationServices()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    
    //   MARK :-  Main Methods
    /**********************************************************************************************/
    func callEmergencyOverDatabase(){
        SaveToDatabase()
    }
    
    func SaveToDatabase(){
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        
         let numberOfPatients = firstView.numberOfPatients
        let selectedEmergencyType = secandView.selectedEmergencyType
        
        var EmergencyForOwnerId = ""
        if thirdView.requestOwner {
            EmergencyForOwnerId = "Yes"
        }else{
             EmergencyForOwnerId = "No"
        }
        guard let EmergencyLocation = centerLocation else{
            print("Cant get location")
            self.dismissRingIndecator()
            SCLAlertView().showError("Error", subTitle: "Cant get location")
            return
        }
       
        
        let Longitude: String = String(EmergencyLocation.coordinate.longitude)
        let Latitude: String = String(EmergencyLocation.coordinate.latitude)
        let userID = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference()
        let usersReference = ref.child("waiting Emergencies").child(userID)
        let timeEmergency: String = String(NSDate().timeIntervalSince1970)
        
        let values = ["PatientsNumber": String(numberOfPatients),"EmergencyType": selectedEmergencyType, "EmergencyForOwner": EmergencyForOwnerId,"UserLatitude": Latitude, "UserLongitude": Longitude, "AcceptedBy": "NONE", "TimeCreated": timeEmergency, "FromId": String(userID)]
        usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                let showError:String = error?.localizedDescription ?? ""
                 self.dismissRingIndecator()
                SCLAlertView().showError("Error", subTitle: showError)
                return
            }
            //  success ..
            self.dismissRingIndecator()
            print("User Requested Emergency Sucessfully ***********************")
            self.startAnimating()
            self.readIfEmergencyAccepted()
        })
        
    }
    var ResponserID = ""
    var DriverLatitude: String =  ""
    var DriverLongitude: String =  ""
    func readIfEmergencyAccepted(){
        let userID = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference().child("waiting Emergencies").child(userID).child("AcceptedBy")
        ref.observe(.value, with: { (snapshot) in
            let answers: String = snapshot.value as! String
             if answers != "NONE" {
                self.ResponserID = answers
                print(self.ResponserID)
                DispatchQueue.main.async {
                    self.stopAnimating()
                    self.fourthView.show()
                    self.readResponserinformation()
                    return
                }
             }
            
        }, withCancel: nil)
    }
    func readResponserinformation(){
        let ref = Database.database().reference().child("drivers").child(ResponserID).child("Phone")
       ref.observe(.value, with: { (snapshot) in
        self.driverPhoneNumber = snapshot.value as! String
          print(self.driverPhoneNumber)
         }, withCancel: nil)
        
         let userID = (Auth.auth().currentUser?.uid)!
        let ref2 = Database.database().reference().child("waiting Emergencies").child(userID)
        ref2.observe(.value, with: { (snapshot) in
            if let Long: String = snapshot.childSnapshot(forPath: "DriverLongitude").value as? String {
                print(Long)
                DispatchQueue.main.async {
                  self.DriverLongitude = Long
                }
                
            }
            if let Lat: String = snapshot.childSnapshot(forPath: "DriverLatitude").value as? String {
                print(Lat)
                DispatchQueue.main.async {
                    self.DriverLatitude = Lat
                }
            }
            
        }, withCancel: nil)
        
        
    }
    var driverPhoneNumber: String = "000"
    func callAcceptedDriver(){
        print("Call Driver Function Called")
        guard let number = URL(string: "tel://\(driverPhoneNumber)") else { return }
        UIApplication.shared.open(number)
    }
    
    @objc func MenuButtonAction(){
        // menu stuff
        LeftMenu.show()
    }
    lazy var LeftMenu: LeftSideMenuController = {
        let vc = LeftSideMenuController()
        vc.homeController = self
        return vc
    }()
    lazy var fourthView: HomeVCInfoFour = {
        let vc = HomeVCInfoFour()
        vc.homeController = self
        return vc
    }()
    
    func ShowMyProfileViewController(){
        let viewController = EditProfileController()
       navigationController?.pushViewController(viewController, animated: true)
    }
    func ShowMyMediicalInfoController(){
        let viewController = EditMedicalInfoController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    func logMeOut(){
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Logout", target: self, selector: #selector(handleLogout))
        alertView.addButton("Cancel") {    }
        alertView.showError("Warning!", subTitle: "Logout ?")
    }
    
    func Call123(){
        guard let number = URL(string: "tel://123") else { return }
        UIApplication.shared.open(number)
        
//        let appearance = SCLAlertView.SCLAppearance(
//            showCloseButton: false
//        )
//        let alertView = SCLAlertView(appearance: appearance)
//        alertView.addButton("Call"){
//            guard let number = URL(string: "tel://123") else { return }
//            UIApplication.shared.open(number)
//        }
//        alertView.addButton("Cancel") {    }
//        alertView.showError("Warning!", subTitle: "Call 123 ?")
       
    }
    
    func ShowSettingController(){
        let viewController = SettingController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // ****************************************************************************************************************
    func hideAllRequestViews(){
        firstView.hide()
        secandView.hide()
        thirdView.hide()
    }
    @objc func CallAmbulanceButtonAction(sender: UIButton!) {
        switch RequestEmergencyCounter {
        case 0:
            break
        case 1:
            CallAmbulanceButton.setTitle("Next", for: .normal)
            firstView.show()
            RequestEmergencyCounter += 1
            break
        case 2:
            CallAmbulanceButton.setTitle("Next", for: .normal)
            firstView.hide()
            secandView.show()
            RequestEmergencyCounter += 1
            break
        case 3:
            CallAmbulanceButton.setTitle("Request", for: .normal)
             secandView.hide()
             thirdView.show()
            RequestEmergencyCounter += 1
            break
        case 4:
            // save to database and return every thing to start
             CallAmbulanceButton.setTitle("Confirm Request", for: .normal)
             thirdView.hide()
             ShowMapCenteredPen()
             RequestEmergencyCounter += 1
            break
        case 5:
            HideUnnecessaryView()
            print("Case 5 On button Executed")
            callEmergencyOverDatabase()
             //    setViewToDefault()
            break
        default:
            break
        }
    }
    @objc func MyLocationButtonAction(){
        locationManager.startUpdatingLocation()
        let sourceCoordinate =  CLLocation(latitude: UserDefaults.standard.value(forKey: "LAT") as! CLLocationDegrees, longitude: UserDefaults.standard.value(forKey: "LON") as! CLLocationDegrees)
        centerMapOnLocation(location: sourceCoordinate)
    }
    
  
    func ShowMapCenteredPen(){
        view.addSubview(MapPinICON)
        MapPinICON.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.MapPinICON.alpha = 1
            self.MapPinICON.translatesAutoresizingMaskIntoConstraints = false
            let widthConstraint = NSLayoutConstraint(item: self.MapPinICON, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 55)
            let heightConstraint = NSLayoutConstraint(item: self.MapPinICON, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 55)
            let horizontalConstraint = NSLayoutConstraint(item: self.MapPinICON, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: self.MapPinICON, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: -27.5)
            self.view.addConstraints([verticalConstraint,horizontalConstraint,widthConstraint,heightConstraint])
            
        })
    }
    
    func HideUnnecessaryView(){
        UIView.animate(withDuration: 0.5, animations: {
            self.MapPinICON.alpha = 0
        })
        CallAmbulanceButton.isEnabled = false
        CallAmbulanceButton.isHidden = true
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
    
    func SetupLoadingActivity(){
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleRippleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = UIColor.red
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 250, height: 250)
    }
    
    
    func setViewToDefault(){
        CallAmbulanceButton.setTitle("Request Ambulance", for: .normal)
        RequestEmergencyCounter = 1
        
   //     numberOfPatients = 1
  //      selectedEmergencyType = "Accident"
        
        
//        ButtonInfoThree2.backgroundColor = UIColor.red
//        ButtonInfoThree2.setTitleColor(UIColor.white, for: .normal)
//        ButtonInfoThree1.backgroundColor = UIColor.white
//        ButtonInfoThree1.setTitleColor(UIColor.gray, for: .normal)
//        requestOwner = false
        
       // buttons?.forEach { $0.isSelected = false }
        
        
        
     //   ButtonInfo2.isSelected = true
        
    //    NumberLabel.text = String(numberOfPatients)
        
        
        // hide the two views....
    }
    func dismissRingIndecator(){
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            SVProgressHUD.setDefaultMaskType(.none)
        }
    }
    
    
    // MARK: - Location Authurization
    /*******************************************************************************************/
    func SetupComponentDelegetes(){
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
    }
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }
        else{  }
    }
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            // do gps current location work
            locationManager.startUpdatingLocation()
            break
        case .denied:
            SCLAlertView().showError("Error", subTitle: "Location denied!, Check location permission")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            SCLAlertView().showError("Error", subTitle: "Location restricted!, Check location permission")
            break
        }
    }
    
    
    // MARK: - Location delegete
    /**************************************************************************************************/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            //  locationManager.stopUpdatingLocation()
            UserDefaults.standard.set(location.coordinate.latitude, forKey: "LAT")
            UserDefaults.standard.set(location.coordinate.longitude, forKey: "LON")
            UserDefaults().synchronize()
            let currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            centerMapOnLocation(location: currentLocation)
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        checkLocationAuthorization()
        SCLAlertView().showError("Error", subTitle: "Location Unavailable!")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        centerLocation = getCenteredLocation(for: mapView)
    }
    
    func getCenteredLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    

    // MARK: - Setup Constrains
    /**************************************************************************************************/
    private func setupConstrains(){
         [mapView,TitleLabel,CallAmbulanceButton,MenuButton,MyLocationButton].forEach { view.addSubview($0) }
        
        mapView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        TitleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 30, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        TitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        CallAmbulanceButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 5, right: 20),size: CGSize(width: 0, height: 60))
        
        MenuButton.anchor(top: TitleLabel.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 25, bottom: 0, right: 0),size: CGSize(width: 30, height: 30))
        
        MyLocationButton.anchor(top: TitleLabel.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 25),size: CGSize(width: 30, height: 30))
    }
    
    
    
    
    //   MARK :- Setup Component
    /**********************************************************************************************/
    let MenuButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "MenuICON"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(MenuButtonAction), for: .touchUpInside)
        return button
    }()
    let MyLocationButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "GPS-ICON"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(MyLocationButtonAction), for: .touchUpInside)
        return button
    }()
    let CallAmbulanceButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Request Ambulance", for: .normal)
        button.frame.size = CGSize(width: 80, height: 100)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: ""), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(CallAmbulanceButtonAction), for: .touchUpInside)
        return button
    }()
    let mapView: MKMapView = {
        let mv = MKMapView()
        mv.frame = CGRect(x: 20, y: 100, width: 250, height: 60)
        mv.mapType = .standard
        mv.isZoomEnabled = true
        mv.isScrollEnabled = true
        return mv
    }()
    let TitleLabel : UILabel = {
        var label = UILabel()
        label.text = "Ambulance"
        label.tintColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        return label
    }()
    let MapPinICON : UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "MapPin")
        image.layer.cornerRadius = 1
        image.backgroundColor = UIColor.clear
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
}
