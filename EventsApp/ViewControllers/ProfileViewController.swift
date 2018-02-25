//
//  ProfileViewController.swift
//  EventsApp
//
//  Created by Alexey on 21.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {

    
    
    @IBAction func onLogOutClick(_ sender: Any)
    {
        APIWorker.logout()
        if(UserDefaults.standard.string(forKey: defaultsKeys.authType)=="")
        {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
            self.dismiss(animated: false, completion: nil)
        }
    }
    override func viewDidLoad() {
        
    }
}
