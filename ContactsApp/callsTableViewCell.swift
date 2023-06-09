//
//  callsTableViewCell.swift
//  ContactsApp
//
//  Created by ahmetburakozturk on 4.06.2023.
//

import UIKit

protocol callsTableViewCellProtocol {
    func showInfo(index:IndexPath )
}

class callsTableViewCell: UITableViewCell {

    @IBOutlet weak var callTimeLabel: UILabel!
    @IBOutlet weak var callTypeLabel: UILabel!
    @IBOutlet weak var contactFullNameLabel: UILabel!
    @IBOutlet weak var phoneIconImageView: UIImageView!
    
    var tableViewCellProtocol : callsTableViewCellProtocol?
    var idxPath : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    @IBAction func infoButtonClicked(_ sender: Any) {
        tableViewCellProtocol?.showInfo(index: idxPath!)
    }
    
    
}
