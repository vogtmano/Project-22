//
//  ViewController.swift
//  Project22.2
//
//  Created by Maks Vogtman on 23/02/2023.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var secondLabel: UILabel!
    var imageView: UIImageView!
    var detected: Bool?
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        detected = true
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        let uuidTry = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
        let beaconRegionTry = CLBeaconRegion(uuid: uuidTry, major: 124, minor: 457, identifier: "MyBeaconTry")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
        
        locationManager?.startMonitoring(for: beaconRegionTry)
        locationManager?.startRangingBeacons(in: beaconRegionTry)
    }
    
    
    func update(distance: CLProximity, beacon: CLBeaconRegion) {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let uuidTry = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
        
        imageView = UIImageView(image: UIImage(named: "circle"))
        imageView.center = CGPoint(x: 190, y: 480)
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.imageView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                
                if beacon == CLBeaconRegion(uuid: uuid, identifier: "MyBeacon") {
                    self.distanceReading.text = "FAR"
                } else if beacon == CLBeaconRegion(uuid: uuidTry, identifier: "MyBeaconTry") {
                    self.secondLabel.text = "FAR"
                }
                
            case .near:
                self.view.backgroundColor = .orange
                self.imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
                if beacon == CLBeaconRegion(uuid: uuid, identifier: "MyBeacon") {
                    self.distanceReading.text = "NEAR"
                } else if beacon == CLBeaconRegion(uuid: uuidTry, identifier: "MyBeaconTry") {
                    self.secondLabel.text = "NEAR"
                }
                
            case .immediate:
                self.view.backgroundColor = .red
                self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                if beacon == CLBeaconRegion(uuid: uuid, identifier: "MyBeacon") {
                    self.distanceReading.text = "RIGHT HERE"
                } else if beacon == CLBeaconRegion(uuid: uuidTry, identifier: "MyBeaconTry") {
                    self.secondLabel.text = "RIGHT HERE"
                }
                
            default:
                self.view.backgroundColor = .gray
                self.imageView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                
                if beacon == CLBeaconRegion(uuid: uuid, identifier: "MyBeacon") {
                    self.distanceReading.text = "UNKNOWN"
                } else if beacon == CLBeaconRegion(uuid: uuidTry, identifier: "MyBeaconTry") {
                    self.secondLabel.text = "UNKNOWN"
                }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity, beacon: region)
            
            if detected == true {
                let ac = UIAlertController(title: "Detected!", message: "We've detected a beacon", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(ac, animated: true)
            }
            
            detected = false
        } else {
            update(distance: .unknown, beacon: region)
        }
    }
}

