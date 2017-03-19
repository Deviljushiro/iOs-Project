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
    
    private static var user: Personne? = nil
    
    
    // MARK: - Initialization
    
    /// Initialize the session
    ///
    /// - Parameter person: the person wo want to create his Session
    private init(person: Personne){
        Session.user = person
    }
    
    // MARK: - Session methods
    
    @discardableResult
    /// Create a new session
    ///
    /// - Parameters:
    ///   - p: the username of the user
    ///   - pwd: the password of the user
    /// - Returns: the session created
    static func getSession()-> Personne{
        return Session.user!
    }

    /// Destroy the user's Session
    static func destroySession() {
        Session.user = nil
    }
    
    /// Create a new Session if there's no current one
    ///
    /// - Parameter person: the person wo want to create his Session
    static func createSession(person: Personne) {
        guard self.user != nil else {
            Session(person: person)
            return
        }
    }
}



