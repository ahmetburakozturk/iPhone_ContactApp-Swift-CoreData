//
//  ViewController.swift
//  ContactsApp
//
//  Created by ahmetburakozturk on 27.05.2023.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contactsTableView: UITableView!
    
    let context = appDelegate.persistentContainer.viewContext
    var contactList = [ContactModel]()
    var filteredContactlist = [ContactModel]()
    var isSearching:Bool = false
    var selectedCoontactID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        searchBar.delegate = self
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "contactAdded"), object: nil)
        
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toAddPage", sender: nil)
    }
    
    
    
    @objc func getData(){
        contactList.removeAll(keepingCapacity: false)
        filteredContactlist.removeAll(keepingCapacity: false)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let resultList = try context.fetch(fetchRequest)
            for result in resultList as! [NSManagedObject] {
                let newContact : ContactModel = ContactModel()
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
                contactList.append(newContact)
            }
            contactsTableView.reloadData()
            
        }catch{
            print("Fetch Error!")
        }
    }
}

extension ViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredContactlist.count
        }
        else {
            return contactList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! customTableViewCell
        if isSearching {
            filteredContactlist = filteredContactlist.sorted(by:{$0.name! < $1.name!})
            cell.contactNameLabel.text = "\(filteredContactlist[indexPath.row].name!) \(filteredContactlist[indexPath.row].lastName!)"
            cell.smallContactImageView.image = UIImage(data: filteredContactlist[indexPath.row].image!)
        } else {
            contactList = contactList.sorted(by:{$0.name! < $1.name!})
            cell.contactNameLabel.text = "\(contactList[indexPath.row].name!) \(contactList[indexPath.row].lastName!)"
            cell.smallContactImageView.image = UIImage(data: contactList[indexPath.row].image!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            selectedCoontactID = filteredContactlist[indexPath.row].id
        } else {
            selectedCoontactID = contactList[indexPath.row].id
        }
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.selectedContactID = selectedCoontactID
        }
    }
}


extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != ""{
            isSearching = true
            filteredContactlist = contactList.filter({$0.name!.lowercased().prefix(searchText.count) == searchText.lowercased()})
        } else {
            isSearching = false
        }

        contactsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        contactsTableView.reloadData()
    }
    
    
    
}

