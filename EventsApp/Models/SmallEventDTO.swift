//
//  SmallEventDTO.swift
//  EventsApp
//
//  Created by Alexey on 23.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import ObjectMapper

class SmallEventDTO : Mappable{
    
    var id: Int64?
    var name: String?
    var description: String?
    var date: Int64?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        date <- map["date"]
    }

    init(){
        id = 0
        name = "Imma name"
        description = "Imma description"
        date = 1000109
    }
}
