//
//  FirstViewController.swift
//  EventsApp
//
//  Created by Alexey on 07.02.2018.
//  Copyright © 2018 HSE. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    var mapViewA : GMSMapView?
    var eventsList : [MapEventDTO]?
    
    override func loadView() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    private func setMap()
    {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 3)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        do {
            if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        mapView.delegate = self
        self.view = mapView
    }
}

extension MapViewController: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let projection = mapView.projection.visibleRegion()
        
        let topLeftCorner: CLLocationCoordinate2D = projection.farLeft
        let bottomRightCorner: CLLocationCoordinate2D = projection.nearRight
        eventsList = APIWorker.getMapEvents(minLat:
            bottomRightCorner.latitude < topLeftCorner.latitude ? bottomRightCorner.latitude: topLeftCorner.latitude,
                                            minLon:
            bottomRightCorner.longitude < topLeftCorner.longitude ? bottomRightCorner.longitude : topLeftCorner.longitude,
                                            maxLat:
            topLeftCorner.latitude > bottomRightCorner.latitude ? topLeftCorner.latitude : bottomRightCorner.latitude,
                                            maxLon:
            topLeftCorner.longitude > bottomRightCorner.longitude ? topLeftCorner.longitude : bottomRightCorner.longitude)
        for event in eventsList!
        {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: event.latitude!, longitude: event.longtitude!)
            marker.title = "Title"
            marker.snippet = "Snippet"
            marker.icon = UIImage(named: "mapMarker")
            marker.map = mapView
            marker.userData = event.id
            marker.tracksViewChanges = true
        }
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        let kek = self.storyboard?.instantiateViewController(withIdentifier: "EventBigController") as! EventBigController
        kek.currentEvent = APIWorker.getEventInfo(marker.userData as! Int64)
        self.navigationController?.pushViewController(kek, animated: true)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let event: BigEventDTO = APIWorker.getEventInfo(marker.userData as! Int64)
        marker.title = event.name
        marker.snippet = event.description
        return false
    }
}









