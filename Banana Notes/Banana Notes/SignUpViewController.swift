//
//  SignUpViewController.swift
//  Banana Notes
//
//  Created by Shah Samiur Rahman on 3/26/20.
//  Copyright © 2020 Shah Samiur Rahman. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!;
    @IBOutlet weak var passwordTextField: UITextField!;
    var uniqueEmail = false;
    var registrator: UserRegistrator = Registrator();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        NSLog("SignUp Button Pressed");
        if(!validateEmail()){
            NSLog("Email text field not formatted correctly.");
            let alertEmail = UIAlertController(title: "Email not formatted correctly", message: "Please provide a value for the email address field.", preferredStyle: .alert);
            alertEmail.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
            self.present(alertEmail, animated: true);
            return;
        }
        if(!validatePassword()){
            NSLog("Password text field not formatted correctly.");
            let alertPassword = UIAlertController(title: "Password not formatted correctly", message: "Please provide a value for the password field that is at least 8 charachters long.", preferredStyle: .alert);
            alertPassword.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
            self.present(alertPassword, animated: true);
            return;
        }
        let postURLString = "http://localhost:3020/users/addUser/" + self.emailTextField.text! + "/" + self.passwordTextField.text!;
        let url = URL(string: postURLString);
        if(url == nil){
            NSLog("Prolem producing url");
            let alertInternal = UIAlertController(title: "Internal Issue", message: "Sorry there has been an internal issue.", preferredStyle: .alert);
            alertInternal.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
            self.present(alertInternal, animated: true);
            return;
        }
        postRequest(url: url!);
    }
    
    func postRequest(url: URL){
        //POST request to REST API to add/register a new user.
        let sharedSession = URLSession.shared;
        var request = URLRequest(url: url);
        request.httpMethod = "POST";
        let dataTask = sharedSession.dataTask(with: request) {
            (data, response, apiError) in
            DispatchQueue.main.async {
                if let err = apiError{
                    NSLog("Error connecting to API");
                    NSLog(err.localizedDescription);
                    let alertInternal = UIAlertController(title: "Internal Issue", message: "Sorry there has been an internal issue.", preferredStyle: .alert);
                    alertInternal.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
                    self.present(alertInternal, animated: true);
                    return;
                }
                if let res = response as? HTTPURLResponse{
                    if(res.statusCode == 201){
                        NSLog("Successfull");
                        let alertSuccess = UIAlertController(title: "Success", message: "User successfullly registered!", preferredStyle: .alert);
                        alertSuccess.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
                        self.present(alertSuccess, animated: true);
                    }
                    else{
                        NSLog("Unsuccessful");
                        let alertFailure = UIAlertController(title: "Sorry", message: "The provided email address is taken.", preferredStyle: .alert);
                        alertFailure.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
                        self.present(alertFailure, animated: true);
                    }
                }
                else{
                    NSLog("No response from server.");
                }
            }
        };
        dataTask.resume();
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
