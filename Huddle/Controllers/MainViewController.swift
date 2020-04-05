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
    var huddlePanelVC: HuddlePanelVC!
    var myLocationMarker: GMSMarker!
    var currentLocationLock: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), camera: camera)
        self.view.addSubview(mapView)
        do {
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
              mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
              NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 230,
            right: 0
        )
        Manager.shared.locationManager.delegate = self

        self.view.addSubview(mapView)
        
        fpController = FloatingPanelController()
        self.view.addSubview(fpController.view)
        fpController.view.bounds = self.view.frame
        fpController.delegate = self
        fpController.surfaceView.cornerRadius = 9.0
        fpController.surfaceView.shadowHidden = false
        fpController.surfaceView.backgroundColor = .clear
        fpController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fpController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
          fpController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
          fpController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0),
          fpController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
        ])
        huddlePanelVC = storyboard?.instantiateViewController(withIdentifier: "HuddlePanel") as? HuddlePanelVC
        fpController.set(contentViewController: huddlePanelVC)
        self.addChild(fpController)
        fpController.show(animated: true) {
            self.fpController.didMove(toParent: self)
        }
        
        myLocationMarker = GMSMarker()
        let icon = UIImage(named: "myLocation")
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        iconView.image = icon
        myLocationMarker.iconView = iconView
        myLocationMarker.map = mapView
    }
    
    func addHuddleToMap(_ target: Huddle) {
        
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocationLock {
            let location = locations.last!
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: 16.0)
            CATransaction.begin()
            CATransaction.setAnimationDuration(3.0)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
            self.myLocationMarker.position = location.coordinate
            mapView.animate(to: camera)
            CATransaction.commit()
        }
    }
}

extension MainViewController: GMSMapViewDelegate {
    
}

extension MainViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return CustomFPLayout()
    }
}

class CustomFPLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
        return .half
    }

    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
            case .full: return 120.0 // A top inset from safe area
            case .half: return 230.0 // A bottom inset from the safe area
            case .tip: return 80.0 // A bottom inset from the safe area
            default: return nil // Or `case .hidden: return nil`
        }
    }
}

class HuddlePanelVC: UIViewController {
    
}
