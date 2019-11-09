//
//  AllUserModel.swift
//  ChatApp
//
//  Created by umer hamid on 11/6/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import Foundation

class AllUserModel{
    

    
//    let fsq = FireStoreQueries()
//    
//    fsq.allUserDetail(){
//    
//    }
    
    
}

struct User : Codable {
    
    var ConversationID : Array = [String]()
    var Email : String = ""
    var ImageURL : String? = ""
    var ISOnline : Bool = false
    var Name : String = ""
    var Phone : String = ""
    var UserID : String = ""
}
