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
import ObjectMapper

struct defaultsKeys {
    static let authType = "authType"
    static let socialId = "netId"
    static let token = "token"
    static let avatar = "avatar"
    static let name = "name"
    static let serverId = "serverId"
}

final class VKDelegate: SwiftyVKDelegate {
    
    let scopes: Scopes = [.offline, .photos]
    let connectionUrl = "http://188.134.92.52:1725/users/loginvk"
    public static var user: LoginDTO? = nil
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        if let topController = UIApplication.topViewController()
        {
            topController.present(viewController, animated: true)
        }
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String])  {
        let responce = Just.get(connectionUrl,
                                 params: [
                                    "integration_id":info["user_id"]!,
                                    "token":info["access_token"]!])
        if(!responce.ok)
        {
            updateDefaults()
            return
        }
        let temp = responce.json
        if let lol = Mapper<LoginDTO>().map(JSONObject: temp)
        {
            updateDefaults(id: info["user_id"]!,
                           token: info["access_token"]!,
                           authType: "VK",
                           name: lol.name!,
                           avatar: lol.avatar ?? "",
                           serverID: lol.serverId ?? 0)
            VKDelegate.user = lol
        }
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {

        let responce = Just.get(connectionUrl,
                                 params: [
                                    "integration_id":info["user_id"]!,
                                    "token":info["access_token"]!])
        if(!responce.ok)
        {
            updateDefaults()
            return
        }
        
        if let lol = Mapper<LoginDTO>().map(JSONObject: responce.json)
        {
            updateDefaults(id: info["user_id"]!,
                           token: info["access_token"]!,
                           authType: "VK",
                           name: lol.name!,
                           avatar: lol.avatar ?? "",
                           serverID: lol.serverId ?? 0)
            VKDelegate.user = lol
        }
    }
    
    func vkTokenRemoved(for sessionId: String) {
        updateDefaults()
        VKDelegate.user = nil
    }
    
    public func silentLogin() -> Bool
    {
        let defaults = UserDefaults.standard

        if(defaults.string(forKey: defaultsKeys.authType)=="" || defaults.string(forKey: defaultsKeys.authType)==nil)
        {
            return false
        }
        else if(defaults.string(forKey: defaultsKeys.authType)=="VK")
        {
            let responce = Just.get(connectionUrl,
                                 params: [
                                    "integration_id":defaults.string(forKey: defaultsKeys.socialId)!,
                                    "token": defaults.string(forKey: defaultsKeys.token)!])
            if(!responce.ok)
            {
                updateDefaults()
                return false
            }
            if let lol = Mapper<LoginDTO>().map(JSONObject: responce.json)
            {
                updateDefaults(id: defaults.string(forKey: defaultsKeys.socialId)!,
                               token: defaults.string(forKey: defaultsKeys.token)!,
                               authType: "VK",
                               name: lol.name!,
                               avatar: lol.avatar ?? "",
                               serverID: lol.serverId ?? 0)
                VKDelegate.user = lol
            }
            else {
                updateDefaults()
                return false
            }
        }
        return true
    }

    private func updateDefaults(id: String = "", token: String = "",
                                authType: String = "", name: String = "",
                                avatar: String = "", serverID: Int64 = -1)
    {
        let defaults = UserDefaults.standard;
        defaults.set(authType, forKey: defaultsKeys.authType)
        defaults.set(token, forKey: defaultsKeys.token)
        defaults.set(id, forKey: defaultsKeys.socialId)
        defaults.set(serverID, forKey: defaultsKeys.serverId)
        defaults.set(avatar, forKey: defaultsKeys.avatar)
        defaults.set(name, forKey: defaultsKeys.name)
    }
    
    
    
}
