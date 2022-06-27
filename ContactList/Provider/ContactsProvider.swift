//
//  ContactsProvider.swift
//  ContactList
//
//  Created by Bogdan on 27.06.2022.
//

import Foundation
import CoreData

class ContactsProvider {
    
    var apiClient = APIClient()
    
    var container: NSPersistentContainer!
    
    init() {
        container = NSPersistentContainer(name: "ContactList")
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

            if let error = error {
                print("Unresolved error \(error)")
            }
        }
    }
    
    func getContacts(_ completionBlock: @escaping ([Contact]?, Error?) -> Void) {
        self.loadSavedData { contacts in
            if let contacts = contacts {
                if !contacts.isEmpty {
                    completionBlock(contacts, nil)
                    return
                }
            }
            
            self.apiClient.getContacts({ jsonContacts, error in
                if let jsonContacts = jsonContacts {
                    for jsonContact in jsonContacts {
                        let contact = Contact(context: self.container.viewContext)
                        self.configure(contact: contact, usingJSON: jsonContact as! [String : Any])
                    }

                    self.saveContext()
                    
                    self.loadSavedData({ contacts in
                        if let contacts = contacts {
                            completionBlock(contacts, nil)
                        }
                    })
                } else if let error = error {
                    completionBlock(nil, error)
                }
            })
        }
    }
    
    func loadSavedData(_ completionBlock: @escaping ([Contact]?) -> Void) {
        let activeStatusPredicate = NSPredicate(format: "status == 'active'")
        let request = Contact.createFetchRequest()
        request.predicate = activeStatusPredicate

        do {
            let contacts = try container.viewContext.fetch(request)
            completionBlock(contacts)
        } catch {
            print("Fetch failed")
            completionBlock(nil)
        }
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }

    func configure(contact: Contact, usingJSON json: [String: Any]) {
        let name = (json["name"] as! String).components(separatedBy: " ")
        contact.firstName = name[0]
        contact.lastName = name.count > 1 ? name[1] : ""
        contact.email = json["email"] as? String
        contact.phoneNumber = json["phoneNumber"] as? String
        contact.gender = json["gender"] as? String
        contact.status = json["status"] as? String
        contact.id = json["id"] as! Int64
    }
    
    func getContactImage(_ completionBlock: @escaping (Data?, Error?) -> Void) {
        apiClient.getContactImage { imageData, error in
            completionBlock(imageData, error)
        }
    }
}

