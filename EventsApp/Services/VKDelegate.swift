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
    static let socialId = "netId"
    static let token = "token"
    static let avatar = "avatar"
    static let name = "name"
    static let serverId = "serverId"
}

final class VKDelegate: SwiftyVKDelegate {
    
    let scopes: Scopes = []
    let connectionUrl = "http://192.168.1.79:8080/users/loginvk"
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {

            if let rootController = UIApplication.shared.keyWindow?.rootViewController {
                rootController.present(viewController, animated: true)
            }
        
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String])  {
        var n = "", a = ""
        var s : Int64
        s = -1
        let responce = Just.get(connectionUrl,
                                 params: [
                                    "integration_id":info["user_id"]!,
                                    "token":info["access_token"]!])
        if(!responce.ok)
        {
            updateDefaults()
            return
        }
        if let kek = responce.json as? [String: Any]{
            if let name = kek["name"] as? String {
                n = name;
            }
            if let avatar = kek["avatar"] as? String{
                a = avatar;
            }
            if let serverID = kek["serverID"] as? Int64{
                s = serverID;
            }
        }
        updateDefaults(id: info["user_id"]!, token: info["access_token"]!, authType: "VK", name: n, avatar: a, serverID: s)
        
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        var n = "", a = ""
        var s : Int64
        s = -1
        
        let responce = Just.post(connectionUrl,
                                 data: [
                                    "integration_id":info["user_id"]!,
                                    "token":info["access_token"]!])
        if(!responce.ok)
        {
            updateDefaults()
            return
        }
        if let kek = responce.json as? [String: Any]{
            if let name = kek["name"] as? String {
                n = name;
            }
            if let avatar = kek["avatar"] as? String{
                a = avatar;
            }
            if let serverID = kek["serverID"] as? Int64{
                s = serverID;
            }
        }
        updateDefaults(id: info["user_id"]!, token: info["access_token"]!, authType: "VK", name: n, avatar: a, serverID: s)
        
    }
    
    func vkTokenRemoved(for sessionId: String) {
        updateDefaults()
    }
    
    public func silentLogin() throws -> Bool
    {
        if(UserDefaults.standard.string(forKey: defaultsKeys.authType)=="")
        {
            return false
        }
        else if(UserDefaults.standard.string(forKey: defaultsKeys.authType)=="VK")
        {
            let responce = Just.post(connectionUrl,
                                 data: [
                                    "integration_id":UserDefaults.standard.string(forKey: defaultsKeys.socialId)!,
                                    "token": UserDefaults.standard.string(forKey: defaultsKeys.token)!])
            if(!responce.ok)
            {
                throw AppError(responce.reason);
            }
            parseResponce(responce)
            
        }
        return true
        
    }
    
    private func parseResponce(_ responce : HTTPResult){
        var n="", a=""
        var s: Int64;
        s = -1
        if let kek = responce.json as? [String: Any]{
            if let name = kek["name"] as? String {
                n = name;
            }
            if let avatar = kek["avatar"] as? String{
                a = avatar;
            }
            if let serverID = kek["serverID"] as? Int64{
                s = serverID;
            }
        }
        updateDefaults(name: n, avatar: a, serverID: s)
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
