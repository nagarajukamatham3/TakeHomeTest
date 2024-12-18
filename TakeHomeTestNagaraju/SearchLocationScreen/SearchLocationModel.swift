//
//  SearchLocationModel.swift
//  TakeHomeTest
//
//  Created by Raju on 18/12/24.
//

import Foundation
import CoreLocation

struct SearchLocationModel {
    var locationCordinates: CLLocationCoordinate2D
    var weatherModel: WeatherModel?
    var isLoading = false
    var loadingMessage = ""
    var temperatureType : TemperatureType
}
