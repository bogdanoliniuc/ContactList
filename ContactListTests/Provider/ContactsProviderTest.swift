//
//  ProviderTest.swift
//  ContactListTests
//
//  Created by Bogdan on 28.06.2022.
//

import XCTest
@testable import ContactList

class ContactsProviderTest: XCTestCase {
    
    var provider: Provider?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        provider = Provider()
    }
    
    override func tearDownWithError() throws {
        provider = nil
        try super.tearDownWithError()
    }
    
    func testPhoneNumberIsValid() throws {
        let phoneNumber = "0720 000 000"
        XCTAssertNotNil(provider, "Provider is nil")
        let phoneNumberFormated = provider!.getContactsProvider().validatePhoneNumber(phoneNumber)
        XCTAssertTrue((phoneNumberFormated), "id should not be null")
    }
    
    func testPhoneNumberIsInValid() throws {
        let phoneNumber = "0721 234 5675"
        XCTAssertNotNil(provider, "Provider is nil")
        let phoneNumberFormated = provider!.getContactsProvider().validatePhoneNumber(phoneNumber)
        XCTAssertFalse((phoneNumberFormated), "id should not be null")
    }
    
    func testPhoneNumberFormatterisValid() throws {
        let phoneNumber = "0721234567"
        XCTAssertNotNil(provider, "Provider is nil")
        let phoneNumberFormatted = provider!.getContactsProvider().formatPhoneNumber(phoneNumber: phoneNumber)
        XCTAssertEqual(phoneNumberFormatted, "0721 234 567")
    }
    
    func testPhoneNumberFormatterisInvalid() throws {
        let phoneNumber = "0721234567"
        XCTAssertNotNil(provider, "Provider is nil")
        let phoneNumberFormatted = provider!.getContactsProvider().formatPhoneNumber(phoneNumber: phoneNumber)
        XCTAssertNotEqual(phoneNumberFormatted, "0721234 567")
    }
    
    func testGetContactsFromAPI() throws {
        let expectation = expectation(description: "get contacts")
        XCTAssertNotNil(provider, "Provider is nil")
        let _: ()? = provider!.getContactsProvider().getContactsFromAPI({ contacts, error in
            
            XCTAssertNotNil(contacts)
            XCTAssertNil(error)
            XCTAssertGreaterThan(contacts!.count, 0)
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testConfigureContact() throws {
        let contactDic = ["id":2239  as Int64,
                          "name":"Anshula Devar",
                          "email":"anshula_devar@bergstrom.name",
                          "gender":"male",
                          "status":"inactive"] as [String : Any]
        XCTAssertNotNil(provider, "Provider is nil")
        let contact = provider!.getContactsProvider().configureContact(usingJSON: contactDic)
        XCTAssertEqual(contact.id, 2239)
        XCTAssertEqual("\(contact.firstName ?? "") \(contact.lastName ?? "")", "Anshula Devar")
        XCTAssertEqual(contact.email, "anshula_devar@bergstrom.name")
        XCTAssertEqual(contact.gender, "male")
        XCTAssertEqual(contact.status, "inactive")
    }
    
    func testGetContactImage() throws {
        let expectation = expectation(description: "get contact image")
        let _: ()? = provider?.getContactsProvider().getContactImage({ imageData, error in
            
            XCTAssertNotNil(imageData)
            XCTAssertNil(error)
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testNextAvailableId() throws {
        let id = provider?.getContactsProvider().nextAvailbleId(in: (provider?.getContactsProvider().container.viewContext)!)
        
        XCTAssertNotNil(id)
        XCTAssertGreaterThan(id!, 0)
    }
}

