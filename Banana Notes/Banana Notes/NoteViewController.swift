//
//  NoteViewController.swift
//  Banana Notes
//
//  Created by Shah Samiur Rahman on 3/28/20.
//  Copyright © 2020 Shah Samiur Rahman. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    var updating = false;
    var noteID = -1;
    var userID = -1;
    var noteTitle: String?;
    var noteText: String?;
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        //Back Button that returns user to dashboard.
        NSLog("Back Button Pressed.");
        presentingViewController?.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func updateOrAdd(_ sender: Any) {
        //Method that either adds or updates a note.
        NSLog("Add/Update Button Pressed.");
        if(!fieldCheck()){
            NSLog("Fields not filled out properly.")
            return;
        }
        if(updating){
            //updateRequest();
        }
        else{
            let postURLString = "http://localhost:3020/notes/addNote/" + self.userID.description + "/" + self.titleField.text! + "/" + self.textView.text;
            let url = URL(string: postURLString);
            if(url == nil){
                NSLog("URL formatted incorrectly.")
                self.generateErrorAlert();
                return;
            }
            postRequest(url: url!);
        }
    }
    
    
    @IBAction func deleteNote(_ sender: Any) {
    }
    
    func fieldCheck() -> Bool{
        //Checks whether or not the fields have been foenatted correctly.
        if(titleField == nil){
            NSLog("Title field is nil");
            generateErrorAlert();
            return false;
        }
        if(textView == nil){
            NSLog("Text View is nil");
            generateErrorAlert();
            return false;
        }
        if((titleField.text?.count) == 0){
            NSLog("No Title");
            generateTitleAlert();
            return false;
        }
        if((textView.text?.count) == 0){
            NSLog("No Text in Text View.");
            generateEmptyAlert();
            return false;
        }
        return true;
    }
    
    func postRequest(url: URL){
        //POST request to REST API to add/register a new note.
        let sharedSession = URLSession.shared;
        var request = URLRequest(url: url);
        request.httpMethod = "POST";
        
        let dataTask = sharedSession.dataTask(with: request) {
            (data, response, apiError) in
            DispatchQueue.main.async {
                if let err = apiError{
                    NSLog("Error connecting to API");
                    NSLog(err.localizedDescription);
                    self.generateErrorAlert();
                }
                if let res = response as? HTTPURLResponse{
                    if(res.statusCode == 400){
                        NSLog("Length of note is too large.")
                        self.generateLengthAlert();
                    }
                    if(res.statusCode == 500){
                        NSLog("Server Error while adding new note.")
                        self.generateErrorAlert();
                    }
                    if(res.statusCode == 201){
                        NSLog("Sucessfully added new note.");
                        self.presentingViewController?.dismiss(animated: true, completion: nil);
                    }
                }
            }
        }
        dataTask.resume();
    }
    
    func generateErrorAlert(){
        //Error Alert for internal issues.
        let alertInternal = UIAlertController(title: "Internal Issue", message: "Sorry there has been an internal issue.", preferredStyle: .alert);
        alertInternal.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
        self.present(alertInternal, animated: true);
    }
    
    func generateTitleAlert(){
        //Alert for empty title.
        let alertTitle = UIAlertController(title: "No Title", message: "Please add a Title to you're note.", preferredStyle: .alert);
        alertTitle.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
        self.present(alertTitle, animated: true);
    }
    
    func generateEmptyAlert(){
        //Alert for empty note.
        let alertEmpty = UIAlertController(title: "Note Empty", message: "There is nothing to add.", preferredStyle: .alert);
        alertEmpty.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
        self.present(alertEmpty, animated: true);
    }
    
    func generateLengthAlert(){
        //Alert for note being too large.
        let alertLength = UIAlertController(title: "Length Too Long", message: "Sorry, the length of the note is too long to be processed.", preferredStyle: .alert);
        alertLength.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
        self.present(alertLength, animated: true);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
