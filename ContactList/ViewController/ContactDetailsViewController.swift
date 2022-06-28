//
//  ContactDetailsViewController.swift
//  ContactList
//
//  Created by Bogdan on 28.06.2022.
//

import Foundation
import UIKit

class ContactDetailsViewController: UIViewController {
    
    private var contactsProvider: ContactsProvider
    
    private var contactId: Int64?
    
    private var contact: [String: Any]?
    
    private var delegate: ModalDismissProtocol? = nil
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customLightGray1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var firstNameTextField: CustomTextField = {
        let textField = CustomTextField(labelText: NSLocalizedString("first_name", comment: ""))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var lastNameTextField: CustomTextField = {
        let textField = CustomTextField(labelText: NSLocalizedString("last_name", comment: ""))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var phoneTextField: CustomTextField = {
        let textField = CustomTextField(labelText: NSLocalizedString("phone_number", comment: ""))
        textField.setPlaceHolder(text: "07XX XXX XXX")
        textField.setDelegate(self)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField(labelText: NSLocalizedString("email_address", comment: ""))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.customGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        
        if contactId != nil { // updating current contact
            button.setTitle(NSLocalizedString("button_update_title", comment: ""), for: .normal)
        } else { // saving new contact
            button.setTitle(NSLocalizedString("button_save_title", comment: ""), for: .normal)
        }
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 17)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    init(contactsProvider: ContactsProvider, contactId id: Int64?) {
        self.contactsProvider = contactsProvider
        self.contactId = id
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        getContactForId()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavItem()
    }
    
    func getContactForId() {
        if let contactId = contactId {
            contact = contactsProvider.getContactForId(id: contactId) as? [String : Any]
            DispatchQueue.main.async {
                self.firstNameTextField.setTextFieldText(self.contact?["firstName"] as? String ?? "")
                self.lastNameTextField.setTextFieldText(self.contact?["lastName"] as? String ?? "")
                self.phoneTextField.setTextFieldText(self.contact?["phoneNumber"] as? String ?? "")
                self.emailTextField.setTextFieldText(self.contact?["email"] as? String ?? "")
            }
        }
    }
    
    @objc func buttonTapped() {
        let firstName = firstNameTextField.getTextFieldText()
        let lastName = lastNameTextField.getTextFieldText()
        let phoneNumber = phoneTextField.getTextFieldText()
        let phoneNumberIsValid = !phoneNumber.isEmpty ? contactsProvider.validatePhoneNumber(phoneNumber) : true
        
        if firstName.isEmpty {
            firstNameTextField.showError(errorMessage: NSLocalizedString("first_name_error", comment: ""))
        }else {
            firstNameTextField.hideError()
        }
        
        if lastName.isEmpty {
            lastNameTextField.showError(errorMessage: NSLocalizedString("last_name_error", comment: ""))
        } else {
            lastNameTextField.hideError()
        }
        
        if !phoneNumberIsValid {
            phoneTextField.showError(errorMessage: NSLocalizedString("phone_number_error", comment: ""))
        } else {
            phoneTextField.hideError()
        }
        
        if firstName.isEmpty || lastName.isEmpty || !phoneNumberIsValid {
            return
        }
        
        if contact == nil {
            contact = [:]
        }
    
        contact?["firstName"] = firstName
        contact?["lastName"] = lastName
        contact?["phoneNumber"] = phoneNumber
        contact?["email"] = emailTextField.getTextFieldText()
        contact?["status"] = "active" //considering status = 'active' for testing

        contactsProvider.saveContact(contact: contact!)
        
        self.dismiss(animated: true) { [unowned self] in
            self.delegate?.updateUIAfterDismiss()
        }
    }
    
    func setDelegate(_ delegate: ModalDismissProtocol) {
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        delegate = nil
    }
}

// MARK: - UI Setup
extension ContactDetailsViewController {
    private func setupUI() {
        self.view.backgroundColor = UIColor.white
        
        extendedLayoutIncludesOpaqueBars = true;
        
        self.view.addSubview(contentView)
        
        let guide = view.safeAreaLayoutGuide
         NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
            contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
         ])
        
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(phoneTextField)
        contentView.addSubview(emailTextField)
        
        contentView.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            firstNameTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            firstNameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            firstNameTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),

            lastNameTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 24),
            lastNameTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            phoneTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            phoneTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 24),
            phoneTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            emailTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            emailTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 24),
            emailTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            saveButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            saveButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            saveButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupNavItem() {
        self.title = NSLocalizedString("contact_details_title", comment: "title")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 24)!, NSAttributedString.Key.foregroundColor: UIColor.customBlack]
    }
}

extension ContactDetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var fullString = textField.text ?? ""
        fullString.append(string)
        if range.length == 1 { //delete action
            let end = fullString.index(fullString.startIndex, offsetBy: fullString.count-1)
            fullString = String(fullString[fullString.startIndex..<end])
            textField.text = fullString
        } else {
            textField.text = contactsProvider.formatPhoneNumber(phoneNumber: fullString)
        }
        return false
    }
}
