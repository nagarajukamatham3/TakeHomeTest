//
//  Constants.swift
//  TakeHomeTest
//
//  Created by Raju on 17/12/24.
//

import Foundation
import SwiftUI

struct StringConstants {
    static let apiKey = "a9a5c0abd2704ac498983335241712"
    static let locationCordinatesError = "Unable to get the coordinates for this location, Please try again later!"
    static let loadingText = "Loading..."
    static let searchPlaceholderText = " Search for a city"
    static let sunriseText = "SUNRISE"
    static let sunsetText = "SUNSET"
    static let humdityText = "HUMIDITY"
    static let visibilityText = "VISIBILITY"
    static let conditionText = "condition"
    static let enterCityAlertText = "Please enter the city name to get the weather details"
    static let cityLengthAlertText = "Please enter minimum three characters to get accurate result"
    static let apiErrorMessage = "Unable to get the response at this movement, Please try again later!"
    static let hourlyForecastText = "Hourly Forecast"
    static let NoNetworkText = "Internet connection appears to be offline"
    static let noNetworkAlertText = "Seems network to be offline, Please try again later.."
    static let celciusText = "Celcius (° C)"
    static let fahrenheitText = "Fahrenheit (° F)"
}

struct ColorConstants {
    static let white = Color.white
    static let black = Color.black
    static let gray = Color.gray
}

struct SpacingConstants {
    static let space0 = CGFloat(0.0)
    static let space4 = CGFloat(4.0)
    static let space8 = CGFloat(8.0)
    static let space10 = CGFloat(10.0)
    static let space12 = CGFloat(12.0)
    static let space16 = CGFloat(16.0)
    static let space20 = CGFloat(20.0)
    static let space25 = CGFloat(25.0)
    static let space35 = CGFloat(35.0)
    static let space50 = CGFloat(50.0)
    static let space60 = CGFloat(60.0)
}

struct ScalingFactor {
    static let scalePoint1 = CGFloat(0.1)
    static let scalePoint4 = CGFloat(0.4)
    static let scalePoint6 = CGFloat(0.6)
    static let scalePoint5 = CGFloat(0.5)
    static let scalePoint7 = CGFloat(0.7)
    static let scalePoint8 = CGFloat(0.8)
    static let scalePoint9 = CGFloat(0.9)
    static let scalePoint10 = CGFloat(1.0)
    static let scalePoint95 = CGFloat(0.95)
    static let scalePoint2 = CGFloat(0.2)
    static let scalePoint13 = CGFloat(1.3)
}
struct RadiusConstant {
    static let radius2 = CGFloat(2.0)
    static let radius4 = CGFloat(4.0)
    static let radius5 = CGFloat(5.0)
    static let radius6 = CGFloat(6.0)
    static let radius8 = CGFloat(8.0)
    static let radius10 = CGFloat(10.0)
    static let radius12 = CGFloat(12.0)
    static let radius15 = CGFloat(15.0)
    static let radius18 = CGFloat(18.0)
    static let radius20 = CGFloat(20.0)
}
