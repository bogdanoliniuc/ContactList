//
//  Contact+CoreDataProperties.swift
//  ContactList
//
//  Created by Bogdan on 27.06.2022.
//
//

import Foundation
import CoreData


extension Contact {
    
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }
    
    @nonobjc public class func createContactListFetchRequest() -> NSFetchRequest<NSDictionary> {
        let activeStatusPredicate = NSPredicate(format: "status == 'active'")
        let contactsProperties = ["id", "firstName", "lastName"]
        let request = NSFetchRequest<NSDictionary>(entityName: "Contact")
        request.predicate = activeStatusPredicate
        request.propertiesToFetch = contactsProperties
        request.resultType = .dictionaryResultType
        return request
    }
    
    @nonobjc public class func createContactFetchRequest(forId id: Int64) -> NSFetchRequest<NSDictionary> {
        let contactPredicate = NSPredicate(format: "id == \(id)")
        let contactProperties = ["id", "firstName", "lastName", "phoneNumber", "email", "status"]
        let request = NSFetchRequest<NSDictionary>(entityName: "Contact")
        request.predicate = contactPredicate
        request.propertiesToFetch = contactProperties
        request.resultType = .dictionaryResultType
        request.fetchLimit = 1
        return request
    }
    
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var email: String?
    @NSManaged public var id: Int64
    @NSManaged public var gender: String?
    @NSManaged public var status: String?

}

extension Contact : Identifiable {

}
