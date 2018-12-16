//
//  MyProfileController.swift
//  Ambulance
//
//  Created by Ramy on 12/9/18.
//  Copyright © 2018 Ramy. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import SVProgressHUD
import SkyFloatingLabelTextField


class EditMedicalInfoController: UIViewController,UITextViewDelegate ,UIPickerViewDelegate, UIPickerViewDataSource{
    private var datePicker: UIDatePicker?
    private var pickerView1: UIPickerView?
    private var pickerView2: UIPickerView?
    private let dataSource1 = ["Not Set","A+","A-","B+","B-","AB+","AB-","O+","O-"]
    private let dataSource2 = ["Not Set","Female","Male","Other"]
        var changed: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupViews()
        setupViews()
        LoadUserInfo()
        AddtextfieldDelegete()
        SetupPickerViewsForTextFields()
        DateOfBirthTextFieldPickerView()
        EditModeOff()
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        changed = false
        EditModeOff()
    }
    
    // MARK :-  Main Methods
    /********************************************************************************************/

    @objc func textFieldDidChange(_ textField: UITextField) {
        changed = true
        SaveButtonn.isEnabled = true
    }
    func textViewDidChange(_ textView: UITextView) {
        changed = true
        SaveButtonn.isEnabled = true
    }
 
    
    
    func LoadUserInfo(){
        var fullName:String = ""
        let userID = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference().child("users").child(userID)
        ref.observe(.value, with: { (snapshot) in
            
            if !snapshot.exists() { return }
            
            if let name: String = snapshot.childSnapshot(forPath: "First Name").value as? String {
                DispatchQueue.main.async {
                    fullName = String(name)
                }
            }
            if let lastName: String = snapshot.childSnapshot(forPath: "Last Name").value as? String {
                DispatchQueue.main.async {
                    fullName.append(" \(String(lastName))")
                }
            }
            if let weight: String = snapshot.childSnapshot(forPath: "Weight").value as? String {
                DispatchQueue.main.async {
                    self.WeightTextField.text = String(weight)
                }
            }
            if let height: String = snapshot.childSnapshot(forPath: "Height").value as? String {
                DispatchQueue.main.async {
                    self.HeightTextField.text = String(height)
                }
            }
            if let date: String = snapshot.childSnapshot(forPath: "Date Of Birth").value as? String {
                DispatchQueue.main.async {
                    self.DateOfBirthTextField.text = String(date)
                }
            }
            
            if let blood: String = snapshot.childSnapshot(forPath: "Blood Type").value as? String {
                DispatchQueue.main.async {
                    self.BloodTypeField.text = String(blood)
                }
            }
            if let sex: String = snapshot.childSnapshot(forPath: "Sex").value as? String {
                DispatchQueue.main.async {
                    self.SexTextField.text = String(sex)
                }
            }
            if let diseases: String = snapshot.childSnapshot(forPath: "Any Diseases?").value as? String {
                DispatchQueue.main.async {
                    self.DiseasesTextView.text = String(diseases)
                }
            }
            if let surgery: String = snapshot.childSnapshot(forPath: "Had Surgery?").value as? String {
                DispatchQueue.main.async {
                    self.SurgeryTextView.text = String(surgery)
                }
            }
            if let notes: String = snapshot.childSnapshot(forPath: "Notes?").value as? String {
                DispatchQueue.main.async {
                    self.NotesTextView.text = String(notes)
                }
            }
            DispatchQueue.main.async {
                self.TitleLabel.text = fullName
            }
            
            
        }) { (error) in
            SCLAlertView().showError("Error", subTitle: error.localizedDescription)
        }
        
        
    }
    
    func updateUserInfo(){
        guard let weight = WeightTextField.text,let height = HeightTextField.text, let date = DateOfBirthTextField.text, let blood = BloodTypeField.text, let sex = SexTextField.text,let diseasses = DiseasesTextView.text,let surgery = SurgeryTextView.text, let notes = NotesTextView.text  else {
            print("Form is not valid")
            return
        }
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        let userID = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference().child("users").child(userID)

        let values = ["Weight": weight,"Height": height, "Date Of Birth": date, "Blood Type": blood, "Sex": sex, "Any Diseases?": diseasses,"Had Surgery?": surgery, "Notes?": notes]
        ref.updateChildValues(values, withCompletionBlock: { (error, ref) in

            if error != nil {
                let showError:String = error?.localizedDescription ?? ""
                SCLAlertView().showError("Error", subTitle: showError)
                return
            }

            // succeed ..
            self.dismissRingIndecator()
            SCLAlertView().showSuccess("Done", subTitle: "Info Saved Correctly")
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func AddtextfieldDelegete(){
        DiseasesTextView.delegate = self
        SurgeryTextView.delegate = self
        NotesTextView.delegate = self
        WeightTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        HeightTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        BloodTypeField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    
    @objc func SaveButtonAction(){
        if changed {
            checkEmptyFields()
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func CancelButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func backButtonAction(sender: UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    func dismissRingIndecator(){
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            SVProgressHUD.setDefaultMaskType(.none)
        }
    }
    func checkEmptyFields(){
        guard let weight = WeightTextField.text,  WeightTextField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Enter your Weight!")
            return
        }
        guard let height = HeightTextField.text,  HeightTextField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Enter your Height!")
            return
        }
        guard let sex = SexTextField.text,  SexTextField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Sex is Empty!")
            return
        }
        guard let blood = BloodTypeField.text,  BloodTypeField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Enter Blood Type, or Select 'not set'!")
            return
        }
        guard let date = DateOfBirthTextField.text,  DateOfBirthTextField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Enter your Date of Birth!")
            return
        }
        guard let diseases = DiseasesTextView.text,  DiseasesTextView.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Please, Fill all Fields!")
            return
        }
        guard let surgery = SurgeryTextView.text,  SurgeryTextView.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Please, Fill all Fields!")
            return
        }
        guard let notes = NotesTextView.text,  NotesTextView.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Please, Fill all Fields!")
            return
        }
    
        updateUserInfo()
    }
    
    @objc func EditButtonAction() {
        EditButton.isEnabled = false
        EditButton.isHidden = true
        EditModeOn()
        
    }
    
    func EditModeOn(){
        SaveButtonn.isEnabled = true
        WeightTextField.isEnabled = true
        HeightTextField.isEnabled = true
        DateOfBirthTextField.isEnabled = true
        BloodTypeField.isEnabled = true
        SexTextField.isEnabled = true
        DiseasesTextView.isUserInteractionEnabled = true
        SurgeryTextView.isUserInteractionEnabled = true
        NotesTextView.isUserInteractionEnabled = true
    }
    func EditModeOff(){
        EditButton.isEnabled = true
        EditButton.isHidden = false
        SaveButtonn.isEnabled = false
        
        WeightTextField.isEnabled = false
        HeightTextField.isEnabled = false
        DateOfBirthTextField.isEnabled = false
        BloodTypeField.isEnabled = false
        SexTextField.isEnabled = false
        DiseasesTextView.isUserInteractionEnabled = false
        SurgeryTextView.isUserInteractionEnabled = false
        NotesTextView.isUserInteractionEnabled = false
    }
    //    MARK:- PickerView Methods
    /**********************************************************************************************/
    @objc func DateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        DateOfBirthTextField.text = dateFormatter.string(from: datePicker.date)
        textFieldDidChange(DateOfBirthTextField)
    }
    func DateOfBirthTextFieldPickerView(){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        DateOfBirthTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(DateChanged(datePicker:)), for: .valueChanged)
    }
    func SetupPickerViewsForTextFields(){
        pickerView1 = UIPickerView()
        pickerView2 = UIPickerView()
        self.pickerView1?.delegate = self
        self.pickerView1!.dataSource = self
        self.pickerView2?.delegate = self
        self.pickerView2!.dataSource = self
        BloodTypeField.inputView = pickerView1
        SexTextField.inputView = pickerView2
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerView1 {
            return dataSource1.count
        }
        else if pickerView == pickerView2 {
            return dataSource2.count
        }
        else {
            return dataSource1.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView1 {
            return dataSource1[row]
        }
        if pickerView == pickerView2 {
            return dataSource2[row]
        }
        else {
            return dataSource1[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1{
            BloodTypeField.text = dataSource1[pickerView1!.selectedRow(inComponent: 0)]
            textFieldDidChange(BloodTypeField)
            
        }
        else if pickerView == pickerView2{
            SexTextField.text = dataSource2[pickerView2!.selectedRow(inComponent: 0)]
             textFieldDidChange(SexTextField)
        }
    }
    
    
    //   MARK :- Constrains
    /**********************************************************************************************/
    private func setupViews(){
        view.addSubview(backButton)
        view.addSubview(EditButton)
        view.addSubview(scrollView)
        view.addSubview(stackView1)
        view.addSubview(stackView2)
        view.addSubview(stackView3)
        view.addSubview(stackView4)
        view.addSubview(stackView5)
        view.addSubview(stackView7)
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 30, bottom: 0, right: 0),size: CGSize(width: 35, height: 35))
        
        EditButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 30),size: CGSize(width: 35, height: 35))
        
        stackView1.anchor(top: nil, leading: nil, bottom: nil, trailing: nil,size: CGSize(width: 0, height:stackView4.frame.height/6))

        stackView3.addArrangedSubview(CancelButton)
        stackView3.addArrangedSubview(SaveButtonn)
        
  
        stackView5.addArrangedSubview(WeightTextField)
         stackView5.addArrangedSubview(HeightTextField)
        
        stackView2.addArrangedSubview(stackView5)
        stackView2.addArrangedSubview(DateOfBirthTextField)
        stackView2.addArrangedSubview(BloodTypeField)
        stackView2.addArrangedSubview(SexTextField)
         stackView2.addArrangedSubview(FirstQuestionLabel)
          stackView2.addArrangedSubview(DiseasesTextView)
          stackView2.addArrangedSubview(SecandQuestionLabel)
          stackView2.addArrangedSubview(SurgeryTextView)
          stackView2.addArrangedSubview(ThirdQuestionLabel)
          stackView2.addArrangedSubview(NotesTextView)
        
        stackView7.addArrangedSubview(TitleLabel)
        
        stackView1.addArrangedSubview(IconImage)
        stackView1.addArrangedSubview(stackView7)
        
        
        stackView4.addArrangedSubview(stackView1)
         stackView4.addArrangedSubview(scrollView)
        stackView4.addArrangedSubview(stackView3)
        
        stackView4.anchor(top: backButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 10, right: 0))
        
    //    stackView2.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30))
        
        CancelButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 160, height: 35))
        SaveButtonn.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 160, height: 35))
        
        stackView3.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 50))
        
      scrollView.anchor(top: stackView1.bottomAnchor, leading: stackView4.leadingAnchor, bottom: stackView3.topAnchor, trailing: stackView4.trailingAnchor, padding: .init(top: 15, left: 20, bottom: 15, right: 20))
        
        scrollView.addSubview(stackView2)
        
        
        stackView2.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor)
     stackView2.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0).isActive = true
        
         stackView5.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
       BloodTypeField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 35))
    DateOfBirthTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 35))
    SexTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 35))
        
           FirstQuestionLabel.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
           DiseasesTextView.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 85))
        
        SecandQuestionLabel.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        SurgeryTextView.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 85))
        
        ThirdQuestionLabel.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        NotesTextView.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 85))
        
        IconImage.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 85, height: 85))
        
    }
    // MARK :-  Setup Component
    /********************************************************************************************/
    
    let stackView3: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.horizontal
        sv.distribution  = UIStackView.Distribution.fillEqually
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 30.0
        return sv
    }()
    let stackView2: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.equalCentering
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 15
        return sv
    }()
    let stackView1: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.equalSpacing
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 25.0
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
    let stackView7: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.equalSpacing
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 2.0
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
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.backgroundColor = UIColor.white
        v.isScrollEnabled = true
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentSize.height = 2000
        return v
    }()

    
    
    
    let FirstQuestionLabel : UILabel = {
        var label = UILabel()
        label.text = "Do you suffer from any diseases?"
        label.tintColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        return label
    }()
    let SecandQuestionLabel : UILabel = {
        var label = UILabel()
        label.text = "Do you had any surgery before?"
        label.tintColor = UIColor.black
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = UIColor.white
        label.textAlignment = .left
        return label
    }()
    let ThirdQuestionLabel : UILabel = {
        var label = UILabel()
        label.text = "Any notes about your overall health condition?"
        label.tintColor = UIColor.black
        label.backgroundColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        return label
    }()
    let DiseasesTextView: UITextView = {
        let tv = UITextView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tv.textAlignment = NSTextAlignment.justified
        tv.textColor = UIColor.black
        tv.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        tv.font =  UIFont.systemFont(ofSize: 15)
        tv.isEditable = true
        return tv
    }()
    let SurgeryTextView: UITextView = {
        // let tv = UITextView(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        let tv = UITextView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tv.textAlignment = NSTextAlignment.justified
        tv.textColor = UIColor.black
        tv.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        tv.font =  UIFont.systemFont(ofSize: 15)
        tv.isEditable = true
        return tv
    }()
    let NotesTextView: UITextView = {
        let tv = UITextView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tv.textAlignment = NSTextAlignment.justified
        tv.textColor = UIColor.black
        tv.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        tv.font =  UIFont.systemFont(ofSize: 15)
        tv.isEditable = true
        return tv
    }()
    let DateOfBirthTextField: SkyFloatingLabelTextField = {
        let tx = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Date of Birth"
        tx.title = "Date of Birth"
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
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let WeightTextField: SkyFloatingLabelTextField = {
        let tx = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Weight"
        tx.title = "Weight"
        tx.lineHeight = 1.0
        tx.selectedLineHeight = 2.0
        tx.tintColor = UIColor.red // the color of the blinking cursor
        tx.textColor = UIColor.black
        tx.lineColor = UIColor.lightGray
        tx.selectedTitleColor = UIColor.red
        tx.selectedLineColor = UIColor.red
        tx.font = UIFont(name: "FontAwesome", size: 15)
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.numberPad
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let HeightTextField: SkyFloatingLabelTextField = {
        let tx = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Height"
        tx.title = "Height"
        tx.lineHeight = 1.0
        tx.selectedLineHeight = 2.0
        tx.tintColor = UIColor.red // the color of the blinking cursor
        tx.textColor = UIColor.black
        tx.lineColor = UIColor.lightGray
        tx.selectedTitleColor = UIColor.red
        tx.selectedLineColor = UIColor.red
        tx.font = UIFont(name: "FontAwesome", size: 15)
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.numberPad
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.whileEditing
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let BloodTypeField: SkyFloatingLabelTextField = {
        let tx = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Blood Type"
        tx.title = "Blood Type"
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
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let SexTextField: SkyFloatingLabelTextField = {
        let tx = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Sex"
        tx.title = "Sex"
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
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()

    let CancelButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Cancel", for: .normal)
        // button.frame.size = CGSize(width: 100, height: 40)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(CancelButtonAction), for: .touchUpInside)
        return button
    }()
    let SaveButtonn: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Save", for: .normal)
        //     button.frame.size = CGSize(width: 100, height: 40)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isEnabled = false
        button.addTarget(self, action: #selector(SaveButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    
    let TitleLabel : UILabel = {
        var label = UILabel()
        label.text = "Error"
        label.tintColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let IconImage : UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "DefualtProfileImage")
        image.layer.cornerRadius = 1
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        return image
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
        button.isEnabled = true
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()
    let EditButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Edit", for: .normal)
        button.frame.size = CGSize(width: 35, height: 35)
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.blue, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(EditButtonAction), for: .touchUpInside)
        return button
    }()
    

}
