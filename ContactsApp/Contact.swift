//
//  Contact.swift
//  ContactsApp
//
//  Created by ahmetburakozturk on 27.05.2023.
//

import Foundation

class ContactModel {
    var id : UUID?
    var name : String?
    var lastName : String?
    var image : Data?
    var company : String?
    var phoneNumber : Int?
    var mail : String?
    var isFavorite : Bool?
    
    init(){}
    
    init(id: UUID? = nil, name: String? = nil, lastName: String? = nil, image: Data? = nil, company: String? = nil, phoneNumber: Int? = nil, mail: String? = nil, isFavorite : Bool? = nil) {
        self.id = id
        self.name = name
        self.lastName = lastName
        self.image = image
        self.company = company
        self.phoneNumber = phoneNumber
        self.mail = mail
        self.isFavorite = isFavorite
    }
  

}
