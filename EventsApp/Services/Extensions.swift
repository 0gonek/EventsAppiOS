//
//  Extentions.swift
//  EventsApp
//
//  Created by Alexey on 25.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2) 
        self.layer.masksToBounds = true
    }
}
