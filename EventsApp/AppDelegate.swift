//
//  AppDelegate.swift
//  EventsApp
//
//  Created by Alexey on 07.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyVK

var vkDelegateReference : SwiftyVKDelegate?



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyBu7ecpHo8t79Nr_mtHNA--jLlY4aFIhJY")
        GMSPlacesClient.provideAPIKey("AIzaSyBu7ecpHo8t79Nr_mtHNA--jLlY4aFIhJY")
        vkDelegateReference = VKDelegate()
        VK.setUp(appId: "6219519", delegate: vkDelegateReference!)
        (vkDelegateReference as! VKDelegate).silentLogin()
//        do{
//            try (vkDelegateReference as! VKDelegate).silentLogin()
//        }
//        catch
//        {
//            let message : String
//            if error is AppError
//            {
//                message = (error as! AppError).getMessage()
//            }
//            else{
//                message = "Internal error occured: " + error.localizedDescription
//            }
//            let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
//            self.inputViewController?.present(alert, animated: true, completion: nil)
//        }
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let app = options[.sourceApplication] as? String
        VK.handle(url: url, sourceApplication: app)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        VK.handle(url: url, sourceApplication: sourceApplication)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

