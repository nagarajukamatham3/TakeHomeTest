//
//  CurrentLocationViewModel.swift
//  TakeHomeTest
//
//  Created by Raju on 17/12/24.
//

import Foundation
import CoreLocation

class CurrentLocationViewModel: ObservableObject {
    @Published var model : CurrentLocationModel
    
    init(model: CurrentLocationModel) {
        self.model = model
    }
    
    func fetchWeatherReport(cordinates: CLLocationCoordinate2D, days: Int,
                            completion:@escaping (Bool, Error?)-> Void) {
        self.isLoading = true
        NetworkManager.shared.fetchWeatherDetails(cordinates: cordinates, days: days) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let response):
                if let weatherResponse = response {
                    LocalPersistentManager.shared.saveWeatherAPIResponse(weatherResponse)
                }
                self?.weatherModel = response
                completion(true, nil)
            case .failure(let error):
                print(error)
                if error.localizedDescription.contains(StringConstants.NoNetworkText) {
                    let splitString = error.localizedDescription.components(separatedBy: ":")
                    let firstString = splitString.last ?? ""
                    self?.alertMessage =  firstString + " Load offline data.."
                    self?.noNetworkAlert = true
                    self?.canShowAlert = true
                } else {
                    self?.alertMessage = StringConstants.apiErrorMessage
                    self?.canShowAlert = true
                }
                completion(false, error)
                
            }
        }
    }
    
    func getHourlyTempareture(hour: Hour) -> Int {
        let tempC = hour.tempC ?? 0
        let tempF = hour.tempF ?? 0
        return self.temperatureType == .celsius ? Int(tempC.rounded()) : Int(tempF.rounded())
    }
    
    var getTempareture : Int {
        let tempC = self.weatherModel?.current?.tempC ?? 0
        let tempF = self.weatherModel?.current?.tempF ?? 0
        return self.temperatureType == .celsius ? Int(tempC.rounded()) : Int(tempF.rounded())
    }
    
    var getTempSymbol: String {
        return self.temperatureType == .celsius ? "° C" : "° F"
    }
    
    func getDayMinTemp(index: Int) -> Int {
        let mintempC =  self.weatherModel?.forecast?.forecastday?[index].day?.mintempC?.rounded()
        let mintempF =  self.weatherModel?.forecast?.forecastday?[index].day?.mintempF?.rounded()
        return self.temperatureType == .celsius ? Int(mintempC ?? 0) : Int(mintempF ?? 0)
    }
    
    func getDayMaxTemp(index: Int) -> Int {
        let maxtempC =  self.weatherModel?.forecast?.forecastday?[index].day?.maxtempC?.rounded()
        let maxtempF =  self.weatherModel?.forecast?.forecastday?[index].day?.maxtempF?.rounded()
        return self.temperatureType == .celsius ? Int(maxtempC ?? 0) : Int(maxtempF ?? 0)
    }
    
    var getMaxTempString: String {
        return "H : \(getDayMaxTemp(index: 0))°"
    }
    
    var getMinTempString: String {
        return "L : \(getDayMinTemp(index: 0))°"
    }
    
    func getDayName(date: String) -> String? {
        guard let dayName = DateUtils.dayName(from: date) else { return nil }
        return dayName ==  DateUtils.getCurrentDayName() ? "Today" : dayName
    }

}

extension CurrentLocationViewModel {
    var weatherModel: WeatherModel? {
        get { model.weatherModel }
        set { model.weatherModel = newValue }
    }
    
    var enteredText: String {
        get { model.enteredText ?? "" }
        set { model.enteredText = newValue }
    }
    
    var enteredLocationCordinates: CLLocationCoordinate2D {
        get { model.enteredLocationCordinates }
        set { model.enteredLocationCordinates = newValue }
    }
    
    var navigateToSearchLocation: Bool {
        get { model.navigateToSearchLocation }
        set { model.navigateToSearchLocation = newValue }
    }
    var canShowAlert: Bool {
        get { model.isLocationCordinatesError }
        set { model.isLocationCordinatesError = newValue }
    }
    var isLoading: Bool {
        get { model.isLoading }
        set { model.isLoading = newValue }
    }
    var loadingMessage: String {
        get { model.loadingMessage }
        set { model.loadingMessage = newValue }
    }
    var inputTextAlert: Bool {
        get { model.inputTextAlert }
        set { model.inputTextAlert = newValue }
    }
    var alertMessage: String {
        get { model.alertMessage }
        set { model.alertMessage = newValue }
    }
    var temperatureType: TemperatureType {
        get { model.temperatureType }
        set { model.temperatureType = newValue }
    }
    var noNetworkAlert: Bool {
        get { model.noNetworkAlert }
        set { model.noNetworkAlert = newValue }
    }
}


extension CurrentLocationViewModel {
    func getLocationCoordinate(completion: @escaping(CLLocationCoordinate2D?) -> Void) {
        if  LocationManager.shared.locationStatus == .notDetermined ||
                LocationManager.shared.locationStatus == nil {
            LocationManager.shared.getLocationPermission { status in
                if status != .denied {
                    LocationManager.shared.fetchLocation(handler: { location in
                        if let coordinates = location?.coordinate {
                            print("latitude1: \(coordinates.latitude) longitude1: \(coordinates.longitude)")
                            completion(coordinates)
                        }
                    })
                } else {
                    completion(nil)
                }
            }
        } else {
            LocationManager.shared.fetchLocation(handler: { location in
                if let coordinates = location?.coordinate {
                    print("latitude2: \(coordinates.latitude) longitude2: \(coordinates.longitude)")
                    completion(coordinates)
                } else {
                    completion(nil)
                }
            })
        }
    }
}

extension CurrentLocationViewModel {
    func getLatitudeLongitude(address: String, completion: @escaping(CLLocationCoordinate2D?) -> Void) {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if error != nil {
                    print("Failed to retrieve location")
                    completion(nil)
                    return
                }
                
                var location: CLLocation?
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    let coordinate = location.coordinate
                    self.enteredLocationCordinates = coordinate
                    completion(coordinate)
                    print("\nlat: \(coordinate.latitude), long: \(coordinate.longitude)")
                }
                else
                {
                    print("No Matching Location Found")
                    completion(nil)
                }
            })
        }
}
