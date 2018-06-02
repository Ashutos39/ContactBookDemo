//
//  SaveContactViewController.swift
//  phoneBookAPP Demo
//
//  Created by Ashutos on 6/2/18.
//  Copyright © 2018 Ashutos. All rights reserved.
//

import UIKit
import CoreData

class SaveContactViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton! {
        didSet {
            saveBtn.layer.borderWidth = 2.0
            saveBtn.layer.borderColor = UIColor.lightGray.cgColor
            saveBtn.layer.cornerRadius = 2.0
        }
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var nameTxtFld: UITextField! {
        didSet {
            nameTxtFld.layer.borderWidth = 1.0
            nameTxtFld.layer.borderColor = UIColor.lightGray.cgColor
            nameTxtFld.layer.cornerRadius = 2.0
        }
    }
    
    @IBOutlet weak var mobileNumTxtFld: UITextField! {
        didSet {
            mobileNumTxtFld.layer.borderWidth = 1.0
            mobileNumTxtFld.layer.borderColor = UIColor.lightGray.cgColor
            mobileNumTxtFld.layer.cornerRadius = 2.0
            mobileNumTxtFld.delegate = self
        }
    }
    
    @IBOutlet weak var addressTxtFld: UITextField! {
        didSet {
            addressTxtFld.layer.borderWidth = 1.0
            addressTxtFld.layer.borderColor = UIColor.lightGray.cgColor
            addressTxtFld.layer.cornerRadius = 2.0
        }
    }
    
    @IBOutlet weak var designationTxtFld: UITextField! {
        didSet {
            designationTxtFld.layer.borderWidth = 1.0
            designationTxtFld.layer.borderColor = UIColor.lightGray.cgColor
            designationTxtFld.layer.cornerRadius = 2.0
        }
    }
    
    var ctrVariable : Int = 0
    var tapgesture = UITapGestureRecognizer()
    var userUpdate : [NSManagedObject] = []
    var isUpdate : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Alert
    func showAlert(withTitleMessageAndAction title:String, message:String , action: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        if action {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action : UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))
        } else{
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func update(){
        if isUpdate {
            nameTxtFld.text = userUpdate[0].value(forKey: "name") as? String
            mobileNumTxtFld.text = userUpdate[0].value(forKey: "mobileNumber") as? String
            designationTxtFld.text = userUpdate[0].value(forKey: "designation") as? String
            addressTxtFld.text = userUpdate[0].value(forKey: "address") as? String
            
            titleLbl.text = "Update the user Details"
            saveBtn.setTitle("Update", for: UIControlState.normal)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        if mobileNumTxtFld.text == "" || addressTxtFld.text == "" || nameTxtFld.text == "" || designationTxtFld.text == ""{
            showAlert(withTitleMessageAndAction: "Warning!!!!", message: "Please enter all fields", action: false)
            return
            
        } else if mobileNumTxtFld.text == "" {
            
            showAlert(withTitleMessageAndAction: "Warning!!!!", message: "Add contact mobile Number please", action: false)
            return
            
        } else if addressTxtFld.text == "" {
            
            showAlert(withTitleMessageAndAction: "Warning!!!!", message: "Add contact address  please", action: false)
            return
            
        } else if nameTxtFld.text == "" {
            showAlert(withTitleMessageAndAction: "Warning!!!!", message: "Add contacts name  please", action: false)
            return
            
        } else if designationTxtFld.text == "" {
            showAlert(withTitleMessageAndAction: "Warning!!!!", message: "Add contacts designation  please", action: false)
            return
        }
        
        view.endEditing(true)
        let _ = isUpdate ? updaterecord() : save()
    }
    
    //Save user details
    func save(){
        print("its working......")
        
        ctrVariable = ctrVariable + 1
        let managedObjectContext = (UIApplication.shared.delegate
            as! AppDelegate).persistentContainer.viewContext
        
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Contact",in: managedObjectContext)
        let contact = Contact(entity: entityDescription!,insertInto: managedObjectContext)
        contact.setValue(ctrVariable, forKeyPath: "id")
        
        contact.name = nameTxtFld.text!
        contact.address = addressTxtFld.text!
        contact.designation = designationTxtFld.text!
        contact.mobileNumber = mobileNumTxtFld.text!
        
        do {
            print("its saving.....")
            try managedObjectContext.save()
            userUpdate.append(contact)
            
            showAlert(withTitleMessageAndAction: "Sucess!!", message: "Your record has been saved sucessfully!!", action: true)
            
        } catch let error as NSError{
            showAlert(withTitleMessageAndAction: "Fail!!...", message: "Could not save\(error),\(error.userInfo)", action: false)
            
            print(error.localizedDescription)
        }
    }
    
    func updaterecord(){
        let managedObjectContext = (UIApplication.shared.delegate
            as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        
        let predicate = NSPredicate(format: "name = %@", (userUpdate[0].value(forKey: "name") as! String))
        
        
        
        fetchRequest.predicate = predicate
        do{
            let test = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            if test.count == 1
            {
                let contact = test[0] as NSManagedObject
                
                contact.setValue((userUpdate[0].value(forKey: "id") as! Int), forKeyPath: "id")
                contact.setValue(nameTxtFld.text!, forKey: "name")
                contact.setValue(addressTxtFld.text!, forKey: "address")
                contact.setValue(designationTxtFld.text!, forKey: "designation")
                contact.setValue(mobileNumTxtFld.text!, forKey: "mobileNumber")
                
                do {
                    print("its Updateing.....")
                    try managedObjectContext.save()
                    
                    showAlert(withTitleMessageAndAction: "Sucess!!", message: "Your record has been updated sucessfully!!", action: true)
                } catch let error as NSError {
                    let errorDialog = UIAlertController(title: "Error!", message: "Failed to save! \(error): \(error.userInfo)", preferredStyle: .alert)
                    errorDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    present(errorDialog, animated: true)
                    
                    print(error.localizedDescription)
                }
            }
        }
        catch{
            print(error)
        }
        
    }
}
