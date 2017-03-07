//
//  Message.swift
//  iOs-Project
//
//  Created by Julien GALLEGO on 06/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Message {
    
    // MARK: - Methods
    
    /// Get the number of message in a set
    ///
    /// - Returns: how many messages are in the set
    static func getNumbersOfMessages()-> Int{
        var msgs: [Message] = []
        let context = CoreDataManager.getContext()
        let request : NSFetchRequest<Message> = Message.fetchRequest()
        do {
            try msgs = context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get number of messages\(error)")
        }
        return msgs.count
    }

}

