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
import Haptica
import Firebase

class MainViewController: UIViewController {
    
    var mapView: GMSMapView!
    var fpController: FloatingPanelController!
    var huddlePanelVC: HuddlePanelVC!
    var myLocationMarker: GMSMarker!
    var currentLocationLock: Bool = true
    var huddleList: [Huddle]!               // HAS ALL HUDDLES FROM FIREBASE - NICK
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupList()
        
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
        
        Manager.shared.locationManager.delegate = self

        self.view.addSubview(mapView)
        
        fpController = FloatingPanelController()
        self.view.addSubview(fpController.view)
        fpController.view.bounds = self.view.frame
        fpController.delegate = self
        fpController.surfaceView.shadowHidden = false
        fpController.surfaceView.backgroundColor = .clear
        fpController.surfaceView.grabberHandle.isHidden = true
        fpController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fpController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
          fpController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
          fpController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0),
          fpController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
        ])
        huddlePanelVC = storyboard?.instantiateViewController(withIdentifier: "HuddlePanel") as? HuddlePanelVC
        fpController.set(contentViewController: huddlePanelVC)
        fpController.track(scrollView: huddlePanelVC.tableView)
        self.addChild(fpController)
        fpController.show(animated: true) {
            self.fpController.didMove(toParent: self)
        }
        
        mapView.padding = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: MainVCFPLayout().insetFor(position: .half)!,
            right: 0
        )
        
        myLocationMarker = GMSMarker()
        let icon = UIImage(named: "myLocation")
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        iconView.image = icon
        myLocationMarker.iconView = iconView
        myLocationMarker.map = mapView
        myLocationMarker.isFlat = true
        myLocationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
    }
    
    func setupList() {
        huddleList = []
        let ref = Database.database().reference()
        let userRef = ref.child("Huddles")
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let usersDict = snapshot.value as? [String: [String: Any]] else {
                print("Huddle Error")
                return
            }
            for (huddleHash, _) in usersDict {
                guard let userInfoDict = usersDict[huddleHash] else {
                    print("Huddle Error 2")
                    return
                }
                let name: String = userInfoDict["name"] as! String
                let desc: String = userInfoDict["description"] as! String
                let lat: Double = userInfoDict["lat"] as! Double
                let long: Double = userInfoDict["long"] as! Double
                let cur_huddle = Huddle(withLocation: CLLocation(latitude: lat, longitude: long), name: name, description: desc)
                self.huddleList.append(cur_huddle)
            }
        })
    }
    
}



// MARK: Ext: MainViewController: CLLocationManagerDelegate
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
        return MainVCFPLayout()
    }
}
