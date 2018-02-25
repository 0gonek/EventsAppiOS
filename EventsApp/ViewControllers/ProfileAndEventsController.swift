//
//  ProfileAndEvents.swift
//  EventsApp
//
//  Created by Alexey on 23.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import UIKit

class ProfileAndEventsViewController : UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var profileImageShadow: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textNameHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var backImgHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageHeightConstrant: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var textName: UILabel!
    
    
    let maxHeaderHeight: CGFloat = 220
    let minHeaderHeight: CGFloat = 55
    
    let maxBackImageHeight:CGFloat = 110
    let minBackImageHeight:CGFloat = 0
    
    let maxProfileImageHeightConstrant: CGFloat = 100
    let maxProfileImageWidthConstrant: CGFloat = 100
    
    var previousScrollOffset : CGFloat = 0
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = "Хуй соси, губой тряси \(indexPath.row)"
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    override func viewDidLoad() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backImg.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backImg.addSubview(blurEffectView)
        profileImg.setRounded()
        
        profileImageShadow.layer.shadowColor = UIColor.black.cgColor
        profileImageShadow.layer.shadowOffset = CGSize.zero
        profileImageShadow.layer.shadowOpacity = 1
        profileImageShadow.layer.shadowRadius = 3
        profileImageShadow.backgroundColor = UIColor(white: 1, alpha: 0)
        profileImageShadow.layer.borderWidth = 3
        profileImageShadow.layer.borderColor = UIColor.white.cgColor
        profileImageShadow.layer.cornerRadius = (profileImageShadow.frame.width/2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerHeightConstraint.constant = self.maxHeaderHeight
        backImgHeightConstraint.constant = maxBackImageHeight
        textName.layer.opacity = 1
    }
}
extension ProfileAndEventsViewController : UITableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        if canAnimateHeader(scrollView) {
            
            // Calculate new header height
            var newHeight = self.headerHeightConstraint.constant
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
            }
            
            // Header needs to animate
            if newHeight != self.headerHeightConstraint.constant {
                self.headerHeightConstraint.constant = newHeight
                self.updateHeader()
                self.setScrollPosition(self.previousScrollOffset)
            }
            
            self.previousScrollOffset = scrollView.contentOffset.y
        }
    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
        
        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func updateHeader() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
        let closeAmount = self.maxHeaderHeight - self.headerHeightConstraint.constant
        if((maxBackImageHeight - closeAmount)<0)
        {
            backImgHeightConstraint.constant = minBackImageHeight
        }
        else{
            backImgHeightConstraint.constant = maxBackImageHeight - closeAmount
        }
        
        //text hiding
        if(openAmount==range)
        {
            textName.layer.opacity=1
        }
        else
        {
            textName.layer.opacity = Float(openAmount/range) - 0.5
        }
        
        //profile pic hiding
        if(closeAmount < maxProfileImageHeightConstrant)
        {
            profileImageHeightConstrant.constant = maxProfileImageHeightConstrant - closeAmount
            profileImageWidthConstrant.constant = maxProfileImageWidthConstrant - closeAmount
            profileImageShadow.layer.cornerRadius = (profileImageShadow.frame.width/2)
            profileImageShadow.layer.opacity = 1
        }

        else if(closeAmount >= maxProfileImageHeightConstrant)
        {
            profileImageShadow.layer.opacity = 0
        }
        profileImg.setRounded()

    }
}




















