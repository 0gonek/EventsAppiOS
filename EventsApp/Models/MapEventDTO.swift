//
//  MapEventDTO.swift
//  EventsApp
//
//  Created by Alexey on 23.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import ObjectMapper
class MapEventDTO :Mappable{
    
    var id: Int64?
    var latitude: Double?
    var longtitude: Double?
    var type: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        latitude <- map["latitude"]
        longtitude <- map["longtitude"]
        type <- map["type"]
    }
}
