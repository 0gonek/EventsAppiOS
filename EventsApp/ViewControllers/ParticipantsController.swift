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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
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
        if let url = URL(string: peopleList[indexPath.row].avatar!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        {
            do{
                let data = try Data(contentsOf: url)
                cell.imgPerson.image = UIImage(data: data)
            }
            catch
            {
                
            }
        }
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
