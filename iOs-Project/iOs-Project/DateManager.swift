//
//  DateManager.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 09/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DateManager {

    // MARK: - Tool Methods

    /// Get the current date
    ///
    /// - Returns: the current date
    class func currentDate() -> Date{
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
    class func currentDateString() -> String{
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
    class func autoIncrement() -> Int64{
        return Message.getNumbersOfMessages()+1
    }

}
