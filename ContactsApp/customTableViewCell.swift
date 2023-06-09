//
//  customTableViewCell.swift
//  ContactsApp
//
//  Created by ahmetburakozturk on 27.05.2023.
//

import UIKit

class customTableViewCell: UITableViewCell {

    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var smallContactImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
