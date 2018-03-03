//
//  ChangeEventDTO.swift
//  EventsApp
//
//  Created by Alexey on 03.03.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import ObjectMapper

class ChangeEventDTO : Mappable{
    var ownerId: Int64?
    var token: String?
    var id: Int64?
    var latitude: Double?
    var longitude: Double?
    var date: Int64?
    var duration: Int64?
    var privacy: Bool?
    var description: String?
    var picture: [UInt8]?
    
    required init?(map: Map) {
        
    }
    
    init(ownerId: Int64?,token: String?, latitude: Double?, longitude: Double? , date: Int64?,duration: Int64?,privacy: Bool?, description: String?, picture: [UInt8]?, id: Int64)
    {

        self.ownerId = ownerId
        self.token = token
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.duration = duration
        self.privacy = privacy
        self.description = description
        self.picture = picture
        self.id = id;
    }
    
    func mapping(map: Map) {
        ownerId <- map["ownerId"]
        token <- map["token"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        date <- map["date"]
        duration <- map["duration"]
        privacy <- map["privacy"]
        description <- map["description"]
        picture <- map["picture"]
        id <- map["id"]
    }
    
}
