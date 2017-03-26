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
    static func createNewMessage(body: String,image: NSData?,person: Personne,group: Groupe?){
        //create a msg
        let msg = Message(context: CoreDataManager.context)
        //save datas into the person
        msg.dateEnvoi = DateManager.currentDateString()
        msg.id = autoIncrementMessages()
        msg.contenu = body
        msg.image = image
        msg.ecritPar = person
        msg.concerner = group
        CoreDataManager.save()
    }
    
    // MARK: - Help Methods
    

    
    // MARK: - Increment tools
    
    /// Increment automatically the number of messages
    ///
    /// - Returns: The number of messages incremented
    class func autoIncrementMessages() -> Int64{
        return MessagesSet.getNumbersOfMessages()+1
    }


}

