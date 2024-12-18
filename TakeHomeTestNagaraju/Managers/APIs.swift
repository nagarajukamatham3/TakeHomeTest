//
//  APIs.swift
//  TakeHomeTest
//
//  Created by Raju on 17/12/24.
//

import Foundation
import Moya
import CoreLocation

enum APIs {
    case getWeatherDetails(cordinates: CLLocationCoordinate2D, days: Int)
}

extension APIs: TargetType {
   
    public var baseURL: URL {
        let baseURL = "https://api.weatherapi.com/v1"
        return URL(string: baseURL)  ?? URL(string: "https://api.weatherapi.com/v1")!
    }
    
    public var path: String {
        switch self {
        case .getWeatherDetails: return "/forecast.json"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getWeatherDetails: return .get
        }
    }
}

extension APIs {
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    public var task: Task {
        switch self {
        case .getWeatherDetails(let cordinates, let days):
            var params: [String: Any] = [:]
            params["key"] = StringConstants.apiKey
            params["days"] = "\(days)"
            params["q"] = String("\(cordinates.latitude),\(cordinates.longitude)")
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
