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
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    
    @IBOutlet weak var txtDuration: UILabel!
    @IBOutlet weak var txtDescription: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventInfoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.text = "lol kek 4ebureck imma be 2 lines rofl"
        var t1 = txtName.frame.height
        txtName.sizeToFit()
        var delta1 = txtName.frame.height - t1
        var t2 = txtDescription.frame.height
        txtDescription.sizeToFit()
        var delta2 = txtDescription.frame.height - t2
        var delta = delta1 + delta2;
        var kek = scrollView.frame.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    private func addBlur(view: UIView)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    func convertImageToBW(image:UIImage) -> UIImage {
        
        let filter = CIFilter(name: "CIPhotoEffectTransfer")
        
        // convert UIImage to CIImage and set as input
        
        let ciInput = CIImage(image: image)
        filter?.setValue(ciInput, forKey: "inputImage")
        
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        
        return UIImage(cgImage: cgImage!)
    }
}

