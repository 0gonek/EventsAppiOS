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
    var currentEvent : BigEventDTO = BigEventDTO()
    
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtTime: UILabel!
    @IBOutlet weak var txtDuration: UILabel!
    @IBOutlet weak var btnParticipants: UIButton!
    @IBOutlet weak var txtGroup: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventInfoView: UIView!
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.text = currentEvent.name!
        txtTime.text = formatDate(currentEvent.date!)
        txtDuration.text = String(Int(currentEvent.duration!/1000/60)) + " hours"
        btnParticipants.setTitle( currentEvent.participants!==1 ? String(describing: currentEvent.participants!) + " person" : String(describing: currentEvent.participants!) + " people", for: .normal)
        txtGroup.text = currentEvent.groupName ?? "public"
        txtDescription.text = currentEvent.description!
        txtName.sizeToFit()
        btnParticipants.sizeToFit()
        txtDescription.sizeToFit()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.title = "Event"
        if(currentEvent.ownerId != Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!))
        {
            if(!currentEvent.isAccepted!)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showParticipants")
        {
            let nextScene = segue.destination as? ParticipantsController
            let participants = APIWorker.getEventParticipants(currentEvent.id!)
            nextScene?.peopleList = participants
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
        
    }
    @objc func goTapped(_ sender: UIBarButtonItem)
    {
        if(APIWorker.participateInEvent(currentEvent.id!))
        {
            let alert = UIAlertController(title: "", message: "You have become a participant!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok, thanks", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(EventBigController.leaveTapped(_:)))
        }
    }
    @objc func leaveTapped(_ sender: UIBarButtonItem)
    {
        if(APIWorker.deleteParticipantOfEvent(currentEvent.id!))
        {
            let alert = UIAlertController(title: "", message: "You have left the event :(", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yeah, I know", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Go!", style: .plain, target: self, action: #selector(EventBigController.goTapped(_:)))
        }
    }
}

