//
//  SingleEventMap.swift
//  EventsApp
//
//  Created by Alexey on 03.03.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces

class SingleEventMapViewController:UIViewController{
    var currentEvent: BigEventDTO?
    var mapViewA : GMSMapView?
    var eventsList : [MapEventDTO]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.title = "Event"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.title = ""
    }
    private func setMap()
    {
        let camera = GMSCameraPosition.camera(withLatitude: (currentEvent?.latitude)!, longitude: (currentEvent?.longitude)!, zoom: 10)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
        mapView.isMyLocationEnabled = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: currentEvent!.latitude!, longitude: currentEvent!.longitude!)
        marker.title = currentEvent!.name
        marker.snippet = currentEvent!.description
        marker.icon = UIImage(named: "mapMarker")
        marker.map = mapView
        
        do {
            if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        self.view = mapView
    }
     
}
