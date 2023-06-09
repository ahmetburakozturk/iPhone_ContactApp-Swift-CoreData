//
//  callViewController.swift
//  ContactsApp
//
//  Created by ahmetburakozturk on 4.06.2023.
//

import UIKit
import CoreData

let dlg = UIApplication.shared.delegate as! AppDelegate
let ctx = dlg.persistentContainer.viewContext

class callViewController: UIViewController {

    @IBOutlet weak var callTableView: UITableView!
    
    var allCallList = [CallModel]()
    var missedCallList = [CallModel]()
    var isMissedSegment = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callTableView.delegate = self
        callTableView.dataSource = self
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newCallAdded"), object: nil)
        getData()
    }
    
    @objc func getData(){
        allCallList.removeAll(keepingCapacity: false)
        missedCallList.removeAll(keepingCapacity: false)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Call")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let resultList = try ctx.fetch(fetchRequest)
            for result in resultList as! [NSManagedObject] {
                let newCall : CallModel = CallModel()
                if let type = result.value(forKey: "callType") as? String{
                    newCall.callType = type
                }
                if let callerName = result.value(forKey: "callerName") as? String {
                    newCall.callerName = callerName
                }
                if let isMissed = result.value(forKey: "isMissed") as? Bool {
                    newCall.isMissed = isMissed
                }
                if let callStarTime = result.value(forKey: "callStartTime") as? Date {
                    newCall.callStarTime = callStarTime
                }
                if let totalCallTime = result.value(forKey: "totalCallTime") as? Int32 {
                    newCall.totalCallTime = totalCallTime
                }
                if let id = result.value(forKey: "id") as? UUID {
                    newCall.id = id
                }
                allCallList.append(newCall)
                if newCall.isMissed == true {
                    missedCallList.append(newCall)
                }
                callTableView.reloadData()
            }

            
        }catch{
            print("Fetch Error!")
        }
    }
    
    @IBAction func callSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            isMissedSegment = false
            callTableView.reloadData()
        case 1:
            isMissedSegment = true
            callTableView.reloadData()
        default:
            break
        }
    }
    
}

extension callViewController: UITableViewDelegate, UITableViewDataSource, callsTableViewCellProtocol {
    func showInfo(index: IndexPath) {
        print("info")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMissedSegment {
            return missedCallList.count
        } else {
            return allCallList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        if isMissedSegment {
            missedCallList = missedCallList.sorted(by:{$0.callStarTime! > $1.callStarTime!})
            let cell = tableView.dequeueReusableCell(withIdentifier: "callCell", for: indexPath) as! callsTableViewCell
            cell.contactFullNameLabel.text = missedCallList[indexPath.row].callerName
            cell.contactFullNameLabel.textColor = UIColor.red
            cell.callTimeLabel.text = dateFormatter.string(from: missedCallList[indexPath.row].callStarTime!)
            cell.callTimeLabel.textColor = UIColor.red
            cell.callTypeLabel.text = missedCallList[indexPath.row].callType
            cell.idxPath = indexPath
            return cell
        } else {
            allCallList = allCallList.sorted(by:{$0.callStarTime! > $1.callStarTime!})
            let cell = tableView.dequeueReusableCell(withIdentifier: "callCell", for: indexPath) as! callsTableViewCell
            cell.contactFullNameLabel.text = allCallList[indexPath.row].callerName
            cell.callTimeLabel.text = dateFormatter.string(from: allCallList[indexPath.row].callStarTime!)
            if allCallList[indexPath.row].isMissed == true{
                cell.contactFullNameLabel.textColor = UIColor.red
                cell.callTimeLabel.textColor = UIColor.red
            } else {
                cell.contactFullNameLabel.textColor = UIColor.black
                cell.callTimeLabel.textColor = UIColor.gray
            }
            cell.callTypeLabel.text = allCallList[indexPath.row].callType
            cell.idxPath = indexPath
            return cell
        }
        
    }
    
    
}
