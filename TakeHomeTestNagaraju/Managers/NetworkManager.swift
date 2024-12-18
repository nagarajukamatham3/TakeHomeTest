//
//  NetworkManager.swift
//  TakeHomeTest
//
//  Created by Raju on 17/12/24.
//

import Foundation
import Moya
import CoreLocation

public class NetworkManager {
    static let shared: NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()
    
    var provider = MoyaProvider<APIs>(plugins: [NetworkLoggerPlugin()])
    
    func fetchWeatherDetails(cordinates: CLLocationCoordinate2D, days: Int,completion: @escaping (Result<WeatherModel?, Error>) -> ()) {
        request(target: .getWeatherDetails(cordinates: cordinates, days: days), completion: completion)
    }
}

private extension NetworkManager {
    private func request<T: Decodable>(target: APIs, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
