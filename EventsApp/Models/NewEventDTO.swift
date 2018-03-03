//
//  NewEventDTO.swift
//  EventsApp
//
//  Created by Alexey on 02.03.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import ObjectMapper

class NewEventDTO : Mappable, Encodable
{
    var name: String?
    var ownerId: Int64?
    var token: String?
    var latitude: Double?
    var longitude: Double?
    var date: Int64?
    var duration: Int64?
    var privacy: Bool?
    var description: String?
    var picture: [UInt8]?
    var type: Int?
    var groupId: Int64?
    
    required init?(map: Map) {
        
    }
    
    init(name: String?, ownerId: Int64?,token: String?, latitude: Double?, longitude: Double? , date: Int64?,duration: Int64?,privacy: Bool?, description: String?, picture: [UInt8]?,type: Int?, groupId: Int64? )
    {
        self.name = name
        self.ownerId = ownerId
        self.token = token
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.duration = duration
        self.privacy = privacy
        self.description = description
        self.picture = picture
        self.type = type
        self.groupId = groupId
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        ownerId <- map["ownerId"]
        token <- map["token"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        date <- map["date"]
        duration <- map["duration"]
        privacy <- map["privacy"]
        description <- map["description"]
        picture <- map["picture"]
        type <- map["type"]
        groupId <- map["groupId"]
    }
    
}
