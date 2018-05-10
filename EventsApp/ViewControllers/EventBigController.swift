//
//  EventBigController.swift
//  EventsApp
//
//  Created by Alexey on 27.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import UIKit
import KFSwiftImageLoader
import JGProgressHUD

class EventBigController : UIViewController
{
    var currentEvent : BigEventDTO = BigEventDTO()
    var currentEventId : Int64 = -1
    
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtTime: UILabel!
    @IBOutlet weak var txtDuration: UILabel!
    @IBOutlet weak var btnParticipants: UIButton!
    @IBOutlet weak var txtGroup: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventInfoView: UIView!
    
    @IBOutlet weak var btnShowOnMap: UIButton!
    
    @IBAction func btnShowOnMapClick(_ sender: UIButton) {
        let kek = self.storyboard?.instantiateViewController(withIdentifier: "singleEventMap") as! SingleEventMapViewController
        kek.currentEvent = currentEvent
        self.navigationController?.pushViewController(kek, animated: true)
    }
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(animated)
        APIWorker.getEventInfo(currentEventId){ result in
            if(result != nil)
            {
                self.currentEvent = result!
                self.txtName.text = self.currentEvent.name!
                self.txtTime.text = self.formatDate(self.currentEvent.date!)
                self.txtDuration.text = String(Int(self.currentEvent.duration!/1000/60)) + " hours"
                self.btnParticipants.setTitle( self.currentEvent.participants!==1 ? String(describing: self.currentEvent.participants!) + " person" : String(describing: self.currentEvent.participants!) + " people", for: .normal)
                self.txtGroup.text = self.currentEvent.groupName ?? "public"
                self.txtDescription.text = self.currentEvent.description!
                self.txtName.sizeToFit()
                self.btnParticipants.sizeToFit()
                self.txtDescription.sizeToFit()
                if let image = self.currentEvent.pathToThePicture
                {
                    self.imgEvent.loadImage(urlString: "http://188.134.92.52:1725/events/get_picture?path=" + image, placeholderImage: UIImage(named: "profile-1"))
                }
                if(self.currentEvent.ownerId != Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!))
                {
                    if(!self.currentEvent.isAccepted!)
                    {
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Go!", style: .plain, target: self, action: #selector(EventBigController.goTapped(_:)))
                    }
                    else{
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(EventBigController.leaveTapped(_:)))
                    }
                }
                else{
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(EventBigController.editTapped(_:)))
                }
                
            }
        };
        var temp = ""
        temp += "kek"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.title = "Event"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showParticipants")
        {
            let nextScene = segue.destination as? ParticipantsController
            nextScene!.eventId = currentEvent.id!
        }
    }
    
    private func formatDate(_ mill: Int64) -> String
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: Date(milliseconds: mill))
    }
    @objc func editTapped(_ sender: UIBarButtonItem)
    {
        let kek = EditEventViewController()
        kek.currentEvent = currentEvent
        self.navigationController?.pushViewController(kek, animated: true)
    }
    @objc func goTapped(_ sender: UIBarButtonItem)
    {
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        if(APIWorker.participateInEvent(currentEvent.id!))
        {
            hud.dismiss(animated: true)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(EventBigController.leaveTapped(_:)))
        }
    }
    @objc func leaveTapped(_ sender: UIBarButtonItem)
    {
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        if(APIWorker.deleteParticipantOfEvent(currentEvent.id!))
        {
            hud.dismiss(animated: true)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Go!", style: .plain, target: self, action: #selector(EventBigController.goTapped(_:)))
        }
    }
}

