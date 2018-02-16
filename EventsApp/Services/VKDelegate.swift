//
//  VKDelegate.swift
//  EventsApp
//
//  Created by Alexey on 16.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import SwiftyVK
import UIKit

final class VKDelegate: SwiftyVKDelegate {
    
    let appId = "6219519"
    let scopes: Scopes = [.messages,.offline,.friends,.wall,.photos,.audio,.video,.docs,.market,.email]
    
    init() {
        VK.setUp(appId: appId, delegate: self)
    }
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {

            if let rootController = UIApplication.shared.keyWindow?.rootViewController {
                rootController.present(viewController, animated: true)
            }
        
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        print("token created in session \(sessionId) with info \(info)")
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        print("token updated in session \(sessionId) with info \(info)")
    }
    
    func vkTokenRemoved(for sessionId: String) {
        print("token removed in session \(sessionId)")
    }
}
