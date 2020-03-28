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
        if(!validateEmail()){
            NSLog("Email Address Field not formatted properly.")
            self.generateEmailAlert();
            return;
        }
        if(!validatePassword()){
            NSLog("Password Field not formatted properly.")
            self.generatePasswordAlert();
            return;
        }
        let getURLString = "http://localhost:3020/users/getUser/" + self.emailTextField.text! + "/" + self.passwordTextField.text!;
        let url = URL(string: getURLString);
        if(url == nil){
            NSLog("URL formatted incorectly");
            self.generateErrorAlert();
            return;
        }
        getRequest(url: url!);
    }
    
    func getRequest(url: URL){
        let sharedSession = URLSession.shared;
        let request = URLRequest(url: url);
        
        let dataTask = sharedSession.dataTask(with: request){
            (data, response, apiError) in
            DispatchQueue.main.async {
                if let error = apiError{
                    NSLog("Error connecting to API.");
                    NSLog(error.localizedDescription);
                    self.generateErrorAlert();
                    return;
                }
                if let res = response as? HTTPURLResponse{
                    if(res.statusCode == 404){
                        NSLog("User not found");
                        self.generateUserAlert();
                        return;
                    }
                    if(res.statusCode == 403){
                        NSLog("Username and/or password incorrect");
                        self.generateFailuerAlert();
                        return;
                    }
                }
                do{
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any];
                    NSLog(jsonData!.description);
                    let dashBoard = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController;
                    self.present(dashBoard, animated: true, completion: nil);
                }catch{
                    NSLog("Problem parsing JSON");
                    self.generateErrorAlert();
                }
            }
        }
        
        dataTask.resume();
    }
    
    func generateErrorAlert(){
        let alertInternal = UIAlertController(title: "Internal Issue", message: "Sorry there has been an internal issue.", preferredStyle: .alert);
        alertInternal.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
        self.present(alertInternal, animated: true);
    }
    
    func generateEmailAlert(){
        let alertEmail = UIAlertController(title: "Email not formatted correctly", message: "Please provide a value for the email address field.", preferredStyle: .alert);
        alertEmail.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
        self.present(alertEmail, animated: true);
    }
    
    func generatePasswordAlert(){
        let alertPassword = UIAlertController(title: "Password not formatted correctly", message: "Please provide a value for the password field that is at least 8 charachters long.", preferredStyle: .alert);
        alertPassword.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
        self.present(alertPassword, animated: true);
    }
    
    func generateSuccessAlert(){
        let alertSuccess = UIAlertController(title: "Success", message: "Welcome!", preferredStyle: .alert);
        alertSuccess.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
        self.present(alertSuccess, animated: true);
    }
    
    func generateFailuerAlert(){
        let alertFailure = UIAlertController(title: "Sorry", message: "Provided email address and/or password is incorrect.", preferredStyle: .alert);
        alertFailure.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
        self.present(alertFailure, animated: true);
    }
    
    func generateUserAlert(){
        let userFailure = UIAlertController(title: "User not found", message: "User with the provided email address does not exist.", preferredStyle: .alert);
        userFailure.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
        self.present(userFailure, animated: true);
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
