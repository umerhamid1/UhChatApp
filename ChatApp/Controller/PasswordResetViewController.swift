//
//  PasswordResetViewController.swift
//  ChatApp
//
//  Created by umer hamid on 11/4/19.
//  Copyright © 2019 umer hamid. All rights reserved.
//

import UIKit


class PasswordResetViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    var rpm = ResetPasswordModel()
    var gf = GeneralFunction()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        
        self.view.makeToastActivity(.center)
        rpm.completeResetPassword(email: emailTextField.text!) { (response) in
            
            self.view.hideToastActivity()
            self.gf.showMessage(title: "Result", msg: response, on: self)
        }
    }
    
    

}
