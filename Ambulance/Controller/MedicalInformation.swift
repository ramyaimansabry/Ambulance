
import UIKit
import Firebase
import SCLAlertView
import SVProgressHUD
import SkyFloatingLabelTextField


class MedicalInformation: UIViewController,UITextViewDelegate ,UIPickerViewDelegate, UIPickerViewDataSource{
    private var datePicker: UIDatePicker?
    private var pickerView1: UIPickerView?
    private var pickerView2: UIPickerView?
    private let dataSource1 = ["Not Set","A+","A-","B+","B-","AB+","AB-","O+","O-"]
    private let dataSource2 = ["Not Set","Female","Male","Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
        
        
        setupViews()
        SetupPickerViewsForTextFields()
        DateOfBirthTextFieldPickerView()
    }
  
    
    // MARK :-  Main Methods
    /********************************************************************************************/
    @objc func updateUserInfo(){
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
          
            UserDefaults.standard.set(true, forKey: "AddMedicalInfo")
            UserDefaults.standard.synchronize()
            let homeController = HomeVC()
            let HomeNavigationController = UINavigationController(rootViewController: homeController)
            HomeNavigationController.navigationController?.isNavigationBarHidden = true
            self.present(HomeNavigationController, animated: true, completion: nil)
        })
    }
    

    
    
    @objc func SaveButtonAction(){
            checkEmptyFields()
    }
    func dismissRingIndecator(){
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            SVProgressHUD.setDefaultMaskType(.none)
        }
    }
    func checkEmptyFields(){
        guard let _ = WeightTextField.text,  !(WeightTextField.text?.isEmpty)! else {
            SCLAlertView().showError("Error", subTitle: "Enter your Weight!")
            return
        }
        guard let _ = HeightTextField.text,  !(HeightTextField.text?.isEmpty)! else {
            SCLAlertView().showError("Error", subTitle: "Enter your Height!")
            return
        }
        guard let _ = SexTextField.text,  !(SexTextField.text?.isEmpty)! else {
            SCLAlertView().showError("Error", subTitle: "Sex is Empty!")
            return
        }
        guard let _ = BloodTypeField.text,  !(BloodTypeField.text?.isEmpty)! else {
            SCLAlertView().showError("Error", subTitle: "Enter Blood Type, or Select 'not set'!")
            return
        }
        guard let _ = DateOfBirthTextField.text,  !(DateOfBirthTextField.text?.isEmpty)! else {
            SCLAlertView().showError("Error", subTitle: "Enter your Date of Birth!")
            return
        }
        guard let _ = DiseasesTextView.text,  !(DiseasesTextView.text?.isEmpty)! else {
            SCLAlertView().showError("Error", subTitle: "Please, Fill all Fields!")
            return
        }
        guard let _ = SurgeryTextView.text,  !(SurgeryTextView.text?.isEmpty)! else {
            SCLAlertView().showError("Error", subTitle: "Please, Fill all Fields!")
            return
        }
        guard let _ = NotesTextView.text,  !(NotesTextView.text?.isEmpty)! else {
            SCLAlertView().showError("Error", subTitle: "Please, Fill all Fields!")
            return
        }
        
        
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Agree", target: self, selector: #selector(updateUserInfo))
        alertView.addButton("disagree") {    }
        alertView.showWarning("Warning", subTitle: "All your information saved in external database, that can be viewed by the admin, Agree?")
        
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
 
    //    MARK:- PickerView Methods
    /**********************************************************************************************/
    @objc func DateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        DateOfBirthTextField.text = dateFormatter.string(from: datePicker.date)
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
        }
        else if pickerView == pickerView2{
            SexTextField.text = dataSource2[pickerView2!.selectedRow(inComponent: 0)]
        }
    }
    
    
    //   MARK :- Constrains
    /**********************************************************************************************/
    private func setupViews(){
  
        view.addSubview(scrollView)
        view.addSubview(stackView1)
        view.addSubview(stackView4)
        view.addSubview(stackView5)
        
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
        
        stackView1.addArrangedSubview(LogInLabel)
        stackView1.addArrangedSubview(IconImage)
        stackView1.addArrangedSubview(titleLabel)
        
        
        stackView4.addArrangedSubview(stackView1)
        stackView4.addArrangedSubview(scrollView)
        stackView4.addArrangedSubview(SaveButtonn)
        
        stackView4.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 10, right: 0))
        
   
        stackView1.anchor(top: nil, leading: nil, bottom: nil, trailing: nil,size: CGSize(width: 0, height: stackView4.frame.height/6))
        
        
        scrollView.anchor(top: stackView1.bottomAnchor, leading: stackView4.leadingAnchor, bottom: SaveButtonn.topAnchor, trailing: stackView4.trailingAnchor, padding: .init(top: 15, left: 20, bottom: 15, right: 20))
        
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
        
        
          SaveButtonn.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30),size: CGSize(width: 0, height: 50))
        
    }
    // MARK :-  Setup Component
    /********************************************************************************************/
    

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
        label.numberOfLines = 0
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
        label.numberOfLines = 0
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
        label.numberOfLines = 0
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
        tx.tintColor = UIColor.newRed() // the color of the blinking cursor
        tx.textColor = UIColor.black
        tx.lineColor = UIColor.lightGray
        tx.selectedTitleColor = UIColor.newRed()
        tx.selectedLineColor = UIColor.newRed()
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
        tx.tintColor = UIColor.newRed() // the color of the blinking cursor
        tx.textColor = UIColor.black
        tx.lineColor = UIColor.lightGray
        tx.selectedTitleColor = UIColor.newRed()
        tx.selectedLineColor = UIColor.newRed()
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
        tx.tintColor = UIColor.newRed() // the color of the blinking cursor
        tx.textColor = UIColor.black
        tx.lineColor = UIColor.lightGray
        tx.selectedTitleColor = UIColor.newRed()
        tx.selectedLineColor = UIColor.newRed()
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
        tx.tintColor = UIColor.newRed() // the color of the blinking cursor
        tx.textColor = UIColor.black
        tx.lineColor = UIColor.lightGray
        tx.selectedTitleColor = UIColor.newRed()
        tx.selectedLineColor = UIColor.newRed()
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
        tx.placeholder = "Gender"
        tx.title = "Gender"
        tx.lineHeight = 1.0
        tx.selectedLineHeight = 2.0
        tx.tintColor = UIColor.newRed() // the color of the blinking cursor
        tx.textColor = UIColor.black
        tx.lineColor = UIColor.lightGray
        tx.selectedTitleColor = UIColor.newRed()
        tx.selectedLineColor = UIColor.newRed()
        tx.font = UIFont(name: "FontAwesome", size: 15)
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.default
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let SaveButtonn: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Save", for: .normal)
        button.frame.size = CGSize(width: 80, height: 100)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.newRed()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: ""), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(SaveButtonAction), for: .touchUpInside)
        return button
    }()
    let IconImage : UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "MedicalICON")
        image.layer.cornerRadius = 1
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    let LogInLabel : UILabel = {
        var label = UILabel()
        label.text = "Medical Information"
        label.tintColor = UIColor.black
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 27)
        //  label.font = UIFont (name: "Rockwell-Bold", size: 30)
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    let titleLabel : UILabel = {
        var label = UILabel()
        label.text = "We need some of your medical information in order to help you in emergency!"
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
    }()


    
    
}

