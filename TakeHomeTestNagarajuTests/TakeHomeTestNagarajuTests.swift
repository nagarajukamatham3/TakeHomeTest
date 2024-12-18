//
//  TakeHomeTestNagarajuTests.swift
//  TakeHomeTestNagarajuTests
//
//  Created by Raju on 18/12/24.
//

import XCTest
import CoreLocation
@testable import TakeHomeTestNagaraju

final class TakeHomeTestNagarajuTests: XCTestCase {

    func testWeatherReport() {
       let expection = expectation(description: "WeatherReportTesting")
       let testLocationCoOrdinates = CLLocationCoordinate2DMake(17.4062, 78.3763)
       let model = CurrentLocationModel(enteredLocationCordinates: testLocationCoOrdinates)
       let viewModel = CurrentLocationViewModel(model: model)
        
        let testLocationName = "Hyderabad"
        viewModel.fetchWeatherReport(cordinates: testLocationCoOrdinates, days: 3) { success, err in
            if success {
                print("name111 --->>", viewModel.weatherModel?.location?.name ?? "")
                XCTAssertNotNil(viewModel.weatherModel)
                XCTAssertEqual(viewModel.weatherModel?.location?.name, testLocationName)
                XCTAssertEqual(viewModel.weatherModel?.forecast?.forecastday?.count, 3)
                expection.fulfill()
            } else {
                XCTAssertNil(err)
                expection.fulfill()
            }
        }
        waitForExpectations(timeout: 5)
        
   }

}
