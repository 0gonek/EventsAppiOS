//
//  EditEventViewController.swift
//  EventsApp
//
//  Created by Alexey on 03.03.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import Eureka
import LocationPicker
import CoreLocation


class EditEventViewController : FormViewController
{
    var currentEvent: BigEventDTO?
    var currentEventId: Int64 = -1
    var chosenLocation : Location?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func showAlert(msg: String)
    {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok, i'll fix", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        if(currentEventId != -1)
        {
            self.currentEvent = APIWorker.getEventInfoSync(currentEventId)
        }
        
        super.viewDidLoad()
        
        form +++ Section("General")

            <<< TextRow(){ row in
                row.title = "Description"
                row.placeholder = "Enter text here"
                row.tag = "description"
                row.value = currentEvent?.description
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< ImageRow(){
                $0.title = "Event image"
                $0.tag = "image"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }
            
            <<< SwitchRow(){ row in
                row.title = "Private"
                row.tag = "private"
                row.value = currentEvent?.privacy
            }
            
            +++ Section("Start")
            <<< DateRow(){
                $0.title = "Start Date"
                $0.value = Date(milliseconds: currentEvent!.date!)
                $0.tag = "startDate"
            }
            <<< TimeRow() {
                $0.title = "Start time"
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                formatter.locale = Locale(identifier: "ru_RU")
                $0.dateFormatter = formatter
                $0.value = Date(milliseconds: currentEvent!.date!)
                $0.tag = "startTime"
            }
            
            
            +++ Section("Finish")
            
            <<< DateRow(){
                $0.title = "Finish Date"
                $0.value = Date(milliseconds: currentEvent!.date! + currentEvent!.duration!)
                $0.tag = "finishDate"
            }
            <<< TimeRow() {
                $0.title = "Finish time"
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                formatter.locale = Locale(identifier: "ru_RU")
                $0.dateFormatter = formatter
                $0.value = Date(milliseconds: currentEvent!.date! + currentEvent!.duration!)
                $0.tag = "finishTime"
            }
            
            +++ Section("Location")
            <<< ButtonRow() {btn in
                btn.title = "Pick location"
                }
                .onCellSelection { [weak self] (cell, row) in
                    let locationPicker = LocationPickerViewController()
                    locationPicker.showCurrentLocationButton = false
                    locationPicker.showCurrentLocationInitially = true
                    locationPicker.useCurrentLocationAsHint = true
                    locationPicker.searchBarPlaceholder = "Search places"
                    locationPicker.mapType = .standard
                    locationPicker.searchHistoryLabel = "Previously searched"
                    locationPicker.resultRegionDistance = 400
                    locationPicker.completion = { location in
                        self?.chosenLocation = location
                        row.title = location?.address
                        row.updateCell()
                    }
                    self?.navigationController?.pushViewController(locationPicker, animated: true)
            }
            +++ Section()
            <<< ButtonRow() {btn in
                btn.title = "Finish"
                }
                .onCellSelection { [weak self] (cell, row) in
                    let row2: TextRow? = self?.form.rowBy(tag: "description")
                    let row3: ImageRow? = self?.form.rowBy(tag: "image")
                    
                    if(!(row2?.isValid)!){
                        self?.showAlert(msg: "Description must be specified")
                        return
                    }
                    if(self?.chosenLocation == nil)
                    {
                        self?.showAlert(msg: "Location must be selected")
                        return
                    }
                    
                    let valuesDictionary = self?.form.values()
                    let calendar = Calendar.current

                    let startTime = (valuesDictionary!["startTime"] as! Date)
                    let finishTime = (valuesDictionary!["finishTime"] as! Date)
                    
                    let startHour : Int64 = Int64(calendar.component(.hour, from: startTime))
                    let startMinutes : Int64 = Int64(calendar.component(.minute, from: startTime))
                    let finishHour : Int64 = Int64(calendar.component(.hour, from: finishTime))
                    let finishMinutes : Int64 = Int64(calendar.component(.minute, from: finishTime))
                    
                    let startDate: Int64 = (valuesDictionary!["startDate"] as! Date).millisecondsSince1970 + startHour * Int64(360000) + startMinutes * Int64(60000)
                    let finishDate: Int64 = (valuesDictionary!["finishDate"] as! Date).millisecondsSince1970 + finishHour * Int64(360000) + finishMinutes * Int64(60000)
                    
                    let imgData : [UInt8]
                    if(row3?.value != nil)
                    {
                        imgData = [UInt8](UIImageJPEGRepresentation(valuesDictionary!["image"] as! UIImage, 0.3)!)
                    }
                    else
                    {
                        imgData = [UInt8]()
                    }
                    
                    if(startDate < Date().millisecondsSince1970)
                    {
                        self!.showAlert(msg: "You can not create event in past")
                        return
                    }
                    
                    if(startDate >= finishDate)
                    {
                        self!.showAlert(msg: "Finish date can not be later than start date")
                        return
                    }
                    
                    let kek = ChangeEventDTO(
                                          ownerId: Int64(UserDefaults.standard.string(forKey: defaultsKeys.serverId)!),
                                          token: UserDefaults.standard.string(forKey: defaultsKeys.token)!,
                                          latitude: self?.chosenLocation?.coordinate.latitude,
                                          longitude:self?.chosenLocation?.coordinate.longitude,
                                          date: startDate,
                                          duration: finishDate - startDate,
                                          privacy: valuesDictionary!["private"] as? Bool,
                                          description: valuesDictionary!["description"] as? String,
                                          picture: imgData,
                                          id: (self?.currentEvent?.id)!
                    )
                    
                    let temp = APIWorker.changeEvent(kek)
                    if(temp)
                    {
                        self?.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        
                    }
        }
    }
}


