//
//  PromoViewController.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 21/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class PromoViewController: UIViewController {

    // MARK : - Outlet
    
    @IBOutlet weak var yearField: UITextField!
    
    // MARK : - View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK : - Actions
    
    
    /// Cancel the action
    ///
    /// - Parameter sender: who send the action
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// Create the new promotion and save it
    ///
    /// - Parameter sender: who send the action
    @IBAction func saveAction(_ sender: Any) {
        //check the year field
        guard let year = self.yearField.text, year != "" else {
            DialogBoxHelper.alert(view: self, WithTitle: "Création impossible", andMsg: "Année manquante")
            return
        }
        //create the new promo
        Promo.createNewPromo(year: year)
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
