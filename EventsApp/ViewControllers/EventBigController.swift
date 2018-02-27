//
//  EventBigController.swift
//  EventsApp
//
//  Created by Alexey on 27.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import UIKit

class EventBigController : UIViewController
{
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true

        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
}
