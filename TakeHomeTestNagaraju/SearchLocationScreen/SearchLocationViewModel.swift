//
//  SearchLocationViewModel.swift
//  TakeHomeTest
//
//  Created by Raju on 18/12/24.
//

import Foundation
import CoreLocation

class SearchLocationViewModel: ObservableObject {
    @Published var model: SearchLocationModel
    init(model: SearchLocationModel) {
        self.model = model
    }
}

extension SearchLocationViewModel {
    var locationCordinates: CLLocationCoordinate2D {
        get { model.locationCordinates }
        set { model.locationCordinates = newValue }
    }
    var weatherModel: WeatherModel? {
        get { model.weatherModel }
        set { model.weatherModel = newValue }
    }
    var isLoading: Bool {
        get { model.isLoading }
        set { model.isLoading = newValue }
    }
    var loadingMessage: String {
        get { model.loadingMessage }
        set { model.loadingMessage = newValue }
    }
    var temperatureType: TemperatureType {
        get { model.temperatureType }
        set { model.temperatureType = newValue }
    }
}

extension SearchLocationViewModel {
    func fetchWeatherReport(cordinates: CLLocationCoordinate2D, days: Int) {
        self.isLoading = true
        NetworkManager.shared.fetchWeatherDetails(cordinates: cordinates, days: days) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let response):
                print("city name --->>", response?.location?.name ?? "")

                print("forecastdays count --->>", response?.forecast?.forecastday?.count ?? 0)
                self?.weatherModel = response
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchLocationViewModel {
    var getTempareture : Int {
        let tempC = self.weatherModel?.current?.tempC ?? 0
        let tempF = self.weatherModel?.current?.tempF ?? 0
        return temperatureType == .celsius ? Int(tempC.rounded()) : Int(tempF.rounded())
    }
    
    func getHourlyTempareture(hour: Hour) -> Int {
        let tempC = hour.tempC ?? 0
        let tempF = hour.tempF ?? 0
        return self.temperatureType == .celsius ? Int(tempC.rounded()) : Int(tempF.rounded())
    }
    
    var getTempSymbol: String {
        return temperatureType == .celsius ? "° C" : "° F"
    }
    
    func getDayMinTemp(index: Int) -> Int {
        let mintempC =  self.weatherModel?.forecast?.forecastday?[index].day?.mintempC?.rounded()
        let mintempF =  self.weatherModel?.forecast?.forecastday?[index].day?.mintempF?.rounded()
        return temperatureType == .celsius ? Int(mintempC ?? 0) : Int(mintempF ?? 0)
    }
    
    func getDayMaxTemp(index: Int) -> Int {
        let maxtempC =  self.weatherModel?.forecast?.forecastday?[index].day?.maxtempC?.rounded()
        let maxtempF =  self.weatherModel?.forecast?.forecastday?[index].day?.maxtempF?.rounded()
        return temperatureType == .celsius ? Int(maxtempC ?? 0) : Int(maxtempF ?? 0)
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
