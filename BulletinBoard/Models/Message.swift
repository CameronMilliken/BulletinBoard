//
//  Message.swift
//  BulletinBoard
//
//  Created by Jack Knight on 2/25/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import Foundation
import CloudKit

struct Message {
    
    static let messageKey = "Message"
    static let messageSubscription = "messageSubscription"
    fileprivate static let textKey = "text"
    fileprivate static let timeStampKey = "timeStamp"
    
    let text: String
    let timeStamp: Date
    
    init(text: String) {
        self.text = text
        self.timeStamp = Date()
    }
    
    init?(record: CKRecord) {
        guard let text = record[Message.textKey] as? String,
            let timeStamp = record[Message.timeStampKey] as? Date else {return nil}
        self.text = text
        self.timeStamp = timeStamp

    }
}

extension CKRecord {
    
    convenience init(message: Message) {
        self.init(recordType: Message.messageKey)
        self.setValue(message.text, forKey: Message.textKey)
        self.setValue(message.timeStamp, forKey: Message.timeStampKey)
    }
}
