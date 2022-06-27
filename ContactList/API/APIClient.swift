//
//  APIClient.swift
//  ContactList
//
//  Created by Bogdan on 27.06.2022.
//

import Foundation

class APIClient {
    
    let contactsURLString = "https://gorest.co.in/public/v2/users"
    let contactImageURLString = "https://picsum.photos/200/200"
    
    func getContacts(_ completionBlock: @escaping (Array<Any>?, Error?) -> Void) {
        let url = URL(string: contactsURLString)!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                completionBlock(nil, error)
                return
            }
            
            let jsonContacts = try? JSONSerialization.jsonObject(with: data)
            let contactsArray = (jsonContacts as! Array<Any>)
            
            completionBlock(contactsArray, nil)
        }

        task.resume()
    }
    
    func getContactImage(_ completionBlock: @escaping (Data?, Error?) -> Void) {
        let url = URL(string: contactImageURLString)!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                completionBlock(nil, error)
                return
            }
            
            completionBlock(data, nil)
        }

        task.resume()
    }
}
