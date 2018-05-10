//
//  GroupDTO.swift
//  EventsApp
//
//  Created by Alexey on 10.05.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import ObjectMapper

class GroupDTO: Mappable{
    var id: Int64?
    var name: String?
    var ownerId: Int64?
    var privacy: Bool?
    var description: String?
    var picture: String?
    var type: Int?
    var accepted: Bool?
    var participants: Int64?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        ownerId <- map["ownerId"]
        privacy <- map["privacy"]
        description <- map["description"]
        picture <- map["picture"]
        type <- map["type"]
        participants <- map["participants"]
        accepted <- map["accepted"]
    }
    
    public init(){
        
    }
}
