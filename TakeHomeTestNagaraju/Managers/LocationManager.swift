//
//  LocationManager.swift
//  TakeHomeTest
//
//  Created by Raju on 17/12/24.
//

import Foundation
import CoreLocation


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    @Published var locationStatus: CLAuthorizationStatus?
    private var handler: ((CLLocation?) -> Void)?
    private var authHandler: ((CLAuthorizationStatus) -> Void)?
    var currentLocation: CLLocationCoordinate2D?

    static let shared: LocationManager = {

        let instance = LocationManager()
        return instance
      }()

   private override init() {
        super.init()
       self.locationManager = CLLocationManager()
       self.locationManager?.delegate = self
       self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }

    func getLocationPermission(handler: @escaping (CLAuthorizationStatus) -> Void) {
        self.authHandler = handler
        self.locationManager?.requestWhenInUseAuthorization()
    }

    public var statusString: String {
         guard let status = locationStatus else {
             return "unknown"
         }

         switch status {
         case .notDetermined: return "notDetermined"
         case .authorizedWhenInUse: return "authorizedWhenInUse"
         case .authorizedAlways: return "authorizedAlways"
         case .restricted: return "restricted"
         case .denied: return "denied"
         default: return "unknown"
         }
     }

    func fetchLocation(handler: @escaping (CLLocation?) -> Void) {
        self.handler = handler
        self.locationManager?.startUpdatingLocation()
    }

     func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         locationStatus = status
         if let authHandler = authHandler {
             authHandler(status)
         }
     }

     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         guard let location = locations.last else { return }
         self.currentLocation = location.coordinate
         if let locationHandler = handler {
                locationHandler(location)
         }
         locationManager?.stopUpdatingLocation()
     }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        if let locationHandler = handler {
               locationHandler(nil)
        }
        locationManager?.stopUpdatingLocation()
    }
 }
