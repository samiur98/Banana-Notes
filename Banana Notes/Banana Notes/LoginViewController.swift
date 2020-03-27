//
//  LoginViewController.swift
//  Banana Notes
//
//  Created by Shah Samiur Rahman on 3/26/20.
//  Copyright © 2020 Shah Samiur Rahman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        NSLog("Login Button Pressed.");
        
    }
    
    func validateEmail() -> Bool{
        //Validates that the the email address text field has been filled.
        if(self.emailTextField != nil){
            return (self.emailTextField.hasText);
        }
        return false;
    }
    
    func validatePassword() -> Bool{
        //Validates that the password text filed has been filled and has a minimum of 8 charachters.
        if(self.passwordTextField != nil){
            if((self.passwordTextField.hasText) && (self.passwordTextField.text!.count >= 8)){
                return true;
            }
            return false;
        }
        return false;
    }
}
