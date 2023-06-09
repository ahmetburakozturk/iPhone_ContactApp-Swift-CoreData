//
//  DetailViewController.swift
//  ContactsApp
//
//  Created by Mustafa Öztürk on 28.05.2023.
//

import UIKit
import CoreData

let appDlg = UIApplication.shared.delegate as! AppDelegate

class DetailViewController: UIViewController {
    @IBOutlet var contactFullNameLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var contactImageView: UIImageView!
    
    var selectedContactID : UUID?
    
    let context = appDlg.persistentContainer.viewContext
    var currentContact : ContactModel? = ContactModel()
    
    @IBOutlet weak var addFavoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getData()
        contactFullNameLabel.text = "\(currentContact!.name!) \(currentContact!.lastName!)"
        phoneNumberLabel.text = "\(currentContact!.phoneNumber!)"
        if currentContact?.image != nil {
            contactImageView.image = UIImage(data: currentContact!.image!)
        }
    }
    
    func getData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "id = %@", selectedContactID!.uuidString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let contactResult = try context.fetch(fetchRequest)
            for contact in contactResult as! [NSManagedObject] {
                if let name = contact.value(forKey: "name") as? String {
                    currentContact!.name = name
                }
                if let phoneNumber = contact.value(forKey: "phonenumber") as? String {
                    currentContact?.phoneNumber = Int(phoneNumber) ?? 0
                }
                if let surname = contact.value(forKey: "lastname") as? String {
                    currentContact!.lastName = surname
                }
                if let image = contact.value(forKey: "photo") as? Data {
                    currentContact!.image = image
                }
                if let favorite = contact.value(forKey: "isFavorite") as? Bool{
                    currentContact?.isFavorite = favorite
                }
                if currentContact?.isFavorite == true {
                    addFavoriteButton.setTitle("remove from favorites", for: UIControl.State.normal)
                    addFavoriteButton.setTitleColor(UIColor.red, for: .normal)
                }
            }
        } catch {
            print("Fetch Error!")
        }
    }
    
    @IBAction func callButtonClicked(_ sender: Any) {
        let callTable = NSEntityDescription.insertNewObject(forEntityName: "Call", into: ctx)
        
        callTable.setValue("\(currentContact!.name!) \(currentContact!.lastName!)", forKey: "callerName")
        callTable.setValue(Date(), forKey: "callStartTime")
        callTable.setValue("mobile", forKey: "callType")
        callTable.setValue(UUID(), forKey: "id")
        callTable.setValue(false, forKey: "isMissed")
        callTable.setValue(6, forKey: "totalCallTime")
        do{
            try ctx.save()
            NotificationCenter.default.post(name: NSNotification.Name("newCallAdded"), object: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    @IBAction func editButtonClick(_ sender: Any) {
    }
    @IBAction func addFavoriteButtonClicked(_ sender: Any) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "id = %@", selectedContactID!.uuidString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let contactResult = try context.fetch(fetchRequest)
            for contact in contactResult as! [NSManagedObject] {
                if let favorite = contact.value(forKey: "isFavorite") as? Bool{
                    currentContact?.isFavorite = favorite
                }
                if currentContact?.isFavorite == false || currentContact?.isFavorite == nil {
                    contact.setValue(true, forKey: "isFavorite")
                    addFavoriteButton.setTitle("remove from favorites", for: UIControl.State.normal)
                    addFavoriteButton.setTitleColor(UIColor.red, for: .normal)
                } else {
                    contact.setValue(false, forKey: "isFavorite")
                    addFavoriteButton.setTitle("add to favorites", for: UIControl.State.normal)
                    addFavoriteButton.setTitleColor(UIColor.tintColor, for: .normal)
                }
                do{
                    try context.save()
                }catch{
                    print(error.localizedDescription)
                }
                NotificationCenter.default.post(name: NSNotification.Name("newOperationInFavs"), object: nil)
            }
        } catch {
            print("Fetch Error!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editVC" {
            let destinationVC = segue.destination as! addContactViewController
            destinationVC.selectedContactID = selectedContactID!
        }
    }
    
}
