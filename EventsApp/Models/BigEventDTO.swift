//
//  BigEventDTO.swift
//  EventsApp
//
//  Created by Alexey on 27.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import ObjectMapper


class BigEventDTO : Mappable
{
    public var id: Int64?
    public var name: String?
    public var ownerId: Int64?
    public var latitude: Double?
    public var longitude: Double?
    public var date: Int64?
    public var duration: Int64?
    public var privacy: Bool?
    public var description: String?
    public var pathToThePicture: String?
    public var type: Int?
    public var participants: Int64?
    public var groupId: Int64?
    public var groupName: String?
    public var isAccepted: Bool?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        ownerId <- map["ownerId"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        date <- map["date"]
        duration <- map["duration"]
        privacy <- map["privacy"]
        description <- map["description"]
        pathToThePicture <- map["pathToThePucture"]
        type <- map["type"]
        participants <- map["participants"]
        groupId <- map["groupId"]
        groupName <- map["groupName"]
        isAccepted <- map["accepted"]
    }
    
    public init(){
        
    }
}
