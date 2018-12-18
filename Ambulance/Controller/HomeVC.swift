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
import GoogleMaps
// AIzaSyCLoZloFvbwIYIluj1gDNP3zg9teOHvR4Q

class HomeVC: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate, NVActivityIndicatorViewable{
  let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var RequestEmergencyCounter: Int = 1
    var driverPhoneNumber: String = "000"
    var isInEmergency: Bool = false
    var ResponserID = ""
    var centerLocation: CLLocationCoordinate2D?
    
    func SetupNavBar(){
          self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.white
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        SetupNavBar()
        
        SVProgressHUD.setForegroundColor(UIColor.red)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        
        // if user not logged in
            if Auth.auth().currentUser?.uid == nil {
                perform(#selector(handleLogout), with: nil, afterDelay: 0)
            }
    
         SetupLoadingActivity()
         mapSetup()
         checkLocationServices()
         setupConstrains()
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        if isInEmergency {
            fourthView.show()
        }
    }
    

    
    
    
    
    //   MARK :-  Main Methods
    /**********************************************************************************************/
    
    lazy var firstView: HomeVCViewInfoOne = {
        let vc = HomeVCViewInfoOne()
        return vc
    }()
    lazy var secandView: HomeVCViewInfoTwo = {
        let vc = HomeVCViewInfoTwo()
        return vc
    }()
    lazy var thirdView: HomeCVViewInfoThree = {
        let vc = HomeCVViewInfoThree()
        return vc
    }()
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
        
     
        guard let EmergencyLocation = centerLocation else {
            print("Cant get location")
            self.dismissRingIndecator()
            SCLAlertView().showError("Error", subTitle: "Cant get location")
              self.isInEmergency = false
            return
        }
        print(centerLocation?.longitude)
        print(centerLocation?.latitude)
        
          self.isInEmergency = true
        
        let Longitude: String = String(EmergencyLocation.longitude)
        let Latitude: String = String(EmergencyLocation.latitude)
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
            print("User Requested Emergency Sucessfully ")
            self.startAnimating()
            self.readIfEmergencyAccepted()
        })
        
    }
    
    
    func readIfEmergencyAccepted(){
        let userID = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference().child("waiting Emergencies").child(userID).child("AcceptedBy")
        
        ref.observe(.value, with: { (snapshot) in
            let answers: String = snapshot.value as! String
            
            
            _ = Timer.scheduledTimer(withTimeInterval: 15, repeats: false) {
                (_) in
                if !self.checkRequestTime(){
                     print("Time out")
                     ref.removeAllObservers()
                    self.handleTimeOut()
                    self.isInEmergency = false
                    return
                }else {
                   print("Emergency Accepted!!!!!")
                }
            }
          
            
             if answers != "NONE" {
                self.ResponserID = answers
                print(self.ResponserID)
                self.isInEmergency = true
    
                let ref2 = Database.database().reference().child("drivers").child(self.ResponserID).child("Phone")
                ref2.observe(.value, with: { (snapshot) in
                    self.driverPhoneNumber = snapshot.value as! String
                    print(self.driverPhoneNumber)
                   // ref2.removeAllObservers()
                }, withCancel: nil)
                
                
                        DispatchQueue.main.async {
                            self.stopAnimating()
                            self.fourthView.show()
                           // ref.removeAllObservers()
                        }
                     self.readResponserinformation()
                  }
        }, withCancel: nil)
    }

    
    let DriverLocation33 = Location()

    func readResponserinformation(){
        
         let userID = (Auth.auth().currentUser?.uid)!
        let ref2 = Database.database().reference().child("waiting Emergencies").child(userID).child("DriverLongitude")
       // ref2.keepSynced(true)
        ref2.observe(.value, with: { (snapshot) in
            if !snapshot.exists() { return }
            print("**********************")
            print(snapshot)
            print("**********************")
            
            
            guard let Dlongitude: String = snapshot.value as? String else {
                print("Errorrrrrr")
                return
            }
            
            let ref2 = Database.database().reference().child("waiting Emergencies").child(userID).child("DriverLatitude")
            // ref2.keepSynced(true)
            ref2.observe(.value, with: { (snapshot) in
                if !snapshot.exists() { return }
                print("**********************")
                print(snapshot)
                print("**********************")
                guard let Dlatitude: String = snapshot.value as? String else {
                    print("Errorrrrrr")
                    return
                }
                
                var currentLocation:CLLocationCoordinate2D!
                           currentLocation = CLLocationCoordinate2D(latitude: Dlatitude.toDouble() ?? 0.0, longitude: Dlongitude.toDouble() ?? 0.0)
                
                           self.getPolylineRoute(from: self.centerLocation!, to: currentLocation)
                
                  }, withCancel: nil)
            
            
            
            
//            if let Dlongitude: String = snapshot.childSnapshot(forPath: "DriverLongitude").value as? String {
//                print(Dlongitude)
//                self.DriverLocation33.Longitude = Dlongitude
//            }
//            if let Dlatitude: String = snapshot.childSnapshot(forPath: "DriverLatitude").value as? String {
//                print(Dlatitude)
//                self.DriverLocation33.Latitude = Dlatitude
//                print( self.DriverLocation33.Latitude,"+++++++++++++++++++++++++++++++")
//
//            }
//            print( self.DriverLocation33.Latitude,"+++++++++++++++++++++++++++++++")
//            print( self.DriverLocation33.Longitude,"+++++++++++++++++++++++++++++++")
//
//
//            var currentLocation:CLLocationCoordinate2D! //location object
//           currentLocation = CLLocationCoordinate2D(latitude: self.DriverLocation33.Latitude!.toDouble() ?? 0.0, longitude: self.DriverLocation33.Longitude!.toDouble() ?? 0.0)
//
//           self.getPolylineRoute(from: self.centerLocation!, to: currentLocation)

        }, withCancel: nil)
    }

    
    func checkRequestTime() -> Bool{
        if isInEmergency {
            return true
        }
        else{
            return false
        }
    }
    func handleTimeOut(){
        DispatchQueue.main.async {
            self.stopAnimating()
            self.setViewToDefault()
            self.MyLocationButtonAction()
            SCLAlertView().showError("Error", subTitle: "Request time out, try again!")
        }
        let userID = (Auth.auth().currentUser?.uid)!
        let ref2 = Database.database().reference().child("waiting Emergencies").child(userID)
        ref2.removeValue()
    }
    
    func callAcceptedDriver(){
        guard let number = URL(string: "tel://\(driverPhoneNumber)") else { return }
        UIApplication.shared.open(number)
         print("Call Driver Function Called", number)
    }
    @objc func MenuButtonAction(){
        // menu stuff
        setViewToDefault()
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
        if isInEmergency {
            fourthView.hideAndResetToDefualt()
        }
        let viewController = EditProfileController()
       navigationController?.pushViewController(viewController, animated: true)
    }
    func ShowMyMediicalInfoController(){
        if isInEmergency {
            fourthView.hideAndResetToDefualt()
        }
        let viewController = EditMedicalInfoController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    func logMeOut(){
        if isInEmergency {
            SCLAlertView().showError("Error", subTitle: "Your are calling emergency, Cant sign out!")
        }
        else {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("Logout", target: self, selector: #selector(handleLogout))
            alertView.addButton("Cancel") {    }
            alertView.showError("Warning!", subTitle: "Logout ?")
        }
    }
    
    func Call123(){
        guard let number = URL(string: "tel://123") else { return }
        UIApplication.shared.open(number)

    }
    
    func ShowSettingController(){
        if isInEmergency {
            fourthView.hideAndResetToDefualt()
        }
        let viewController = SettingController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    func share(message: String, link: String) {
        if let link = NSURL(string: link) {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    func ReferFriends(){
  
        
       share(message: "Hello we4 fa5da", link: "")
        
        
    }
    @objc func backButtonAction(){
        setViewToDefault()
        hideBackButton()
    }
    func showBackButton(){
       let yValue =  self.view.safeAreaInsets.top+20
        MenuButton.isEnabled = false
        MenuButton.isHidden = true
        view.addSubview(backButton)
        UIView.animate(withDuration: 0.3, animations: {
            self.backButton.alpha = 1
            self.backButton.frame = CGRect(x: 30, y: yValue, width: 40, height: 40)
        })
        
    }
    func hideBackButton(){
        MenuButton.isEnabled = true
        MenuButton.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.backButton.alpha = 0
            self.backButton.frame = CGRect(x: 30, y: 0, width: 40, height: 40)
        })
        
    }
    
    
    
    // ****************************************************************************************************************

    @objc func CallAmbulanceButtonAction(sender: UIButton!) {
        switch RequestEmergencyCounter {
        case 0:
            break
        case 1:
            CallAmbulanceButton.setTitle("Next", for: .normal)
            showBackButton()
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
            hideBackButton()
            callEmergencyOverDatabase()
            break
        default:
            break
        }
    }
    @objc func MyLocationButtonAction(){
        locationManager.startUpdatingLocation()
        guard let Lat = UserDefaults.standard.value(forKey: "LAT") as? CLLocationDegrees else{
            SCLAlertView().showError("Error", subTitle: "Cant get your location!")
            return
        }
        guard let Long = UserDefaults.standard.value(forKey: "LON") as? CLLocationDegrees else{
            SCLAlertView().showError("Error", subTitle: "Cant get your location!")
            return
        }
        
        
         let sourceCoordinate = CLLocation(latitude: Lat, longitude: Long)
        
     //   let sourceCoordinate =  CLLocation(latitude: UserDefaults.standard.value(forKey: "LAT") as! CLLocationDegrees, longitude: UserDefaults.standard.value(forKey: "LON") as! CLLocationDegrees)
        let camera = GMSCameraPosition.camera(withLatitude: sourceCoordinate.coordinate.latitude,
                                              longitude: sourceCoordinate.coordinate.longitude,
                                              zoom: 16.0)
        mapView.animate(to: camera)
    }
    
  
    func ShowMapCenteredPen(){
       // isChooseLocation = true
        view.addSubview(MapPinICON)
        MapPinICON.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.MapPinICON.alpha = 1
            self.MapPinICON.translatesAutoresizingMaskIntoConstraints = false
            let widthConstraint = NSLayoutConstraint(item: self.MapPinICON, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 55)
            let heightConstraint = NSLayoutConstraint(item: self.MapPinICON, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 55)
            let horizontalConstraint = NSLayoutConstraint(item: self.MapPinICON, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: self.MapPinICON, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: self.MapPinICON.frame.height/2)
            self.view.addConstraints([verticalConstraint,horizontalConstraint,widthConstraint,heightConstraint])

        })
    }
    
    func HideUnnecessaryView(){
        UIView.animate(withDuration: 0.5, animations: {
           // self.isChooseLocation = false
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
        HideUnnecessaryView()
        CallAmbulanceButton.setTitle("Request Ambulance", for: .normal)
      
        RequestEmergencyCounter = 1
        firstView.hideAndResetToDefualt()
        secandView.hideAndResetToDefualt()
        thirdView.hideAndResetToDefualt()
        
        if !isInEmergency {
            CallAmbulanceButton.isEnabled = true
            CallAmbulanceButton.isHidden = false
            MyLocationButtonAction()
        }
  
   }
    func dismissRingIndecator(){
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            SVProgressHUD.setDefaultMaskType(.none)
        }
    }
    
    
    // MARK: - Location Authurization
    /*******************************************************************************************/

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
    func mapSetup(){
        let zoomLevel: Float = 16.0
        let defaultLocation = CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357)
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.latitude,longitude: defaultLocation.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.isHidden = false
        mapView.settings.myLocationButton = false
        MyLocationButtonAction()
 
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            UserDefaults.standard.set(location.coordinate.latitude, forKey: "LAT")
            UserDefaults.standard.set(location.coordinate.longitude, forKey: "LON")
            UserDefaults().synchronize()
//            if !isChooseLocation {
//                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
//                                                      longitude: location.coordinate.longitude,
//                                                      zoom: 16.0)
//               mapView.animate(to: camera)
//            }
        }
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        centerLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
 
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        checkLocationAuthorization()
        SCLAlertView().showError("Error", subTitle: "Location Unavailable!")
    }
    
    // MARK: - Map Directions
    /**************************************************************************************************/
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        DispatchQueue.main.async {
            self.mapView.clear()
            let london = GMSMarker(position: source)
            london.title = "Emergency Location"
            london.icon = UIImage(named: "EmergencyLocation")
            london.map = self.mapView
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
     //   mapView.clear()
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&key=AIzaSyCLoZloFvbwIYIluj1gDNP3zg9teOHvR4Q")!
        print(url)
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                print("error")
            }
            else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        guard let routes = json["routes"] as? NSArray else {
                            DispatchQueue.main.async {
                            }
                            return
                        }
                        
                        if (routes.count > 0) {
                            let overview_polyline = routes[0] as? NSDictionary
                            let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                            
                            let points = dictPolyline?.object(forKey: "points") as? String
                            
                            
                            
                            DispatchQueue.main.async {
                                
                                self.showPath(polyStr: points!)
                                let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
                                let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 170, left: 30, bottom: 30, right: 30))
                                self.mapView!.moveCamera(update)
                                
                                
                                let london = GMSMarker(position: destination)
                                london.title = "Ambulance"
                                london.icon = UIImage(named: "AmbulanceLocation")
                                london.map = self.mapView
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                
                            }
                        }
                    }
                    
                }
                catch {
                    print("error in JSONSerialization")
                    DispatchQueue.main.async {
                        
                    }
                }
            }
        })
        task.resume()
    }
    
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        polyline.strokeColor = UIColor.red
        polyline.map = mapView // Your map view
    }

    
    
    // MARK: - Setup Constrains
    /**************************************************************************************************/
    private func setupConstrains(){
         [TitleLabel,CallAmbulanceButton,MenuButton,MyLocationButton].forEach { view.addSubview($0) }
    
        
        TitleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 30, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        TitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        CallAmbulanceButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 10, right: 20),size: CGSize(width: 0, height: 60))
        
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
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: ""), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(CallAmbulanceButtonAction), for: .touchUpInside)
        return button
    }()

    let TitleLabel : UILabel = {
        var label = UILabel()
        label.text = "Ambulance"
        label.tintColor = UIColor.red
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        return label
    }()
    let backButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 35, height: 35)
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "backICON"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isEnabled = true
        button.alpha = 0
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()
    let MapPinICON : UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "MapPin")
        image.layer.cornerRadius = 1
        image.backgroundColor = UIColor.clear
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
}
extension String
{
    /// EZSE: Converts String to Double
    public func toDouble() -> Double?
    {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
}


