//
//  Provider.swift
//  ContactList
//
//  Created by Bogdan on 28.06.2022.
//

import Foundation

class Provider: NSObject {
    private var contactsProvider: ContactsProvider
    
    override init() {
        contactsProvider = ContactsProvider()
    }
    
    func getContactsProvider() -> ContactsProvider {
        return contactsProvider
    }
}
