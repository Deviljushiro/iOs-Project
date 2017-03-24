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
    

    // MARK: - CRUD
    
    @discardableResult
    /// Create a new message in the DB
    ///
    /// - Parameters:
    ///   - id: of the msg
    ///   - body: of the msg
    ///   - sendDate: of the msg
    ///   - image: of the msg
    /// - Returns: the msg created
    static func createNewMessage(body: String,image: NSData?,person: Personne){
        //create a msg
        let msg = Message(context: CoreDataManager.getContext())
        //save datas into the person
        msg.dateEnvoi = DateManager.currentDateString()
        msg.id = autoIncrementMessages()
        msg.contenu = body
        msg.image = image
        msg.ecritPar = person
        CoreDataManager.save()
    }
    
    // MARK: - Help Methods
    
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
    
    // MARK: - Increment tools
    
    /// Increment automatically the number of messages
    ///
    /// - Returns: The number of messages incremented
    class func autoIncrementMessages() -> Int64{
        return Message.getNumbersOfMessages()+1
    }


}

