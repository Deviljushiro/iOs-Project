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
    static var isLogin = false
    static var session : Session? = nil
    var pseudo : String
    var pwd : String
    private init(pseudo p:String,password passwd: String){
        pseudo=p
        pwd=passwd
        
    }
    
    @discardableResult
    static func newSession(pseudo p:String,password pwd: String)->Session{
        if let asession = Session.session{
            return asession
        }
        else{
            Session.session = Session(pseudo: p,password: pwd)
            return Session.session!
        }
    }
}
    


