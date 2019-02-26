//
//  MessageController.swift
//  BulletinBoard
//
//  Created by Jack Knight on 2/25/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import Foundation
import CloudKit

class MessageController {
    
    // Source of truth
    var messages: [Message] = []
    var filteredMessages: [Message] = []
    
    let userController = UserController()
    
   // Public Cloud Database
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //Crud functions
    
    func postNewMessage(with text: String, completion: @escaping (Bool) -> Void) {
        let newMessage = Message(text: text)
        let messageAsRecord = CKRecord(message: newMessage)
        
        publicDB.save(messageAsRecord) { (record, error) in
           if let error = error {
                print("💩There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion(false)
                return
            }
            
            if let record = record, let returnMessage = Message(record: record) {
                self.messages.insert(returnMessage, at: 0)
                
            }
            completion(true)
        }
    }
    
    func fetchAllMessage(completion: @escaping (Bool) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Message.messageKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
          if let error = error {
                print("💩There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion(false)
                return
            }
            
            guard let records = records else { completion(false); return}
            
            let messages = records.compactMap{ Message(record: $0)}
            
            let sortedMessages = messages.sorted(by: { (first, second) -> Bool in
              return first.timeStamp > second.timeStamp
          
            })
            
            self.messages = sortedMessages
            completion(true)
            }
        }
    
    func subscribeToCreationOfMessages(completion: @escaping (CKSubscription?, Error?) -> Void) {
       
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(recordType: Message.messageKey, predicate: predicate, subscriptionID: Message.messageSubscription, options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "Hey!"
        notificationInfo.alertBody = "There was a new message posted to the bulletin baoard!"
        
        subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription) { (subscription, error) in
                if let error = error {
                print("💩There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                    completion(nil, error)
                    return
            }
            
            guard let subscription = subscription else { completion(nil, error) ; return}
                completion(subscription, nil)
        }
    }
    func fetchMessagesForUser(email: String, completion: @escaping (Bool) -> Void) {
      
        userController.fetchUserWith(email: email) { (userIdentity, error) in
            if let error = error {
                print("💩There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion(false)
                return
            }
            guard let userIdentity = userIdentity,
            let userRecordID = userIdentity.userRecordID
                else { completion(false); return}
            
            let predicate = NSPredicate(format: "creatorUserRecordID == %@", userRecordID)
            let query = CKQuery(recordType: Message.messageKey, predicate: predicate)
            self.publicDB.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error {
                    print("💩There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                    completion(false)
                    return
                }
                
                guard let records = records else {completion(false) ; return}
                
//                self.filteredMessages = records.compactMap { Message(record: $0)}
                var filteredMessages: [Message] = []
                for record in records {
                    if let message = Message(record: record) {
                        filteredMessages.append(message)
                    }
                }
                self.filteredMessages = filteredMessages
                completion(true)
            })
        }
    }
}

