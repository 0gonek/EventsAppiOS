//
//  SecondViewController.swift
//  EventsApp
//
//  Created by Alexey on 07.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//
import UIKit
import SwiftyVK
import Just

class LoginViewController: UIViewController {

    @IBAction func btnVkclick(_ sender: UIButton) {
        
        APIWorker.logout()
        APIWorker.authorize(success: { info in
            UIApplication.shared.keyWindow!.rootViewController!.present(self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController, animated: true)
        },
                            onError: {error in
            let alert = UIAlertController(title: "Error occured", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
                                
        })
    }
    @IBAction func btnFbClick(_ sender: UIButton) {
        APIWorker.logout()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: defaultsKeys.authType)=="VK"
        {
            UIApplication.shared.keyWindow!.rootViewController!.present(self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }

}

