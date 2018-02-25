//
//  ProfileTabController.swift
//  EventsApp
//
//  Created by Alexey on 22.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import UIKit

public class ProfileTabController: UINavigationController
{
    override public func viewDidLoad() {
        
        if(UserDefaults.standard.string(forKey: defaultsKeys.authType)=="")
        {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
            self.dismiss(animated: false, completion: nil)
        }
    }
}
