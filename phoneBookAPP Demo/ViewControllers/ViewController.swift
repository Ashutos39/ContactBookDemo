//
//  ViewController.swift
//  phoneBookAPP Demo
//
//  Created by Ashutos on 6/2/18.
//  Copyright © 2018 Ashutos. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    let managedObjectContext = (UIApplication.shared.delegate
        as! AppDelegate).persistentContainer.viewContext
    
  
    var people: [NSManagedObject] = []
    var ctrVariable : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        getdata()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addContactBtnPressed(_ sender: Any) {
        
        saveController()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let person = people[indexPath.row]
        cell.textLabel?.text = person.value(forKeyPath: "name") as! String? ?? ""
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "SaveContactViewController") as! SaveContactViewController
        let singleUser: [NSManagedObject] = [people[indexPath.row] as NSManagedObject]
        vc.userUpdate = singleUser
        vc.isUpdate = true
        navigationController?.pushViewController(vc,animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let alertController = UIAlertController(title: "Warning!", message: "You're about to delete this stuff right meow.", preferredStyle: .alert)
            let delete = UIAlertAction(title: "Okay", style: .destructive, handler: { action in
                //1
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                managedContext.delete(self.people[indexPath.row] as NSManagedObject)
                do {
                    try managedContext.save()
                    self.getdata()
                    tableView.reloadData()
                } catch _ {
                    
                }
            })
            
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(delete)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
        }
            
        
    }
    
    
//    addnew push
    func saveController(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SaveContactViewController") as! SaveContactViewController
        vc.isUpdate = false
        vc.ctrVariable = ctrVariable
        navigationController?.pushViewController(vc,animated: true)
    }
    
    func getdata() {
        
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Contact",
                                       in: managedObjectContext)
        
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetchRequest.entity = entityDescription
        
        do {
            //go get the results
            people = try managedObjectContext.fetch(fetchRequest)

        } catch {
            print("Error with request: \(error)")
        }
    }
}

