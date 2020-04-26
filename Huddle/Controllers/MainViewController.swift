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

class MainViewController: UIViewController {
    
    var mapView: GMSMapView!
    var fpController: FloatingPanelController!
    var huddlePanelVC: HuddlePanelVC!
    var myLocationMarker: GMSMarker!
    var currentLocationLock: Bool = true
    var huddleList: [Huddle] = []
    var selectedMarker: GMSMarker?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Manager.shared.locationManager.delegate = self
        
        let color = UIColor(hex: "#242f3e")
        self.view.backgroundColor = color
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), camera: camera)
        mapView.delegate = self
        do {
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
              mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
              NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        mapView.padding = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: MainVCFPLayout().insetFor(position: .half)!,
            right: 0
        )
        mapView.settings.myLocationButton = true
        
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
        
        myLocationMarker = GMSMarker()
        let icon = UIImage(named: "myLocation")
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        iconView.image = icon
        myLocationMarker.iconView = iconView
        myLocationMarker.map = mapView
        myLocationMarker.isFlat = true
        myLocationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        
        setupHuddleListUpdate()
        
        // placeMarker(at: CLLocationCoordinate2D(latitude: 37.872541, longitude: -122.260456))
    }
    
    func setupHuddleListUpdate() {
        let callback = { (huddleList: [Huddle]) in
            self.huddleList = huddleList
            for huddle in huddleList {
                self.placeMarker(at: huddle.location.coordinate)
            }
        }
        Manager.shared.setupHuddleUpdate(completionHandler: callback)
    }
    
    func placeMarker(at location: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        let icon = UIImage(named: "huddleMarker_empty")
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        iconView.contentMode = .scaleAspectFit
        iconView.image = icon
        iconView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        marker.iconView = iconView
        marker.map = self.mapView
        marker.position = location
        marker.appearAnimation = .pop
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog(error.localizedDescription)
    }
}

// MARK: Ext: MainViewController: GMSMapViewDelegate
extension MainViewController: GMSMapViewDelegate {
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        if !self.view.subviews.contains(mapView) {
            mapView.alpha = 0
            self.view.insertSubview(mapView, belowSubview: fpController.view)
            UIView.animate(withDuration: 0.4, animations: {
                mapView.alpha = 1
            })
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if marker == selectedMarker{
            smoothMoveCamera(to: marker, withDuration: 0.8)
        } else if marker == myLocationMarker {
            smoothMoveCamera(to: marker, withDuration: 0.8)
            cancelMarkerSelection()
        } else {
            cancelMarkerSelection()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                marker.iconView?.transform = CGAffineTransform(scaleX: 1.45, y: 1.45)
                self.selectedMarker = marker
            })
            smoothMoveCamera(to: marker, withDuration: 0.8)
        }

        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 0.3, animations: {
            self.selectedMarker?.iconView?.transform = CGAffineTransform.identity
            self.selectedMarker = nil
        })
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        currentLocationLock = false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        currentLocationLock = true
        smoothMoveCamera(to: myLocationMarker, withDuration: 0.8)
        cancelMarkerSelection()
        return true
    }
    
    private func smoothMoveCamera(to marker: GMSMarker, withDuration: TimeInterval) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(withDuration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        mapView.animate(toLocation: marker.position)
        CATransaction.commit()
    }
    
    private func cancelMarkerSelection() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
             self.selectedMarker?.iconView?.transform = CGAffineTransform.identity
             self.selectedMarker = nil
         })
    }
}

extension MainViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return MainVCFPLayout()
    }
}
