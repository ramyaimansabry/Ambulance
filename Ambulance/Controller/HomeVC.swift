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

class HomeVC: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate, NVActivityIndicatorViewable{
  let locationManager = CLLocationManager()
    let ViewOne = UIView()
    let ViewTwo = UIView()
    let ViewThree = UIView()
    var RequestEmergencyCounter: Int = 1
    var numberOfPatients: Int = 1
    var requestOwner: Bool = false
    var selectedEmergencyType: String = "Accident"
    var centerLocation: CLLocation?
    var buttons: [UIButton]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        
        // if user not logged in
            if Auth.auth().currentUser?.uid == nil {
                perform(#selector(handleLogout), with: nil, afterDelay: 0)
            }
        SetupComponentDelegetes()
        setupConstrains()
        SetupLoadingActivity()
        checkLocationServices()
        buttons = [ButtonInfo1, ButtonInfo2, ButtonInfo3, ButtonInfo4, ButtonInfo5, ButtonInfo6]
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
        
        var EmergencyForOwnerId = ""
        if requestOwner {
            EmergencyForOwnerId = "Yes"
        }else{
             EmergencyForOwnerId = "No"
        }
        guard let EmergencyLocation = centerLocation else{
            print("Cant get location")
            return
        }
        let Longitude: String = String(EmergencyLocation.coordinate.longitude)
        let Latitude: String = String(EmergencyLocation.coordinate.latitude)
        let userID = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference()
        let usersReference = ref.child("waiting Emergencies").child(userID)
        
        let values = ["Patients Number": String(numberOfPatients),"Emergency Type": selectedEmergencyType, "Emergency For Owner?": EmergencyForOwnerId,"User Latitude": Latitude, "User Longitude": Longitude, "Accepted by?": "NONE"]
        usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                let showError:String = error?.localizedDescription ?? ""
                SCLAlertView().showError("Error", subTitle: showError)
                return
            }
            //  success ..
            print("******************** User Requested Emergency Sucessfully ********************")
            self.startAnimating()
            self.readIfEmergencyAccepted()
        })
        
    }
    
    func readIfEmergencyAccepted(){
          let userID = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference().child("waiting Emergencies").child(userID).child("Accepted by?")
        ref.observe(.value, with: { (snapshot) in
            print(snapshot)
        }, withCancel: nil)
    }
    @objc func MenuButtonAction(){
        // menu stuff
        
        
        
    }
    @objc func CallAmbulanceButtonAction(sender: UIButton!) {
        switch RequestEmergencyCounter {
        case 0:
            break
        case 1:
            CallAmbulanceButton.setTitle("Next", for: .normal)
            showViewInfoOne()
           // show1()
            RequestEmergencyCounter += 1
            break
        case 2:
            CallAmbulanceButton.setTitle("Next", for: .normal)
            handleViewInfoOneDismiss()
           // hide1()
            showViewInfoTwo()
            RequestEmergencyCounter += 1
            break
        case 3:
            CallAmbulanceButton.setTitle("Request", for: .normal)
            handleViewInfoTwoDismiss()
             showViewInfoThree()
            RequestEmergencyCounter += 1
            break
        case 4:
            // save to database and return every thing to start
             handleViewInfoThreeDismiss()
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
        numberOfPatients = 1
        selectedEmergencyType = "Accident"
        ButtonInfoThree2.backgroundColor = UIColor.red
        ButtonInfoThree2.setTitleColor(UIColor.white, for: .normal)
        ButtonInfoThree1.backgroundColor = UIColor.white
        ButtonInfoThree1.setTitleColor(UIColor.gray, for: .normal)
        requestOwner = false
        
        buttons?.forEach { $0.isSelected = false }
        ButtonInfo2.isSelected = true
        
        NumberLabel.text = String(numberOfPatients)
        
        
        // hide the two views....
    }
    
    
    
    
    // tests
    
    
    
//    lazy var firstView : ViewInfoOne = {
//        let v1 = ViewInfoOne(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
//         v1.alpha = 0
//         v1.backgroundColor = UIColor.white
//         v1.layer.cornerRadius = 10
//        return v1
//    }()
//
//    func show1(){
//        view.addSubview(firstView)
//        UIView.animate(withDuration: 0.5, animations: {
//            self.firstView.alpha = 1
//
//
//            self.firstView.anchor(top: nil, leading: self.view.leadingAnchor, bottom: self.CallAmbulanceButton.topAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20),size: CGSize(width: 0, height: 150))
//        })
//
//
//
//    }
//    func hide1(){
//
//        UIView.animate(withDuration: 0.5) {
//            self.firstView.alpha = 0
//        }
//
//    }
//
    
     
    
    
    
    
    
    
    
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
    

    
    
    
    
    
    //   MARK :- Views Setup
    //**************************************************************************************************
    

    func handleViewInfoOneDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.ViewOne.alpha = 0
        }
    }
    
    func handleViewInfoTwoDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.ViewTwo.alpha = 0
        }
    }
    func handleViewInfoThreeDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.ViewThree.alpha = 0
        }
    }
    
    func showViewInfoOne(){
        ViewOne.backgroundColor = UIColor.white
        view.addSubview(ViewOne)
        ViewOne.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        ViewOne.layer.cornerRadius = 10
        setupViewOneConstrains()
        ViewOne.alpha = 0

        UIView.animate(withDuration: 0.5, animations: {
            self.ViewOne.alpha = 1
            self.ViewOne.anchor(top: nil, leading: self.view.leadingAnchor, bottom: self.CallAmbulanceButton.topAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20),size: CGSize(width: 0, height: 150))
        })
    }
    func showViewInfoTwo(){
        ViewTwo.backgroundColor = UIColor.white
        view.addSubview(ViewTwo)
        ViewTwo.frame = CGRect(x: 0, y: 0, width: view.frame.width-40, height: 330)
        ViewTwo.layer.cornerRadius = 10
        setupViewTwoConstrains()
        ViewTwo.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.ViewTwo.alpha = 1
            self.ViewTwo.anchor(top: nil, leading: self.view.leadingAnchor, bottom: self.CallAmbulanceButton.topAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20),size: CGSize(width: 0, height: 330))
        })
    }
    func showViewInfoThree(){
        ViewThree.backgroundColor = UIColor.white
        view.addSubview(ViewThree)
        ViewThree.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        ViewThree.layer.cornerRadius = 10
        setupViewThreeConstrains()
        ViewThree.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.ViewThree.alpha = 1
            self.ViewThree.anchor(top: nil, leading: self.view.leadingAnchor, bottom: self.CallAmbulanceButton.topAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20),size: CGSize(width: 0, height: 150))
        })
    }
    
    
    
    
   
     //   MARK: - View One
/****************************************************************************************************/
    @objc func PlusButtonAction(){
        if numberOfPatients < 10 {
            numberOfPatients += 1
            NumberLabel.text = String(numberOfPatients)
        }
    }
    @objc func MinusButtonAction(){
        if numberOfPatients > 1 {
            numberOfPatients -= 1
            NumberLabel.text = String(numberOfPatients)
        }
    }

    let PlusButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "PlusICON"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(PlusButtonAction), for: .touchUpInside)
        return button
    }()
    let MinusButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "MinusICON"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(MinusButtonAction), for: .touchUpInside)
        return button
    }()
    let NumberLabel : UILabel = {
        var label = UILabel()
        label.text = "1"
        label.tintColor = UIColor.red
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textColor = UIColor.red
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    let subTitleLabel : UILabel = {
        var label = UILabel()
        label.text = "Choose number of patients"
        label.font = UIFont.systemFont(ofSize: 16)
        //   label.backgroundColor = UIColor.gray
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    let CircleImage : UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "CircleICON2")
        image.layer.cornerRadius = 1
        image.backgroundColor = UIColor.clear
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()

    
    // MARK: - View Two
    /*******************************************************************************************************/
    @objc func EmergencyTypeButtonTapped(sender:UIButton){
        buttons?.forEach { $0.isSelected = false }
        sender.isSelected = true
        
        switch sender.tag
        {
        case 1:
            selectedEmergencyType = "Pregnent"
            break
        case 2:
            selectedEmergencyType = "Accident"
            break
        case 3:
            selectedEmergencyType = "Fire"
            break
        case 4:
            selectedEmergencyType = "Else"
            break
        case 5:
            selectedEmergencyType = "Head Injury"
            break
        case 6:
            selectedEmergencyType = "Heart Attack"
            break
        default:
            break
        }
    }
    
    let TitleButtonInfo1 : UILabel = {
        var label = UILabel()
        label.text = "Pregnency"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    let TitleButtonInfo2 : UILabel = {
        var label = UILabel()
        label.text = "Accident"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    let TitleButtonInfo3 : UILabel = {
        var label = UILabel()
        label.text = "Fire"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    let TitleButtonInfo4 : UILabel = {
        var label = UILabel()
        label.text = "Else"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    let TitleButtonInfo5 : UILabel = {
        var label = UILabel()
        label.text = "Head Injury"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    let TitleButtonInfo6 : UILabel = {
        var label = UILabel()
        label.text = "Heart Attack"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    let InfoTwoTitle : UILabel = {
        var label = UILabel()
        label.text = "Choose Emergency Type"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()
    let ButtonInfo1: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "PregnantNotSelected"), for: .normal)
        button.setBackgroundImage(UIImage(named: "PregnantICON"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 1
        button.addTarget(self, action: #selector(EmergencyTypeButtonTapped), for: .touchUpInside)
        return button
    }()
    let ButtonInfo2: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.isSelected = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "AccidentNotSelected"), for: .normal)
        button.setBackgroundImage(UIImage(named: "CrashedICON"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 2
        button.addTarget(self, action: #selector(EmergencyTypeButtonTapped), for: .touchUpInside)
        return button
    }()
    let ButtonInfo3: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "FireNotSelected"), for: .normal)
        button.setBackgroundImage(UIImage(named: "FireICON"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 3
        button.addTarget(self, action: #selector(EmergencyTypeButtonTapped), for: .touchUpInside)
        return button
    }()
    let ButtonInfo4: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "ElseNotSelected"), for: .normal)
        button.setBackgroundImage(UIImage(named: "ElseICON"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 4
        button.addTarget(self, action: #selector(EmergencyTypeButtonTapped), for: .touchUpInside)
        return button
    }()
    let ButtonInfo5: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "HeadInjuryNotSelected"), for: .normal)
        button.setBackgroundImage(UIImage(named: "HeadInjuryICON"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 5
        button.addTarget(self, action: #selector(EmergencyTypeButtonTapped), for: .touchUpInside)
        return button
    }()
    let ButtonInfo6: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "HeartAttackNotSelected"), for: .normal)
        button.setBackgroundImage(UIImage(named: "HeartAttackICON"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 6
        button.addTarget(self, action: #selector(EmergencyTypeButtonTapped), for: .touchUpInside)
        return button
    }()
    let subTitleInfoLabel : UILabel = {
        var label = UILabel()
        label.text = "Select Emergency Type"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
   
    
    
    
    // MARK: - View Three
    /********************************************************************************************************/
    
    @objc func  ButtonInfoThreeTapped(sender: UIButton!){
        switch sender {
        case ButtonInfoThree1:
            ButtonInfoThree1.backgroundColor = UIColor.red
            ButtonInfoThree1.setTitleColor(UIColor.white, for: .normal)
            ButtonInfoThree2.backgroundColor = UIColor.white
            ButtonInfoThree2.setTitleColor(UIColor.gray, for: .normal)
            requestOwner = true
            break
        case ButtonInfoThree2:
            ButtonInfoThree2.backgroundColor = UIColor.red
            ButtonInfoThree2.setTitleColor(UIColor.white, for: .normal)
            ButtonInfoThree1.backgroundColor = UIColor.white
            ButtonInfoThree1.setTitleColor(UIColor.gray, for: .normal)
            requestOwner = false
            break
        default:
            break
        }
    }
    
    let ButtonInfoThree1: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Yes", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = button.frame.width
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.gray, for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(ButtonInfoThreeTapped), for: .touchUpInside)
        return button
    }()
    let ButtonInfoThree2: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("No", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = button.frame.width
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(ButtonInfoThreeTapped), for: .touchUpInside)
        return button
    }()
    let InfoThreeTitle : UILabel = {
        var label = UILabel()
        label.text = "Emergency For You ?"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()
    

    
    
    
    //   MARK :- Constrains
    /**********************************************************************************************/
    private func setupViewOneConstrains(){
        [NumberLabel,PlusButton,MinusButton,subTitleLabel,CircleImage].forEach { ViewOne.addSubview($0) }
        NumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NumberLabel.centerXAnchor.constraint(equalTo: self.ViewOne.centerXAnchor).isActive = true
        NumberLabel.centerYAnchor.constraint(equalTo: self.ViewOne.centerYAnchor).isActive = true

        PlusButton.anchor(top: nil, leading: NumberLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 50, bottom: 0, right: 0),size: CGSize(width: 40, height: 40))
        PlusButton.centerYAnchor.constraint(equalTo: self.ViewOne.centerYAnchor).isActive = true

        MinusButton.anchor(top: nil, leading: nil, bottom: nil, trailing: NumberLabel.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 50),size: CGSize(width: 40, height: 40))
        MinusButton.centerYAnchor.constraint(equalTo: self.ViewOne.centerYAnchor).isActive = true

        subTitleLabel.anchor(top: NumberLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 22, left: 0, bottom: 0, right: 50),size: CGSize(width: 0, height: 0))
        subTitleLabel.centerXAnchor.constraint(equalTo: self.ViewOne.centerXAnchor).isActive = true

        CircleImage.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 70, height: 70))
        CircleImage.centerXAnchor.constraint(equalTo: self.ViewOne.centerXAnchor).isActive = true
        CircleImage.centerYAnchor.constraint(equalTo: self.ViewOne.centerYAnchor).isActive = true
    }
    
    private func setupViewTwoConstrains(){
        [ButtonInfo1,ButtonInfo2, ButtonInfo3, ButtonInfo4, ButtonInfo5, ButtonInfo6].forEach { ViewTwo.addSubview($0) }
    [TitleButtonInfo1,TitleButtonInfo2,TitleButtonInfo3,TitleButtonInfo4,TitleButtonInfo5,TitleButtonInfo6,InfoTwoTitle].forEach { ViewTwo.addSubview($0) }
        
        var width = (ViewTwo.frame.width-40)/3
        width = width/1.8
        
        ButtonInfo1.anchor(top: ViewTwo.topAnchor, leading: ButtonInfo2.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 25, left: 50, bottom: 0, right: 0),size: CGSize(width: width, height: width))
        TitleButtonInfo1.anchor(top: ButtonInfo1.bottomAnchor, leading: ButtonInfo1.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        
        ButtonInfo2.anchor(top: ViewTwo.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 25, left: 0, bottom: 0, right: 0),size: CGSize(width: width, height: width))
        ButtonInfo2.centerXAnchor.constraint(equalTo: self.ViewTwo.centerXAnchor).isActive = true
        TitleButtonInfo2.anchor(top: ButtonInfo2.bottomAnchor, leading: ButtonInfo2.leadingAnchor, bottom: nil, trailing: ButtonInfo2.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        ButtonInfo3.anchor(top: ViewTwo.topAnchor, leading: nil, bottom: nil, trailing: ButtonInfo2.leadingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 50),size: CGSize(width: width, height: width))
        TitleButtonInfo3.anchor(top: ButtonInfo3.bottomAnchor, leading: ButtonInfo3.leadingAnchor, bottom: nil, trailing: ButtonInfo3.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        
        ButtonInfo4.anchor(top: ButtonInfo1.bottomAnchor, leading: nil, bottom: nil, trailing: ButtonInfo1.trailingAnchor, padding: .init(top: 65, left: 0, bottom: 0, right: 0),size: CGSize(width: width, height: width))
        TitleButtonInfo4.anchor(top: ButtonInfo4.bottomAnchor, leading: ButtonInfo4.leadingAnchor, bottom: nil, trailing: ButtonInfo4.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        ButtonInfo5.anchor(top: ButtonInfo2.bottomAnchor, leading: nil, bottom: nil, trailing: ButtonInfo2.trailingAnchor, padding: .init(top: 65, left: 0, bottom: 0, right: 0),size: CGSize(width: width, height: width))
        TitleButtonInfo5.anchor(top: ButtonInfo5.bottomAnchor, leading: ButtonInfo5.leadingAnchor, bottom: nil, trailing: ButtonInfo5.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        
        ButtonInfo6.anchor(top: ButtonInfo3.bottomAnchor, leading: nil, bottom: nil, trailing: ButtonInfo3.trailingAnchor, padding: .init(top: 65, left: 0, bottom: 0, right: 0),size: CGSize(width: width, height: width))
        TitleButtonInfo6.anchor(top: ButtonInfo6.bottomAnchor, leading: ButtonInfo6.leadingAnchor, bottom: nil, trailing: ButtonInfo6.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        InfoTwoTitle.anchor(top: nil, leading: nil, bottom: ViewTwo.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 20, right: 0),size: CGSize(width: 0, height: 0))
        InfoTwoTitle.centerXAnchor.constraint(equalTo: self.ViewTwo.centerXAnchor).isActive = true
        
    }
    
    private func setupViewThreeConstrains(){
        [ButtonInfoThree1,ButtonInfoThree2,InfoThreeTitle].forEach { ViewThree.addSubview($0) }
        
        InfoThreeTitle.anchor(top: ViewThree.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        InfoThreeTitle.centerXAnchor.constraint(equalTo: self.ViewThree.centerXAnchor).isActive = true
        
        ButtonInfoThree1.anchor(top: InfoThreeTitle.bottomAnchor, leading: nil, bottom: nil, trailing: ViewThree.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 70),size: CGSize(width: 60, height: 60))
        
        ButtonInfoThree2.anchor(top: InfoThreeTitle.bottomAnchor, leading: ViewThree.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 70, bottom: 0, right: 0),size: CGSize(width: 60, height: 60))
        
    }
    
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
