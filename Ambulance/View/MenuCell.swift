//
//  MenuCell.swift
//  Ambulance
//
//  Created by Ramy on 12/9/18.
//  Copyright © 2018 Ramy. All rights reserved.
//

import UIKit


class MenuCell: UICollectionViewCell{
    override var isHighlighted: Bool {
        didSet{
            if isHighlighted {
                backgroundColor = UIColor.lightGray
            }else{
                backgroundColor = UIColor.white
            }
        }
    }
    
    
    var row: Row? {
        didSet{
            guard let row = row else{
                return
            }
            imageView.image = UIImage(named: row.imageName)
            labelTitle.text = "\(row.title)"
        }
        
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    func setupViews(){
      //  addSubview(imageView)
       // addSubview(labelTitle)
      //  addSubview(lineSeparatorView)
        
        addSubview(stackView5)
        addSubview(stackView4)
        
        
        stackView5.addArrangedSubview(imageView)
        stackView5.addArrangedSubview(labelTitle)
    
        stackView4.addArrangedSubview(stackView5)
        stackView4.addArrangedSubview(lineSeparatorView)
        
        
        stackView4.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        
        
        
        stackView5.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor)
        
        
        
        imageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 25, height: 25))
        

        
    }
    let stackView4: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.fillProportionally
        sv.alignment = UIStackView.Alignment.center
        sv.spacing  = 0
        return sv
    }()
    
    let stackView5: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.horizontal
        sv.distribution  = UIStackView.Distribution.fillProportionally
        sv.alignment = UIStackView.Alignment.center
        sv.spacing  = 20
        return sv
    }()
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.clear
        iv.image = UIImage(named: "Page1")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let labelTitle: UILabel = {
        let titleL = UILabel()
        titleL.text = "My Profile"
        titleL.numberOfLines = 0
        titleL.font = UIFont.systemFont(ofSize: 16)
        titleL.textColor = UIColor.black
        titleL.textAlignment = .left
        return titleL
    }()
    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

