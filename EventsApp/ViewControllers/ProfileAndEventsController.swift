//
//  ProfileAndEvents.swift
//  EventsApp
//
//  Created by Alexey on 23.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import UIKit

class ProfileAndEventsViewController : UIViewController{
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var profileImageShadow: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textName: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textNameHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var backImgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var profileImageWidthConstrant: NSLayoutConstraint!
    
    @IBOutlet weak var btnAddEvent: UIButton!
    
    @IBAction func segmentedControlIndexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            eventsList = APIWorker.getMySmallEvents()
            tableView.reloadData()
        case 1:
            eventsList = APIWorker.getUpcomingSmallEvents()
            tableView.reloadData()
        case 2:
            eventsList = APIWorker.getPastSmallEvents()
            tableView.reloadData()
        default:
            eventsList = APIWorker.getMySmallEvents()
            tableView.reloadData()
        }
    }
    @IBAction func btnAddClicked(_ sender: UIButton)
    {
        let addViewController = AddEventViewController()
        self.navigationController?.pushViewController(addViewController, animated: true)
    }
    
    let maxHeaderHeight: CGFloat = 220
    let minHeaderHeight: CGFloat = 55
    
    let maxBackImageHeight:CGFloat = 110
    let minBackImageHeight:CGFloat = 0
    
    let maxProfileImageHeightConstrant: CGFloat = 100
    let maxProfileImageWidthConstrant: CGFloat = 100
    
    var previousScrollOffset : CGFloat = 0
    
    var eventsList: [SmallEventDTO] = [SmallEventDTO]()
    var firstLogin : Bool = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let user = getUserDTO()
        textName.text = user.name
        if let avatar = user.avatar
        {
            if let url = URL(string: avatar) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            {
                do{
                    let data = try Data(contentsOf: url)
                    profileImg.image = UIImage(data: data)
                    backImg.image = UIImage(data: data)
                }
                catch
                {
                    
                }
            }
        }
        
        customizePics()
        eventsList = APIWorker.getMySmallEvents()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellToEventSegue" ,
            let nextScene = segue.destination as? EventBigController ,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedEvent = APIWorker.getEventInfo(eventsList[indexPath.row].id!)
            nextScene.currentEvent = selectedEvent
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLogin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    private func checkLogin()
    {
        if(firstLogin)
        {
            if(UserDefaults.standard.string(forKey: defaultsKeys.authType)=="" || UserDefaults.standard.string(forKey: defaultsKeys.authType)==nil)
            {
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(loginViewController, animated: false)
                firstLogin = false
            }
        }
    }
    
    private func getUserDTO() -> LoginDTO
    {
        let defaults = UserDefaults.standard
        return LoginDTO(name: defaults.string(forKey: defaultsKeys.name),
                        avatar: defaults.string(forKey: defaultsKeys.avatar),
                        serverId: Int64(defaults.string(forKey: defaultsKeys.serverId) ?? "") ?? 0)
    }
    
    private func customizePics()
    {
        customizeBackPic()
        customizeProfilePic()
    }
    
    private func customizeBackPic()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backImg.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backImg.addSubview(blurEffectView)
    }
    private func customizeProfilePic()
    {
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
}

class EventsCell : UITableViewCell{
    
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var txtContent: UILabel!
}

extension ProfileAndEventsViewController : UITableViewDataSource
{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsList.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCell", for: indexPath) as! EventsCell
        cell.txtLabel.text = eventsList[indexPath.row].name
        cell.txtContent.text = eventsList[indexPath.row].description
        cell.txtDate.text = formatDate(eventsList[indexPath.row].date!)
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    private func formatDate(_ mill: Int64) -> String
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: Date(milliseconds: mill))
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
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
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
            profileImageShadow.layer.opacity = 1
            
        }
        else if(closeAmount >= maxProfileImageHeightConstrant)
        {
            profileImageShadow.layer.opacity = 0
        }
        profileImageShadow.layer.cornerRadius = (profileImageWidthConstrant.constant/2)
        profileImg.layer.cornerRadius = (profileImageWidthConstrant.constant/2)
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            let alert = UIAlertController(title: "Alert", message: "Add realization", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        delete.backgroundColor = UIColor.red
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
        }
        edit.backgroundColor = UIColor.blue
        
        return [edit, delete]
    }
}




















