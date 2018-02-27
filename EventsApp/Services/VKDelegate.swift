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
    
    let scopes: Scopes = [.offline]
    let connectionUrl = "http://13.74.42.169:8080/users/loginvk"
    public static var user: LoginDTO? = nil
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        /*if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            rootController.present(viewController, animated: true)
        }*/
        if let topController = UIApplication.topViewController()
        {
            /*viewController.modalPresentationStyle = .overCurrentContext
            let temp = topController.storyboard?.instantiateViewController(withIdentifier: "AuthScreen") as! UIViewController
            topController.navigationController?.pushViewController(temp, animated: true)*/
            topController.present(viewController, animated: true)
            //topController.present(viewController, animated:  true, completion: nil)
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
        if let lol = Mapper<LoginDTO>().map(JSONObject: responce.json)
        {
            updateDefaults(id: info["user_id"]!, token: info["access_token"]!, authType: "VK", name: lol.name!, avatar: lol.avatar!, serverID: lol.serverId ?? 0)
            VKDelegate.user = lol
        }
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {

        let responce = Just.post(connectionUrl,
                                 data: [
                                    "integration_id":info["user_id"]!,
                                    "token":info["access_token"]!])
        if(!responce.ok)
        {
            updateDefaults()
            return
        }
        
        if let lol = Mapper<LoginDTO>().map(JSONObject: responce.json)
        {
            updateDefaults(id: info["user_id"]!, token: info["access_token"]!, authType: "VK", name: lol.name!, avatar: lol.avatar!, serverID: lol.serverId ?? 0)
            VKDelegate.user = lol
        }
    }
    
    func vkTokenRemoved(for sessionId: String) {
        updateDefaults()
        VKDelegate.user = nil
    }
    
    public func silentLogin() -> Bool
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
                return false
            }
            if let lol = Mapper<LoginDTO>().map(JSONObject: responce.json)
            {
                let defaults = UserDefaults.standard
                updateDefaults(id: defaults.string(forKey: defaultsKeys.name)!, token: defaults.string(forKey: defaultsKeys.token)!, authType: "VK", name: lol.name!, avatar: lol.avatar!, serverID: lol.serverId ?? 0)
                VKDelegate.user = lol
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
