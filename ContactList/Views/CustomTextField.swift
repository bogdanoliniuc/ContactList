//
//  CustomTextField.swift
//  ContactList
//
//  Created by Bogdan on 28.06.2022.
//

import UIKit

class CustomTextField: UIView {
    
    private var labelText: String
    private var additionalText: String = ""
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = labelText.uppercased()
        label.textColor = UIColor.customLightGray2
        label.font = UIFont(name: "SFProText-Regular", size: 12)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var additionalLabel: UILabel = {
        let label = UILabel()
        label.text = additionalText
        label.textColor = UIColor.customLightGray2
        label.font = UIFont(name: "SFProText-Regular", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customLightGray1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(labelText lt: String = " ") {
        labelText = lt
        
        super.init(frame: CGRect.zero)
        
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        self.addSubview(label)
        self.addSubview(additionalLabel)
        self.addSubview(textField)
        self.addSubview(bottomLine)
        
        addLayout()
    }
    
    private func addLayout() {
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            label.heightAnchor.constraint(equalToConstant: 16),
            
            textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: label.bottomAnchor),
            textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            
            bottomLine.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            bottomLine.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            bottomLine.topAnchor.constraint(equalTo: textField.bottomAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
            
            additionalLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            additionalLabel.topAnchor.constraint(equalTo: bottomLine.bottomAnchor)
        ])
    }
    
    func getTextFieldText() -> String {
        return textField.text ?? ""
    }
    
    func setTextFieldText(_ text: String) {
        textField.text = text
    }
    
    func setLabel(text: String) {
        labelText = text
        label.text = text
    }
    
    func setPlaceHolder(text: String) {
        textField.placeholder = text
    }
    
    func setDelegate(_ delegate: UITextFieldDelegate) {
        textField.delegate = delegate
    }
    
    func showError(errorMessage: String) {
        additionalLabel.text = errorMessage
        additionalLabel.textColor = UIColor.errorColor
        bottomLine.backgroundColor = UIColor.errorColor
    }
    
    func hideError() {
        additionalLabel.text = additionalText
        additionalLabel.textColor = UIColor.customLightGray2
        bottomLine.backgroundColor = UIColor.customLightGray1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        textField.delegate = nil
    }
}
