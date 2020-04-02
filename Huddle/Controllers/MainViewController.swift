//
//  ViewController.swift
//  Huddle
//
//  Created by Michael Lin on 3/14/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit
import Spring
import GoogleMaps
import FloatingPanel

class MainViewController: UIViewController {
    
    var mapView: GMSMapView!
    var fpController: FloatingPanelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), camera: camera)
        do {
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
              mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
              NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }

        self.view.addSubview(mapView)
        
        fpController = FloatingPanelController()
        self.view.addSubview(fpController.view)
        fpController.view.bounds = self.view.frame
        fpController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fpController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 300.0),
          fpController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
          fpController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0),
          fpController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
        ])
        self.addChild(fpController)
        fpController.show(animated: true) {
            self.fpController.didMove(toParent: self)
        }
        
        Manager.shared.locationManager.delegate = self
    }
    
    func addHuddleToMap(_ target: Huddle) {
        
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude,
        zoom: 16.0)
        mapView.animate(to: camera)
    }
}

extension MainViewController: GMSMapViewDelegate {
    
}
