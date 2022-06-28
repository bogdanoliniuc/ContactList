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
    
    func getContacts(_ completionBlock: @escaping ([NSDictionary]?, Error?) -> Void) {
        self.loadSavedContacts { contacts in
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
                    
                    self.loadSavedContacts({ contacts in
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
    
    func getContactForId(id: Int64) -> NSDictionary? {
        let request = Contact.createContactFetchRequest(forId: id)
            
        do {
            let contacts = try container.viewContext.fetch(request)
            return contacts[0]
        } catch {
            print("Fetch failed")
        }
            
        return nil
    }
    
    func saveContact(contact: [String: Any]) {
        let contactObject = Contact(context: self.container.viewContext)
        if let id = contact["id"] as? Int64{
            contactObject.id = id
        } else {
            contactObject.id = nextAvailbleId(in: self.container.viewContext)!
        }
        contactObject.firstName = contact["firstName"] as? String
        contactObject.lastName = contact["lastName"] as? String
        contactObject.email = contact["email"] as? String
        contactObject.phoneNumber = contact["phoneNumber"] as? String
        contactObject.status = contact["status"] as? String
        
        self.saveContext()
    }
    
    func loadSavedContacts(_ completionBlock: @escaping ([NSDictionary]?) -> Void) {
        let request = Contact.createContactListFetchRequest()
        
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
    
    func validatePhoneNumber(_ phone: String) -> Bool {
        let range = NSRange(location: 0, length: phone.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^07[0-9]{2} [0-9]{3} [0-9]{3}$")
        
        return regex.firstMatch(in: phone, options: [], range: range) != nil
    }
    
    func formatPhoneNumber(phoneNumber: String) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\sa-zA-Z]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")

        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }

        if number.count <= 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "([0-9]{4})([0-9])", with: "$1 $2", options: .regularExpression, range: range)
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "([0-9]{4})([0-9]{3})([0-9])", with: "$1 $2 $3", options: .regularExpression, range: range)
        }

        return number
    }
    
    func nextAvailbleId( in context: NSManagedObjectContext) -> Int64? {
        let req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Contact")
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
        req.entity = entity
        req.fetchLimit = 1
        req.propertiesToFetch = ["id"]
        let indexSort = NSSortDescriptor.init(key: "id", ascending: false)
        req.sortDescriptors = [indexSort]

        do {
            let fetchedData = try context.fetch(req)
            let firstObject = fetchedData.first as! NSManagedObject
            if let foundValue = firstObject.value(forKey: "id") as? NSNumber {
                return NSNumber.init(value: foundValue.intValue + 1) as? Int64
            }

            } catch {
                print(error)

            }
        return nil

    }
}

