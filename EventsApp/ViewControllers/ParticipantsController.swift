//
//  ParticipantsViewController.swift
//  EventsApp
//
//  Created by Alexey on 01.03.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import UIKit

class ParticipantsController : UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var peopleList: [LoginDTO] = [LoginDTO]()
    var eventId : Int64 = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        APIWorker.getEventParticipants(eventId){result in
            self.peopleList = result ?? []
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.title = "Participants"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.title = ""
    }
}

class PersonCell :  UITableViewCell
{
    
    @IBOutlet weak var imgPerson: UIImageView!
    
    @IBOutlet weak var txtName: UILabel!
}

extension ParticipantsController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell") as! PersonCell
        cell.txtName.text = peopleList[indexPath.row].name
        cell.imgPerson.loadImage(urlString: peopleList[indexPath.row].avatar!)
        cell.imgPerson.setRounded()
        cell.imgPerson.setRounded()
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

extension ParticipantsController : UITableViewDelegate
{
    
}
