//
//  PageCell.swift
//  Ambulance
//
//  Created by Ramy on 12/21/18.
//  Copyright © 2018 Ramy. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell{
    
    var page: Page? {
        didSet{
            guard let page = page else{
                return
            }
            imageView.image = UIImage(named: page.imageName)
            labelTitle.text = "\(page.title)"
            labelMessage.text = "\(page.message)"
        }
        
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
   
    
    func setupViews(){
       
        addSubview(stackView1)
        addSubview(stackView4)
        stackView1.addArrangedSubview(lineSeparatorView)
        stackView1.addArrangedSubview(labelTitle)
        stackView1.addArrangedSubview(labelMessage)
        stackView4.addArrangedSubview(imageView)
        stackView4.addArrangedSubview(stackView1)
        
        stackView4.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 4*(frame.height/5)))
        
        
        
        // imageView.anchor(top: stackView4.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 100, left: 0, bottom: 0, right: 0), size: CGSize(width: 250, height: stackView1Height  ))
        

           imageView.anchor(top: stackView4.topAnchor, leading: stackView4.leadingAnchor, bottom: stackView1.topAnchor, trailing: stackView4.trailingAnchor, padding: .init(top: 50, left: 0, bottom: 0, right: 0))
        
        
        
        
        stackView1.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 130))
        
      lineSeparatorView.anchor(top: nil, leading: stackView1.leadingAnchor, bottom: nil, trailing: stackView1.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 1))
        
    }
    
    let stackView1: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.equalSpacing
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 20.0
        return sv
    }()
    let stackView4: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.equalSpacing
        sv.alignment = UIStackView.Alignment.center
        sv.spacing  = 0
        return sv
    }()
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.white
        iv.image = UIImage(named: "Page1")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    let labelTitle: UILabel = {
        let titleL = UILabel()
        titleL.text = "Title"
        titleL.font = UIFont.boldSystemFont(ofSize: 22)
        titleL.textColor = UIColor.darkGray
        titleL.textAlignment = .center
        titleL.numberOfLines = 0
        return titleL
    }()
    let labelMessage: UILabel = {
        let messageL = UILabel()
        messageL.text = "Message"
        messageL.textColor = UIColor.darkGray
        messageL.font = UIFont.systemFont(ofSize: 13)
        messageL.textAlignment = .center
        messageL.numberOfLines = 0
        return messageL
        
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
