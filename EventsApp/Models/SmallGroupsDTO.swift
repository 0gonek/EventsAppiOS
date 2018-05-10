//
//  SmallGroupsDTO.swift
//  EventsApp
//
//  Created by Alexey on 10.05.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import ObjectMapper

class SmallGroupsDTO: Mappable{
    var groupsArray: [SmallGroupDTO]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        groupsArray <- map["pojoGroupIdNames"]
    }
}
