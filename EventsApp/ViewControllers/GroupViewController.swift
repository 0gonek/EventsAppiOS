//
//  GroupViewController.swift
//  EventsApp
//
//  Created by Alexey on 10.05.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

class GroupViewController : UIViewController{
    
    @IBOutlet weak var imgGroup: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    var currentGroupId: Int64 = -1
    var currentGroup: GroupDTO?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        APIWorker.getGroupInfo(groupId: currentGroupId){result in
            if(result != nil)
            {
                self.currentGroup = result;
                self.txtName.text = result?.name
                self.txtDescription.text = result?.description
                self.imgGroup.loadImage(urlString: "http://188.134.92.52:1725/groups/get_picture?path=" + (result?.picture)!, placeholderImage: UIImage(named: "profile-1"))
                if(self.currentGroup!.ownerId != Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!))
                {
                    if(!self.currentGroup!.accepted!)
                    {
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Enter", style: .plain, target: self, action: #selector(EventBigController.goTapped(_:)))
                    }
                    else{
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(EventBigController.leaveTapped(_:)))
                    }
                }
                else{
                    
                }
            }
        }
    }
    @objc func goTapped(_ sender: UIBarButtonItem)
    {
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        APIWorker.participateInGroup(groupId: currentGroup!.id!){ result in
            if(result != nil && result!)
            {
                hud.dismiss(animated: true)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(EventBigController.leaveTapped(_:)))
            }
        }
    }
    @objc func leaveTapped(_ sender: UIBarButtonItem)
    {
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        APIWorker.leaveGroup(groupId: currentGroup!.id!){ result in
            if(result != nil && result!)
            {
                hud.dismiss(animated: true)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Enter", style: .plain, target: self, action: #selector(EventBigController.goTapped(_:)))
            }
        }
    }
    
    
}
