//
//  UserController.swift
//  BulletinBoard
//
//  Created by Jack Knight on 2/26/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    func requestDiscoverabiltyAuthentication(completion: @escaping (Bool) -> Void) {
        
        CKContainer.default().status(forApplicationPermission: .userDiscoverability) { (status, error) in
            if let error = error {
                print("💩There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion(false)
                return
            }
            guard status != .granted else { completion(true) ; return }
            
            CKContainer.default().requestApplicationPermission(.userDiscoverability, completionHandler: { (status, error) in
                 if let error = error {
                    print("💩There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                    completion(false)
                    return
                }
                
                if status == .granted {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    func fetchUserWith(email: String, completion: @escaping (CKUserIdentity?, Error?) -> Void) {
        CKContainer.default().discoverUserIdentity(withEmailAddress: email) { (userIdentity, error) in
            if let error = error {
                print("💩There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion(nil, error)
                return
            }
            guard let userIdentity = userIdentity else {completion(nil, nil) ; return}
            
            completion(userIdentity, nil)
        }
    }
}
