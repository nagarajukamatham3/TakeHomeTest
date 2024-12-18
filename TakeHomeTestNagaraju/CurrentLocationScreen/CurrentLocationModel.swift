//
//  CurrentLocationModel.swift
//  TakeHomeTest
//
//  Created by Raju on 17/12/24.
//

import Foundation
import CoreLocation

struct CurrentLocationModel {
    
    var weatherModel : WeatherModel?
    var enteredText: String?
    var enteredLocationCordinates: CLLocationCoordinate2D
    var navigateToSearchLocation = false
    var isLocationCordinatesError = false
    var isLoading = false
    var loadingMessage = ""
    var inputTextAlert = false
    var alertMessage = ""
    var temperatureType : TemperatureType = .celsius
    var noNetworkAlert = false
    
}
