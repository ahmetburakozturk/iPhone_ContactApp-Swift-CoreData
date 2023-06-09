//
//  addContactViewController.swift
//  ContactsApp
//
//  Created by ahmetburakozturk on 27.05.2023.
//

import UIKit
import CoreData

let appdelegate = UIApplication.shared.delegate as! AppDelegate

class addContactViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let context = appdelegate.persistentContainer.viewContext

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var addPhotoButton: UIButton!
    
    @IBOutlet var contactImageView: UIImageView!
    @IBOutlet var phoneNumberTextField: UITextField!
    
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var companyLabel: UITextField!
    @IBOutlet var nameLabel: UITextField!
    
    @IBOutlet var lastNameLabel: UITextField!
    @IBOutlet var mainView: UIView!
    
    var selectedContactID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        mainView.addGestureRecognizer(tap)
        
        deleteButton.isHidden = true
        
        if selectedContactID != nil {
            deleteButton.isHidden = false
            getData()
        }
        
    }
    
    @objc private func hideKeyboard() {
       view.endEditing(true)
    }

    func getData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "id = %@", selectedContactID!.uuidString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let contactResult = try context.fetch(fetchRequest)
            for contact in contactResult as! [NSManagedObject] {
                if let name = contact.value(forKey: "name") as? String {
                    nameLabel.text = name
                }
                if let phoneNumber = contact.value(forKey: "phonenumber") as? String {
                    phoneNumberTextField.text = phoneNumber
                }
                if let surname = contact.value(forKey: "lastname") as? String {
                    lastNameLabel.text = surname
                }
                if let image = contact.value(forKey: "photo") as? Data {
                    contactImageView.image = UIImage(data: image)
                }
                if let mail = contact.value(forKey: "mail") as? String {
                    emailTextField.text = mail
                }
                if let company = contact.value(forKey: "company") as? String {
                    companyLabel.text = company
                }
            }
        } catch {
            print("Fetch Error!")
        }
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonClick(_ sender: Any) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "id = %@", selectedContactID!.uuidString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let contactResult = try context.fetch(fetchRequest)
            for contact in contactResult as! [NSManagedObject] {
                do {
                    context.delete(contact)
                    try context.save()
                    NotificationCenter.default.post(name: NSNotification.Name("contactAdded"), object: nil)
                    self.navigationController?.popToRootViewController(animated: true)
                }catch{
                    print("Update Error!")
                }
            }
        } catch {
            print("Fetch Error!")
        }
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        if selectedContactID == nil {
            let ContactTable = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context)
            if nameLabel.text != "" && nameLabel.text!.count > 1 {
                ContactTable.setValue(nameLabel.text, forKey: "name")
            } else {
                showNilFieldValueAlert(msg: "please enter a valid name!")
            }
            ContactTable.setValue(lastNameLabel.text, forKey: "lastname")
            ContactTable.setValue(companyLabel.text, forKey: "company")
            ContactTable.setValue(emailTextField.text, forKey: "mail")
            if let phoneNumber = Int(phoneNumberTextField.text!) {
                ContactTable.setValue(String(phoneNumber), forKey: "phonenumber")
            } else {
                showNilFieldValueAlert(msg: "please enter a valid phone number!")
            }
            ContactTable.setValue(UUID(), forKey: "id")
            if let imageData = contactImageView.image?.jpegData(compressionQuality: 0.5) {
                ContactTable.setValue(imageData, forKey: "photo")
            } else {
                ContactTable.setValue(UIImage(named: "contact")?.jpegData(compressionQuality: 0.5), forKey: "photo")
            }
            do{
                if nameLabel.text != "" && nameLabel.text!.count > 1 && Int(phoneNumberTextField.text!) != nil{
                    try context.save()
                    NotificationCenter.default.post(name: NSNotification.Name("contactAdded"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    showNilFieldValueAlert(msg: "Plese check name or phone number!")
                }
                
            } catch {
                print("Context Save Error!")
            }
        } else {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
            fetchRequest.predicate = NSPredicate(format: "id = %@", selectedContactID!.uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let contactResult = try context.fetch(fetchRequest)
                for contact in contactResult as! [NSManagedObject] {
                    if nameLabel.text != "" && nameLabel.text!.count > 1 {
                        contact.setValue(nameLabel.text, forKey: "name")
                    } else {
                        showNilFieldValueAlert(msg: "please enter a valid name!")
                    }
                    contact.setValue(lastNameLabel.text, forKey: "lastname")
                    contact.setValue(companyLabel.text, forKey: "company")
                    contact.setValue(emailTextField.text, forKey: "mail")
                    if let phoneNumber = Int(phoneNumberTextField.text!) {
                        contact.setValue(String(phoneNumber), forKey: "phonenumber")
                    } else {
                        showNilFieldValueAlert(msg: "please enter a valid phone number!")
                    }
                    contact.setValue(UUID(), forKey: "id")
                    if let imageData = contactImageView.image?.jpegData(compressionQuality: 0.5) {
                        contact.setValue(imageData, forKey: "photo")
                    } else {
                        contact.setValue(UIImage(named: "contact")?.jpegData(compressionQuality: 0.5), forKey: "photo")
                    }
                    do {
                        try context.save()
                        NotificationCenter.default.post(name: NSNotification.Name("contactAdded"), object: nil)
                        self.navigationController?.popToRootViewController(animated: true)
                    }catch{
                        print("Update Error!")
                    }
                }
            } catch {
                print("Fetch Error!")
            }
        }
        
        
    }
    
    
    func showNilFieldValueAlert(msg:String){
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    @IBAction func addButtonClick(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        contactImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}


