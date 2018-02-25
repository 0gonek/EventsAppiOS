//
//  Error.swift
//  EventsApp
//
//  Created by Alexey on 22.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

public class AppError : Error{
    
    private let _message : String
    
    init(_ message: String = "InternalError")
    {
        _message = message
    }
    
    public func getMessage() -> String
    {
        return _message
    }
}
