//
//  ListViewController.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var lastnames : [String] = ["jean","julien"]
    var listePersonnes: [Personne] = []
    
    @IBOutlet weak var personnes: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = self.personnes.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! ListTableViewCell
        cell.nom.text = self.listePersonnes[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.lastnames.count
    }

    
    
    @IBAction func addAction(_ sender: Any) {
        self.performSegue(withIdentifier: "addSegue", sender: self)
    }

    @IBAction func dismissNextAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    // MARK: - Navigation

     let segueShowPersonId = "addSegue"
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
