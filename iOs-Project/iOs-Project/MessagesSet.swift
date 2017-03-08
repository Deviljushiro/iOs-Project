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
    func addMessage(message mes:String,personne p:Personne)->Message?{
        //create a person
        let message = Message(context: self.context)
        //save datas into the person
        message.contenu = mes
        message.dateEnvoi = currentDateString()
        message.id = autoIncrement()
        message.ecritPar=p
        if CoreDataManager.save() != nil {
            return nil
        }
        else{
            self.listMsg.append(message)
            return message
        }

    }
    
    // MARK: - Tool Methods
    
    /// Get the current date
    ///
    /// - Returns: the current date
    func currentDate() -> Date{
        let date = NSDate()
        let calendar = NSCalendar.current
        let dateNeeded = calendar.dateComponents([.year, .month,.day], from: date as Date)
        let year : String = String(format: "%04d", dateNeeded.year!)
        let month = String(format: "%02d", dateNeeded.month!)
        let day = String(format:"%02d",dateNeeded.day!)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        let result = formatter.date(from :day+"-"+month+"-"+year)
        //let result = formatter.date(from :"01-04-2017")
        return result!
        
    }
    
    /// Get the current date as a string
    ///
    /// - Returns: the current date
    func currentDateString() -> String{
        let date = NSDate()
        let calendar = NSCalendar.current
        let dateNeeded = calendar.dateComponents([.year, .month,.day], from: date as Date)
        let year : String = String(format: "%04d", dateNeeded.year!)
        let month = String(format: "%02d", dateNeeded.month!)
        let day = String(format:"%02d",dateNeeded.day!)
        let result :String = day+"/"+month+"/"+year
        //let result = formatter.date(from :"01-04-2017")
        return result
        
    }
    /// Increment automatically the number of messages
    ///
    /// - Returns: The number of messages incremented
    func autoIncrement() -> Int64{
        return Message.getNumbersOfMessages()+1
    }


    
}
