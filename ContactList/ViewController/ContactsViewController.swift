//
//  ViewController.swift
//  ContactList
//
//  Created by Bogdan on 27.06.2022.
//

import UIKit

protocol ModalDismissProtocol {
    func updateUIAfterDismiss()
}

class ContactsViewController: UIViewController {
    
    let cellIdentifier = "contactCell"
    
    var contacts = [NSDictionary]()
    
    let contactsProvider: ContactsProvider
    
    lazy var spinner: UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.customLightGray1
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.customLightGray1
        tableView.backgroundColor = .clear
        tableView.sectionHeaderTopPadding = 0
        return tableView
    }()
    
    lazy var noContactsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font.fontName, size: 20)
        label.textColor = .darkGray
        label.text = NSLocalizedString("no_contacts", comment: "")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    init(contactsProvider: ContactsProvider) {
        self.contactsProvider = contactsProvider
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavItem()
        
        getContacts()
    }
    
    func getContacts() {
        contactsProvider.getContacts({ contactsArray, error in
            DispatchQueue.main.async { [unowned self] in
                self.spinner.stopAnimating()
                if let contactsArray = contactsArray {
                    self.contacts = contactsArray
                    self.tableView.reloadData()
                        
                }else if let error = error {
                    //TODO: show error
                }
                self.noContactsLabel.isHidden = !self.contacts.isEmpty
            }
        })
    }
    
    @objc func addContactTapped() {
        let contactDetailsViewController = ContactDetailsViewController(contactsProvider: contactsProvider, contactId: nil)
        contactDetailsViewController.setDelegate(self)
        let navController = UINavigationController(rootViewController: contactDetailsViewController)
        self.present(navController, animated: true)
    }
}

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! ContactTableViewCell
        let firstName = contacts[indexPath.row]["firstName"] as? String
        let lastName = contacts[indexPath.row]["lastName"] as? String
        
        contactCell.setContactName(contactName: "\(firstName ?? "") \(lastName ?? "")")
        
        contactCell.setContactInitialsImage(contactInitials: "\(firstName?.prefix(1).uppercased() ?? "")\(lastName?.prefix(1).uppercased() ?? "")")
        
        if let contactId = contacts[indexPath.row]["id"] as? Int64  {
            if contactId % 2 != 0 {
                contactsProvider.getContactImage { imageData, error in
                    if let imageData = imageData {
                        let image = UIImage(data: imageData, scale: 1.0)
                        DispatchQueue.main.async {
                            contactCell.setContactImage(contactImage: image!)
                        }
                    } else if let error = error {
                        //TODO: show error
                    }
                }
            }
        }
        
        return contactCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
}

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 38))
        view.backgroundColor = UIColor.customLightGray1
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Regular", size: 13)
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = NSLocalizedString("section_title", comment: "").uppercased()
        label.textColor = UIColor.customLightGray2
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: -11),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.contacts.isEmpty ? 0 : 38
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        
        let contactDetailsViewController = ContactDetailsViewController(contactsProvider: contactsProvider, contactId: contact["id"] as? Int64)
        contactDetailsViewController.setDelegate(self)
        let navController = UINavigationController(rootViewController: contactDetailsViewController)
        self.present(navController, animated: true)
    }
}

// MARK: - UI Setup
extension ContactsViewController {
    private func setupUI() {
        self.view.backgroundColor = UIColor.white
        
        extendedLayoutIncludesOpaqueBars = true;
        
        self.view.addSubview(tableView)
        self.view.addSubview(noContactsLabel)
        self.view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            tableView.widthAnchor
                .constraint(equalTo: self.view.widthAnchor),
            tableView.heightAnchor
                .constraint(equalTo: self.view.heightAnchor),
            noContactsLabel.centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            noContactsLabel.centerYAnchor
                .constraint(equalTo: self.view.centerYAnchor),
            spinner.centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            spinner.centerYAnchor
                .constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    private func setupNavItem() {
        self.title = NSLocalizedString("contacts_list_title", comment: "title")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 24)!, NSAttributedString.Key.foregroundColor: UIColor.customBlack]
        
        var image = UIImage(named: "add_contact")
        image = image?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageViewContainer = UIView()
        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        imageViewContainer.layer.borderColor = UIColor.customLightGray1.cgColor
        imageViewContainer.layer.borderWidth = 2
        imageViewContainer.layer.cornerRadius = 7
        imageViewContainer.clipsToBounds = true
        imageViewContainer.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: imageViewContainer.leftAnchor, constant: 9),
            imageView.topAnchor.constraint(equalTo: imageViewContainer.topAnchor, constant: 9),
            imageView.rightAnchor.constraint(equalTo: imageViewContainer.rightAnchor, constant: -9),
            imageView.bottomAnchor.constraint(equalTo: imageViewContainer.bottomAnchor, constant: -9),
            imageView.heightAnchor.constraint(equalToConstant: 18),
            imageView.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        guard let navigationBar = self.navigationController?.navigationBar else {return }
        navigationBar.addSubview(imageViewContainer)
        
        NSLayoutConstraint.activate([
            imageViewContainer.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -24),
            imageViewContainer.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -9),
            imageViewContainer.heightAnchor.constraint(equalToConstant: 36),
            imageViewContainer.widthAnchor.constraint(equalToConstant: 36)
        ])
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addContactTapped))
        gesture.numberOfTapsRequired = 1
        imageViewContainer.isUserInteractionEnabled = true
        imageViewContainer.addGestureRecognizer(gesture)
        
        spinner.startAnimating()
    }
}

extension ContactsViewController: ModalDismissProtocol {
    func updateUIAfterDismiss() {
        getContacts()
    }
}



