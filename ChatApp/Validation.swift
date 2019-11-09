//
//  Validation.swift
//  ChatApp
//
//  Created by umer hamid on 11/1/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import Foundation
import UIKit

class Validation : UIViewController{
    
    let g = GeneralFunction()
    // phone number validation
    func isValidatePhone(value: String , controller : UIViewController) -> String {
        let PHONE_REGEX = "^[0][1-9]\\d{9}$|^[1-9]\\d{9}$"
           // let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        if result == false{
                g.showMessage(title: "Error", msg: "Phone Number is Invalid" , on : controller)
            return ""
        }else{
            return value
        }
        
          
    }
        
        
    
    // password validation
    func isValidPassword(value: String, controller : UIViewController) -> String {
              let PASSWORD_REGEX = "(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{6,15})$"
             // let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}"
              let phoneTest = NSPredicate(format: "SELF MATCHES %@", PASSWORD_REGEX)
              let result =  phoneTest.evaluate(with: value)
        
               if result == false{
                             g.showMessage(title: "Error", msg: "Password should be atleast 6 word and Contain 1 character and numeric " , on : controller)
                         return ""
                     }else{
                         return value
                     }
          }
        
        
        
  
        
        //email validation
    func isValidEmailAddress(emailAddressString: String , controller : UIViewController) -> String {
    
            // var returnValue = true
             let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    
             do {
                 let regex = try NSRegularExpression(pattern: emailRegEx)
                 let nsString = emailAddressString as NSString
                 let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
    
//                 if results.count == 0
//                 {
//                     returnValue = false
//                 }
    
             } catch let error as NSError {
                 print("invalid regex: \(error.localizedDescription)")
                g.showMessage(title: "Error", msg: "Email is invalid" , on : controller)
                 return ""
             }
            return emailAddressString
         }
    
    func isValidName(value: String , controller : UIViewController) -> String {
        
               let PASSWORD_REGEX = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"
              // let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}"
               let nameTest = NSPredicate(format: "SELF MATCHES %@", PASSWORD_REGEX)
               let result =  nameTest.evaluate(with: value)
                if result == false{
                       g.showMessage(title: "Error", msg: "name only contain characters" , on : controller)
                        return ""
               }else{
                   return value
               }
                
              
           }
        
}
