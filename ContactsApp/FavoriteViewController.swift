//
//  FavoriteViewController.swift
//  ContactsApp
//
//  Created by ahmetburakozturk on 3.06.2023.
//

import UIKit
import CoreData

let delegate = UIApplication.shared.delegate as! AppDelegate
let context = delegate.persistentContainer.viewContext



class FavoriteViewController: UIViewController {
    
    var contactList = [ContactModel]()
    @IBOutlet weak var favoritesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newOperationInFavs"), object: nil)
        getData()
    }
    
    @objc func getData(){
        contactList.removeAll(keepingCapacity: false)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let resultList = try context.fetch(fetchRequest)
            for result in resultList as! [NSManagedObject] {
                let newContact : ContactModel = ContactModel()
                if let favorite = result.value(forKey: "isFavorite") as? Bool{
                    newContact.isFavorite = favorite
                }
                if let name = result.value(forKey: "name") as? String {
                    newContact.name = name
                }
                if let lastname = result.value(forKey: "lastname") as? String {
                    newContact.lastName = lastname
                }
                if let company = result.value(forKey: "company") as? String {
                    newContact.company = company
                }
                if let phonenumber = result.value(forKey: "phonenumber") as? Int {
                    newContact.phoneNumber = phonenumber
                }
                if let mail = result.value(forKey: "mail") as? String {
                    newContact.mail = mail
                }
                if let id = result.value(forKey: "id") as? UUID {
                    newContact.id = id
                }
                if let image = result.value(forKey: "photo") as? Data {
                    newContact.image = image
                }
                if newContact.isFavorite == true{
                    contactList.append(newContact)
                }
            }
            favoritesTableView.reloadData()
            
        }catch{
            print("Fetch Error!")
        }
    }

}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        contactList = contactList.sorted(by: {$0.name! < $1.name!})
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! customTableViewCell
        cell.contactNameLabel.text = "\(contactList[indexPath.row].name!) \(contactList[indexPath.row].lastName!)"
        cell.smallContactImageView.image = UIImage(data: contactList[indexPath.row].image!)
        return cell
    }
    
    
}
