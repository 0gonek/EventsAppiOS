//
//  SmallEventsDTO.swift
//  EventsApp
//
//  Created by Alexey on 28.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import ObjectMapper

class SmallEventsDTO: Mappable{
    
    var eventsArray: [SmallEventDTO]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        eventsArray <- map["pojoEvents"]
    }
    
}
