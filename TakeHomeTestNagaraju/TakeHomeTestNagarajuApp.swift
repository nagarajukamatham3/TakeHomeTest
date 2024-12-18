//
//  TakeHomeTestNagarajuApp.swift
//  TakeHomeTestNagaraju
//
//  Created by Raju on 18/12/24.
//

import SwiftUI
import CoreLocation

@main
struct TakeHomeTestNagarajuApp: App {
    var body: some Scene {
        WindowGroup {
            CurrentLocationView(viewModel: CurrentLocationViewModel(model: CurrentLocationModel(enteredLocationCordinates: CLLocationCoordinate2D(latitude: 0, longitude: 0))))
        }
    }
}
