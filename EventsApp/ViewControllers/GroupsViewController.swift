//
//  GroupsViewController.swift
//  EventsApp
//
//  Created by Alexey on 06.05.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import UIKit

class GroupsViewController : UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
   
    private var groupsList: [SmallGroupDTO] = [SmallGroupDTO]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIWorker.getMyGroups(completion: { (result) in
            self.groupsList = result ?? []
            self.tableView.reloadData()
            })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "cellToGroupSegue")
        {
            let nextScene = segue.destination as? GroupViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            nextScene!.currentGroupId = groupsList[indexPath!.row].id!
        }
    }
    
}

extension GroupsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        cell.txtName.text = groupsList[indexPath.row].name
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
}

extension GroupsViewController: UISearchBarDelegate{
    
}
class GroupCell : UITableViewCell{
    @IBOutlet weak var txtName: UILabel!
}
