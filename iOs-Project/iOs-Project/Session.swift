//
//  Session.swift
//  iOs-Project
//
//  Created by Julien GALLEGO on 06/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class Session{
    
    // MARK: - Variables
    
    static var isLogin = false
    static var session : Session? = nil
    var username : String
    var pwd : String
    
    
    // MARK: - Initialization
    
    private init(username u:String,password passwd: String){
        username=u
        pwd=passwd
        
    }
    
    // MARK: - Session methods
    
    @discardableResult
    /// Create a new session
    ///
    /// - Parameters:
    ///   - p: the username of the user
    ///   - pwd: the password of the user
    /// - Returns: the session created
    static func newSession(username u:String,password pwd: String)->Session{
        if let asession = Session.session{
            return asession
        }
        else{
            Session.session = Session(username: u,password: pwd)
            return Session.session!
        }
    }
}
    


