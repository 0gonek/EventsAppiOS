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

class ProfileViewController: UIViewController {
    //MARK: Actions
    
    @IBAction func btnVkclick(_ sender: UIButton) {
        VK.setUp(appId: "6219519", delegate: VKDelegate())
        APIWorker.action(2)
        APIWorker.action(1)
    }
    
    @IBAction func btnFbClick(_ sender: UIButton) {
        let kek = Just.get("http://192.168.1.79:8080/test/hello")
        
        let alert = UIAlertController(title: "Imma mafuccccin test", message: kek.content?.base64EncodedString(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))

        
        self.present(alert, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

