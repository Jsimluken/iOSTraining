//
//  ViewController.swift
//  LocationTest
//
//  Created by hiroki moriguchi on 2019/10/01.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    lazy var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse{
            print("Yatta")
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }else if status == .authorizedAlways{
            print("Hyper great")
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
    }


}

extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location size ",locations.count)
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        print("latitude: \(latitude!)\nlongitude: \(longitude!)")
        label.text = "latitude: \(latitude!)\n longitude: \(longitude!)"
    }
}

