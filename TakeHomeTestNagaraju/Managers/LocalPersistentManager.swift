//
//  LocalPersistentManager.swift
//  TakeHomeTest
//
//  Created by Raju on 18/12/24.
//

import Foundation

class LocalPersistentManager {
    static let shared = LocalPersistentManager()
    private let userDefaults = UserDefaults.standard
    private let key = "weatherReportKey"
    
    func saveWeatherAPIResponse(_ response: WeatherModel) {
        do {
            let encodedData = try JSONEncoder().encode(response)
            userDefaults.set(encodedData, forKey: key)
        } catch {
            print("Error encoding API response: \(error)")
        }
    }

    func getWeatherAPIResponse() -> WeatherModel? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(WeatherModel.self, from: data)
        } catch {
            print("Error decoding API response: \(error)")
            return nil
        }
    }
}
