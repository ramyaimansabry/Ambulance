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
        addSubview(imageView)
        addSubview(labelTitle)
        addSubview(lineSeparatorView)
        
        
        
        imageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 0),size: CGSize(width: 25, height: 25))
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        
        labelTitle.anchor(top: nil, leading: imageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        labelTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        
        lineSeparatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: frame.width, height: 1))
        
    }
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
        titleL.textAlignment = .center
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

