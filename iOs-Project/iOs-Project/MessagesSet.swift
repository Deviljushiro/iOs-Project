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
    
    var listMsg: [Message]
    let context = CoreDataManager.getContext()
    let request : NSFetchRequest<Message> = Message.fetchRequest()

    init(){
        do {
            try self.listMsg = self.context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get number of messages\(error)")
        }
    }
    
    var numbersOfMessages : Int{
        get{
            return self.listMsg.count
        }
    }
    
    func addMessage(message mes:String,personne p:Personne)->Message?{
        //create a person
        let message = Message(context: self.context)
        //save datas into the person
        message.contenu = mes
        message.dateEnvoi = currentDate() as NSDate
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
    
    
    func currentDate() -> Date{
        let date = NSDate()
        let calendar = NSCalendar.current
        let dateNeeded = calendar.dateComponents([.year, .month,.day], from: date as Date)
        let year = String(describing: dateNeeded.year)
        let month = String(describing:dateNeeded.month)
        let day = String(describing:dateNeeded.day)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        let result = formatter.date(from :day+"/"+month+"/"+year)
        return result!
        
    }
    
    func autoIncrement() -> Int64{
        return Message.getNumbersOfMessages()+1
    }


    
}
