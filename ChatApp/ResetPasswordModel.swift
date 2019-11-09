//
//  ResetPasswordModel.swift
//  ChatApp
//
//  Created by umer hamid on 11/4/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import Foundation
import UIKit

class ResetPasswordModel{
    
    let query = FireStoreQueries()
    
    func completeResetPassword(email  : String , completion : @escaping (_ msg : String)-> Void)  {
        
        if email == "" {
            completion("Email is invalid")
        }else{
            query.resetPassword(email: email) { (response) in
                completion(response)
            }
        }
    }
}
