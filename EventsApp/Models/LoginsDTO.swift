
//
//  LoginsDTO.swift
//  EventsApp
//
//  Created by Alexey on 01.03.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginsDTO: Mappable
{
    var loginsArray: [LoginDTO]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        loginsArray <- map["pojoNameAndAvatars"]
    }
    
        
}
