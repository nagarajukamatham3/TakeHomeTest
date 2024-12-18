//
//  WeatherModel.swift
//  TakeHomeTest
//
//  Created by Raju on 17/12/24.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let location: Location?
    let current: Current?
    let forecast: Forecast?
}

// MARK: - Current
struct Current: Codable {
    let lastUpdatedEpoch: Int?
    let lastUpdated: String?
    let tempC, tempF: Double?
    let condition: Condition?

    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case condition
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text, icon: String?
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]?
}

// MARK: - Forecastday
struct Forecastday: Codable, Identifiable {
    let id = UUID()
    let date: String?
    let dateEpoch: Int?
    let day: Day?
    let astro: Astro?
    let hour: [Hour]?

    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case astro, hour
        case day
    }
}

// MARK: - Astro
struct Astro: Codable {
    let sunrise, sunset: String?
}

// MARK: - Day
struct Day: Codable {
    let maxtempC, maxtempF: Double?
    let mintempC: Double?
    let mintempF: Double?
    let avgVisKm: Double?
    let avgHumidity: Double?
    let condition: Condition?

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case maxtempF = "maxtemp_f"
        case mintempC = "mintemp_c"
        case mintempF = "mintemp_f"
        case avgVisKm = "avgvis_km"
        case avgHumidity = "avghumidity"
        case condition
    }
}

// MARK: - Hour
struct Hour: Codable, Identifiable {
    let id = UUID()
    let time: String?
    let tempC, tempF: Double?

    enum CodingKeys: String, CodingKey {
        case time
        case tempC = "temp_c"
        case tempF = "temp_f"
    }
}

// MARK: - Location
struct Location: Codable {
    let name, region, country: String?
    let lat, lon: Double?
    let tzID: String?
    let localtimeEpoch: Int?
    let localtime: String?

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}
