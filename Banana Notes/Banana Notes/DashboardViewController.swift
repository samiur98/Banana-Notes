//
//  DashboardViewController.swift
//  Banana Notes
//
//  Created by Shah Samiur Rahman on 3/26/20.
//  Copyright © 2020 Shah Samiur Rahman. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    var userID = -1;
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NSLog(userID.description);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        stackView.spacing = 10;
        renderStackView();
        NSLog("Log");
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    @IBAction func goBack(_ sender: Any) {
        //Method that returns user to login page.
        NSLog("Back Button Pressed.");
        presentingViewController?.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func newNote(_ sender: Any) {
        //Method that instantiates a new NoteViewController View.
        let newNote = self.storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController;
        newNote.modalPresentationStyle = .fullScreen;
        newNote.userID = userID;
        newNote.updating = false;
        self.present(newNote, animated: true, completion: nil);
    }
    
    func renderStackView(){
        //Renders the stack view with notes in the user dashboard.
        NSLog("Rendering Stack View.");
        let getURLString = "http://localhost:3020/notes/getNotes/" + userID.description;
        let url = URL(string: getURLString);
        if(url == nil){
            NSLog("URL formatted incorrectly");
            self.generateDataAlert();
            return;
        }
        getRequest(url: url!);
    }
    
    func getRequest(url: URL){
        //GET request to API for user's notes.
        NSLog("Processing GET request.");
        let sharedSession = URLSession.shared;
        let request = URLRequest(url: url);
        
        let dataTask = sharedSession.dataTask(with: request){
            (data, response, apiError) in
            DispatchQueue.main.async {
                if let err = apiError{
                    NSLog("Error connecting to API.");
                    NSLog(err.localizedDescription);
                    self.generateDataAlert();
                    return;
                }
                if let res = response as? HTTPURLResponse{
                    if(res.statusCode == 500){
                        NSLog("Server side error.");
                        self.generateDataAlert();
                        return;
                    }
                }
                do{
                    let jsonArray = try JSONSerialization.jsonObject(with: data! , options: .mutableContainers) as? [[String: Any]];
                    NSLog(jsonArray!.description);
                    self.populateStackView(jsonArray: jsonArray!);
                }catch{
                    NSLog("Problem parsing JSON Array.")
                    self.generateDataAlert();
                }
            }
        }
        dataTask.resume();
    }
    
    func populateStackView(jsonArray : [[String: Any]]){
        //Adds notes retrieved from database to stackview as UI elements.
        NSLog("Populating Stack View.");
        for view in stackView.arrangedSubviews{
            stackView.removeArrangedSubview(view);
        }
        for counter in 0...jsonArray.count - 1{
            let noteTitle = jsonArray[counter]["title"] as! String;
            let noteID  = jsonArray[counter]["id"] as! Int;
            let note = getNote(noteID: noteID, noteTitle: noteTitle);
            stackView.addArrangedSubview(note);
        }
        
    }
    
    func getNote(noteID: Int, noteTitle: String) -> UIView{
        let returnButton = UIButton();
        let heightConstraint = NSLayoutConstraint(item: returnButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200);
        let widthConstraint = NSLayoutConstraint(item: returnButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 650);
        returnButton.addConstraint(heightConstraint);
        returnButton.addConstraint(widthConstraint);
        returnButton.backgroundColor = .white;
        returnButton.setTitle(noteTitle, for: .normal);
        returnButton.setTitleColor(.darkText, for: .normal);
        return returnButton;
    }
    
    func generateDataAlert(){
        let alertData = UIAlertController(title: "Internal Error", message: "Sorry could not gather you're notes.", preferredStyle: .alert);
        alertData.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
        self.present(alertData, animated: true);
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
