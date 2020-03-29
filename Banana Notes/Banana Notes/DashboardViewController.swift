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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NSLog("Ferris Bueller");
        NSLog(userID.description);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
