//
//  ViewController.swift
//  Test1
//
//  Created by Jean MIQUEL on 10/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var lastnames : [String] = []
    
    
    @IBOutlet weak var personsTable: UITableView!
    
    
    
    @IBAction func addAction(_ sender: Any) {
        let alert = UIAlertController(title: "Nouveau nom",
                                      message: "Ajouter un nom", preferredStyle: .alert)
        
        
        let saveAction = UIAlertAction(title: "Ajouter", style: .default)
        {
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            self.lastnames.append(nameToSave)
            self.personsTable.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Annuler", style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return lastnames.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = self.personsTable.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCell
        cell.lastNameLabel.text = self.lastnames[indexPath.row]
        return cell
    }




}

