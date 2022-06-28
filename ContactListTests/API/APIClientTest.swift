//
//  APIClientTest.swift
//  ContactListTests
//
//  Created by Bogdan on 28.06.2022.
//

import XCTest
@testable import ContactList

class APIClientTest: XCTestCase {
    
    var apiClient: APIClient?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        apiClient = APIClient()
    }
    
    override func tearDownWithError() throws {
        apiClient = nil
        try super.tearDownWithError()
    }
    
    func testGetContacts() throws {
        let expectation = expectation(description: "get contacts")
        let _: ()? = apiClient?.getContacts({ contacts, error in
            
            XCTAssertNotNil(contacts)
            XCTAssertNil(error)
            XCTAssertGreaterThan(contacts!.count, 0)
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5)
    }

}


