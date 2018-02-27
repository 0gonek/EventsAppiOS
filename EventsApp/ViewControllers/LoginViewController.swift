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
            UIApplication.topViewController()?.navigationController?.popToRootViewController(animated: true)
            let alert = UIAlertController(title: "All done", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        },
                            onError: {error in
            let alert = UIAlertController(title: "Error occured", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
                                
        })
    }
    
    @IBAction func btnFbClick(_ sender: UIButton) {
        APIWorker.logout()
        let kek = Just.get("http://13.74.42.169:8080/test/hello")
        
        let message = "Successfully logged in"
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }

}

