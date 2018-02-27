//
//  LoginDTO.swift
//  EventsApp
//
//  Created by Alexey on 23.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginDTO: Mappable
{
    var serverId : Int64?
    var avatar: String?
    var name: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        serverId <- map["serverID"]
        avatar <- map["avatar"]
        name <- map["name"]
    }
    init(name: String?, avatar: String?, serverId: Int64)
    {
        self.serverId = serverId
        self.name = name
        self.avatar = avatar
    }
}
