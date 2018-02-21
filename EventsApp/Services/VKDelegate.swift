//
//  VKDelegate.swift
//  EventsApp
//
//  Created by Alexey on 16.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import SwiftyVK
import UIKit
import Just

struct defaultsKeys {
    static let authType = "authType"
    static let id = "netId"
    static let token = "token"
}

final class VKDelegate: SwiftyVKDelegate {
    
    let scopes: Scopes = []
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {

            if let rootController = UIApplication.shared.keyWindow?.rootViewController {
                rootController.present(viewController, animated: true)
            }
        
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        var n, t : String
        print("token created in session \(sessionId) with info \(info)")
        let responce = Just.get("http://192.168.1.79:8080/users/loginvk",
                                 params: [
                                    "integration_id":info["user_id"]!,
                                    "token":info["access_token"]!])
        if let kek = responce.json as? [String: Any]{
            if let name = kek["name"] as? String {
                n = name;
            }
        }
        updateDefaults(id: info["user_id"]!, token: info["access_token"]!, authType: "VK")
        
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        let responce = Just.post("http://192.168.1.79:8080",
                                 data: [
                                    "integration_id":info["user_id"],
                                    "token":info["access_token"]])
        updateDefaults(id: "", token: "", authType: "")
    }
    
    func vkTokenRemoved(for sessionId: String) {
        updateDefaults(id: "", token: "", authType: "")
    }
    
    public func silentLogin() -> Bool
    {
        if(UserDefaults.standard.string(forKey: defaultsKeys.authType)=="")
        {
            return false
        }
        let responce = Just.post("http://192.168.1.79:8080",
                                 data: [
                                    "integration_id":UserDefaults.standard.string(forKey: defaultsKeys.id),
                                    "token":UserDefaults.standard.string(forKey: defaultsKeys.token)])
        return true
        
    }
    
    private func updateDefaults(id: String, token: String, authType: String)
    {
        let defaults = UserDefaults.standard;
        defaults.set(authType, forKey: defaultsKeys.authType)
        defaults.set(token, forKey: defaultsKeys.token)
        defaults.set(id, forKey: defaultsKeys.id)
    }
    
}
