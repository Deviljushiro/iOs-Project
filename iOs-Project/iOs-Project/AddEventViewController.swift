//
//  AddEventViewController.swift
//  iOs-Project
//
//  Created by Julien GALLEGO on 25/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    
    
    //MARK: - View loading

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Change the text color of the pickers
        self.startDate.setValue(UIColor.white, forKeyPath: "textColor")
        self.endDate.setValue(UIColor.white, forKeyPath: "textColor")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Actions
    
    
    /// Go to the previous page
    ///
    /// - Parameter sender: who send the action
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// Save the input and create the event
    ///
    /// - Parameter sender: who send the action
    @IBAction func saveAction(_ sender: Any) {
        guard let title = self.titleField.text, title != "" else {
            DialogBoxHelper.alert(view: self, WithTitle: "Création impossible", andMsg: "Titre manquant")
            return
        }
        
        //Get inputs and dates then their string form
        let body = self.body.text ?? ""
        let start = self.startDate.date
        let end = self.endDate.date
        
        //If the dates are correct in time
        if start <= DateManager.currentDate() || end <= start {
            DialogBoxHelper.alert(view: self, WithTitle: "Création impossible", andMsg: "Dates erronées")
            return
        }
        else {
            //Create the event in the DB
            Evenement.createNewEvent(title: title, body: body, start: start, end: end)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
