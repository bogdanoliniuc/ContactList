//
//  ContactTableViewCell.swift
//  ContactList
//
//  Created by Bogdan on 27.06.2022.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    lazy var rightImage: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "right_arrow"))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.customLightGray1
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.imageView?.image = UIImage(color: UIColor.customLightGray3, size: CGSize(width: 46, height: 46))
        self.imageView?.layer.cornerRadius = 23
        self.imageView?.layer.masksToBounds = true
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.textLabel?.font = UIFont(name: "SFProText-Regular", size: 17)
        self.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel?.textColor = UIColor.customBlack
        
        self.selectionStyle = .none
        
        backgroundColor = .white
        
        self.contentView.addSubview(rightImage)
        self.contentView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            imageView!.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 24),
            imageView!.widthAnchor.constraint(equalToConstant: 46),
            imageView!.heightAnchor.constraint(equalTo: imageView!.widthAnchor),
            imageView!.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            textLabel!.leftAnchor.constraint(equalTo: leftAnchor, constant: 86),
            textLabel!.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            rightImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -24),
            rightImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            separator.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            separator.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            separator.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            separator.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    func setContactName(contactName name: String) {
        self.textLabel?.text = name
    }
    
    func setContactInitialsImage(contactInitials initials: String) {        
        let initialsLabel = UILabel()
        initialsLabel.text = initials
        initialsLabel.textColor = UIColor.white
        initialsLabel.font = UIFont(name: "SFProText-Regular", size: 17)
        initialsLabel.font = UIFont.boldSystemFont(ofSize: 17)
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageView?.subviews.forEach({ $0.removeFromSuperview() })
        self.imageView?.image = UIImage(color: UIColor.customLightGray3, size: CGSize(width: 46, height: 46))
        self.imageView?.addSubview(initialsLabel)
        
        NSLayoutConstraint.activate([
            initialsLabel.centerXAnchor.constraint(equalTo: self.imageView!.centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: self.imageView!.centerYAnchor)
        ])
    }
    
    func setContactImage(contactImage image: UIImage) {
        self.imageView?.subviews.forEach({ $0.removeFromSuperview() })
        self.imageView?.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
