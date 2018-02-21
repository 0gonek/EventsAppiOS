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
    //MARK: Actions
    
    @IBAction func btnVkclick(_ sender: UIButton) {
        


        APIWorker.authorize(success: { info in
            
            self.dismiss(animated: false, completion: nil)
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
            self.dismiss(animated: false, completion: nil)
            
        })
    }
    
    @IBAction func btnFbClick(_ sender: UIButton) {
        APIWorker.logout()
        //let kek = Just.get("http://192.168.1.79:8080/test/hello")
        
        let message = "Successfully logged in"
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

