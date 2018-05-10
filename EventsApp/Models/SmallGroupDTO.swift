//
//  GroupDTO.swift
//  EventsApp
//
//  Created by Alexey on 10.05.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import ObjectMapper

class SmallGroupDTO: Mappable{
    var id: Int64?
    var name: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }

}
