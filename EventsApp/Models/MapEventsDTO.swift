//
//  MapEvents.swift
//  EventsApp
//
//  Created by Alexey on 02.03.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import ObjectMapper
class MapEventsDTO: Mappable
{
    var eventsList: [MapEventDTO]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        eventsList <- map["pojoEvents"]
    }
    
    
}
