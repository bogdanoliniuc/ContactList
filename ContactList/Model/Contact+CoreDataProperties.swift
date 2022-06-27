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
