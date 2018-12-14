
import UIKit


class HomeVCViewInfoOne: NSObject {
    let ViewOne = UIView()
    var numberOfPatients: Int = 1
    override init() {
        super.init()
        setupConstrains()
        PlusButton.addTarget(self, action: #selector(PlusButtonAction), for: .touchUpInside)
        MinusButton.addTarget(self, action: #selector(MinusButtonAction), for: .touchUpInside)
    }
    
    func show(){
        if let window = UIApplication.shared.keyWindow {
           window.addSubview(ViewOne)
            
            ViewOne.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 200)
            ViewOne.backgroundColor = UIColor.white
            ViewOne.layer.cornerRadius = 10
            ViewOne.alpha = 0
            
            UIView.animate(withDuration: 0.5, animations: {
                self.ViewOne.alpha = 1
                self.ViewOne.anchor(top: nil, leading: window.leadingAnchor, bottom: window.safeAreaLayoutGuide.bottomAnchor, trailing: window.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 85, right: 20),size: CGSize(width: 0, height: 150))
            })
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5) {
            self.ViewOne.alpha = 0
        }
    }
    func hideAndResetToDefualt(){
        self.ViewOne.alpha = 0
            self.numberOfPatients = 1
            self.NumberLabel.text = String(self.numberOfPatients)
    }
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
    
    
    private func setupConstrains(){
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
    
    
    
    let PlusButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("", for: .normal)
        button.frame.size = CGSize(width: 25, height: 25)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "PlusICON"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
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

}


