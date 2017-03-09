//
//  MessagesSet.swift
//  iOs-Project
//
//  Created by Julien GALLEGO on 06/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MessagesSet {
    
    // MARK: - Variables
    
    var listMsg: [Message]
    var numbersOfMessages : Int{
        get{
            return self.listMsg.count
        }
    }
    
    // MARK: - CoreData Constant
    
    let context = CoreDataManager.getContext()
    let request : NSFetchRequest<Message> = Message.fetchRequest()

    // MARK: - Initialization
    
    init(){
        do {
            try self.listMsg = self.context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get number of messages\(error)")
        }
    }
    
    // MARK: - Data Manager
    
    /// Add a message to the set
    ///
    /// - Parameters:
    ///   - mes: the message we want to add
    ///   - p: the person who sent the message
    /// - Returns: the message we added (or nil if the save failed)
    func addMessage(message mes:Message, personne p:Personne) {
            self.listMsg.append(mes)
    }
    
}
