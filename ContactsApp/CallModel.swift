//
//  CallModel.swift
//  ContactsApp
//
//  Created by ahmetburakozturk on 4.06.2023.
//

import Foundation
class CallModel{
    var callerName: String?
    var callStarTime: Date?
    var isMissed: Bool?
    var callType: String?
    var id: UUID?
    var totalCallTime: Int32?

    init(){
        
    }
    
    init(callerName: String? = nil, callStarTime: Date? = nil, isMissed: Bool? = nil, callType: String? = nil, id: UUID? = nil, totalCallTime: Int32? = nil) {
        self.callerName = callerName
        self.callStarTime = callStarTime
        self.isMissed = isMissed
        self.callType = callType
        self.id = id
        self.totalCallTime = totalCallTime
    }
    

}
