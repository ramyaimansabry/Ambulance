
import UIKit


class ViewInfoOne: UIView {
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var numberOfPatients: Int = 1

        
//        func showViewInfoOne(){
//            backgroundColor = UIColor.white
           // view.addSubview(ViewOne)
//            ViewOne.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
//            ViewOne.layer.cornerRadius = 10
//        
//            ViewOne.alpha = 0
            
            
        
//        func handleViewInfoOneDismiss() {
//            UIView.animate(withDuration: 0.5) {
//                self.alpha = 0
//            }
//        }
//
     
  
        
        let PlusButton: UIButton = {
            let button = UIButton.init(type: .system)
            button.setTitle("", for: .normal)
            button.frame.size = CGSize(width: 25, height: 25)
            button.layer.cornerRadius = 5
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.white, for: .normal)
            button.setBackgroundImage(UIImage(named: "PlusICON"), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
         //   button.addTarget(self, action: Selector(("PlusButtonAction")), for: .touchUpInside)
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
         //   button.addTarget(self, action: #selector(MinusButtonAction), for: .touchUpInside)
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
        
        
        
      
        
        func PlusButtonAction(){
            if numberOfPatients < 10 {
                numberOfPatients += 1
                NumberLabel.text = String(numberOfPatients)
            }
        }
        func MinusButtonAction(){
            if numberOfPatients > 1 {
                numberOfPatients -= 1
                NumberLabel.text = String(numberOfPatients)
            }
        }
        
        
        
        
        [NumberLabel,PlusButton,MinusButton,subTitleLabel,CircleImage].forEach { addSubview($0) }
        NumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NumberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        NumberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        PlusButton.anchor(top: nil, leading: NumberLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 50, bottom: 0, right: 0),size: CGSize(width: 40, height: 40))
        PlusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        MinusButton.anchor(top: nil, leading: nil, bottom: nil, trailing: NumberLabel.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 50),size: CGSize(width: 40, height: 40))
        MinusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        subTitleLabel.anchor(top: NumberLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 22, left: 0, bottom: 0, right: 50),size: CGSize(width: 0, height: 0))
        subTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        CircleImage.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 70, height: 70))
        CircleImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        CircleImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


