//
//  CurrentLocationView.swift
//  TakeHomeTest
//
//  Created by Raju on 17/12/24.
//

import SwiftUI
import CoreLocation

enum TemperatureType {
    case celsius
    case fahrenheit
}

struct CurrentLocationView: View {
    @StateObject var viewModel: CurrentLocationViewModel

    var body: some View {
        NavigationView {
            mainView
               .alert(isPresented: $viewModel.canShowAlert, content: {
                    if viewModel.noNetworkAlert  {
                        Alert(title: Text(""), message: Text(viewModel.alertMessage), dismissButton: .default(Text("Ok"), action: {
                            if let weatherResponse = LocalPersistentManager.shared.getWeatherAPIResponse() {
                                viewModel.weatherModel = weatherResponse
                            } else {
                                print("offline data not found")
                            }
                        }))
                    } else {
                        Alert(title: Text(""), message: Text(viewModel.alertMessage), dismissButton: .default(Text("Ok")))
                    }

                })
        }
        .onAppear{
                let isNetworkConnected = NetworkMonitor.shared.isNetworkConnected
                viewModel.getLocationCoordinate { cordinates in
                    if let cordinates = cordinates {
                        if NetworkMonitor.shared.isNetworkConnected {
                            viewModel.fetchWeatherReport(cordinates: cordinates, days: 3) { _,_ in }
                        } else {
                            viewModel.weatherModel = LocalPersistentManager.shared.getWeatherAPIResponse()
                        }

                    } else {
                        viewModel.alertMessage = StringConstants.locationCordinatesError
                        viewModel.canShowAlert = true
                        print("unable to get cordinates")
                    }
                }
        }
    }
        
    var mainView: some View {
        CustomLoadingView(isShowing: $viewModel.isLoading, loadingMessage: $viewModel.loadingMessage) {
            VStack(spacing: SpacingConstants.space4) {
                Spacer().frame(height: SpacingConstants.space50)
                searchCityView()
                Spacer().frame(height: SpacingConstants.space4)
                if let cityName = viewModel.weatherModel?.location?.name {
                    Text(cityName)
                        .font(.system(size: 20, weight: .medium))
                }
                if viewModel.getTempareture != 0 {
                    Text(String(viewModel.getTempareture) +  viewModel.getTempSymbol)
                        .font(.system(size: 30, weight: .medium))
                }
                if let weatherCondition = viewModel.weatherModel?.current?.condition?.text {
                    Text(weatherCondition)
                        .font(.system(size: 20, weight: .regular))
                }
                
                HStack(spacing: SpacingConstants.space12){
                    Text(viewModel.getMaxTempString)
                        .font(.system(size: 20, weight: .medium))
                    
                    Text(viewModel.getMinTempString)
                        .font(.system(size: 20, weight: .medium))
                }
                Spacer().frame(height: SpacingConstants.space8)
                HStack(spacing:  SpacingConstants.space4){
                    sunRiseView
                    sunSetView
                }
                
                HStack(spacing:  SpacingConstants.space4){
                    humadityView
                    visibilityKmsView
                }
                
                Spacer().frame(height: SpacingConstants.space8)
                HStack(alignment: .top) {
                    Spacer().frame(width: SpacingConstants.space16)
                    Text(StringConstants.hourlyForecastText)
                    Spacer()
                }
                horizontalListView
                
                if let forecastdays = viewModel.weatherModel?.forecast?.forecastday {
                    List {
                        ForEach(forecastdays.indices) { index in
                            let forecastday = forecastdays[index]
                            forecastdayRow(forecastday: forecastday, index: index)
                        }
                    }.background(Color.green.opacity(0.5))
                    
                }
                navigationToSearchLocationView()
                Spacer()
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.green.opacity(0.5))
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    var horizontalListView: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: SpacingConstants.space20) {
                    ForEach(viewModel.weatherModel?.forecast?.forecastday?.first?.hour ?? [], id: \.id) { hour in
                        hourRowView(hour: hour)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    func hourRowView(hour: Hour) -> some View {
        VStack(spacing: SpacingConstants.space10) {
            Text(DateUtils.getHours(dateString: hour.time ?? "") ?? "")
                .font(.system(size: 12, weight: .regular))
            
            let hourlyTemp = viewModel.getHourlyTempareture(hour: hour)
            Text("\(hourlyTemp)\(viewModel.getTempSymbol)")
                .font(.system(size: 20, weight: .regular))
        }   .padding()
            .background(Color.white.opacity(0.15))
            .foregroundColor(.black)
            .cornerRadius(RadiusConstant.radius8)
    }
    
    func searchCityView() -> some View {
         HStack {
             HStack {
                 Spacer().frame(width: SpacingConstants.space8)
                 Image(systemName: "magnifyingglass")
                 TextField(StringConstants.searchPlaceholderText, text: $viewModel.enteredText)
                     .keyboardType(.webSearch)
                     .frame(height: SpacingConstants.space35)
                     .onSubmit {
                         if NetworkMonitor.shared.isNetworkConnected == false {
                             viewModel.alertMessage = StringConstants.noNetworkAlertText
                             viewModel.canShowAlert = true
                         } else if viewModel.enteredText.isEmpty {
                             viewModel.alertMessage = StringConstants.enterCityAlertText
                             viewModel.inputTextAlert = true
                             viewModel.canShowAlert = true
                         } else if viewModel.enteredText.count < 3 {
                             viewModel.alertMessage = StringConstants.cityLengthAlertText
                             viewModel.inputTextAlert = true
                             viewModel.canShowAlert = true
                         }
                         else {
                             viewModel.getLatitudeLongitude(address: viewModel.enteredText) { coordinates in
                                 if let coordinates = coordinates {
                                     viewModel.enteredText = ""
                                     viewModel.navigateToSearchLocation.toggle()
                                 } else {
                                     viewModel.alertMessage = StringConstants.locationCordinatesError
                                     viewModel.canShowAlert.toggle()
                                 }
                                 
                             }
                         }
                     }
             }.overlay(
                RoundedRectangle(cornerRadius: RadiusConstant.radius8)
                    .stroke(.gray, lineWidth: 1)
             )
        
             tempuretureMenuView()

         }.padding(.horizontal, SpacingConstants.space16)
    }
    
    func tempuretureMenuView() -> some View {
        Menu {
           Button(action: {
               viewModel.temperatureType = .celsius
           }) {
               Label {
                   Text(StringConstants.celciusText)
               } icon: {
                   if viewModel.temperatureType == .celsius {
                       Image(systemName: "checkmark")
                   }
               }
           }
           
           Button(action: {
               viewModel.temperatureType = .fahrenheit
           }) {
               Label {
                   Text(StringConstants.fahrenheitText)
               } icon: {
                   if viewModel.temperatureType == .fahrenheit {
                       Image(systemName: "checkmark")
                   }
               }
           }
       } label: {
           Image(systemName: "ellipsis.circle")
               .rotationEffect(.degrees(90))
               .foregroundColor(ColorConstants.black)
       }
   }
    
    
    var sunRiseView: some View {
        let forecastday = viewModel.weatherModel?.forecast?.forecastday?.first
        return VStack(spacing:  SpacingConstants.space10) {
            Text(forecastday?.astro?.sunrise ?? "")
                .font(.system(size: 20, weight: .medium))
            
            Text(StringConstants.sunriseText)
                .font(.system(size: 12, weight: .regular))
        }.frame(width: 120, height: 60)
            .background(Color.black.opacity(0.15))
            .cornerRadius(8.0)
    }
    
    var sunSetView: some View {
        let forecastday = viewModel.weatherModel?.forecast?.forecastday?.first
        return VStack(spacing:  SpacingConstants.space10) {
            Text(forecastday?.astro?.sunset ?? "")
                .font(.system(size: 20, weight: .medium))
            
            Text(StringConstants.sunsetText)
                .font(.system(size: 12, weight: .regular))
        }.frame(width: 120, height: 60)
            .background(Color.black.opacity(0.15))
            .cornerRadius(8.0)
    }
    
    var humadityView: some View {
        let forecastday = viewModel.weatherModel?.forecast?.forecastday?.first
        let humidity = Int(forecastday?.day?.avgHumidity ?? 0)
        return VStack(spacing:  SpacingConstants.space10) {
 
                Text(String(humidity) + " %")
                    .font(.system(size: 20, weight: .medium))
                
            Text(StringConstants.humdityText)
                .font(.system(size: 12, weight: .regular))
        }.frame(width: 120, height: 60)
            .background(Color.black.opacity(0.15))
            .cornerRadius(8.0)
    }
    
    var visibilityKmsView: some View {
        let forecastday = viewModel.weatherModel?.forecast?.forecastday?.first
        let avgVisKm = Int(forecastday?.day?.avgVisKm ?? 0)
        return VStack(spacing:  SpacingConstants.space10) {
                Text(String(avgVisKm) + " km")
                    .font(.system(size: 20, weight: .medium))
                
            Text(StringConstants.visibilityText)
                .font(.system(size: 12, weight: .regular))
        }.frame(width: 120, height: 60)
            .background(Color.black.opacity(0.15))
            .cornerRadius(8.0)
    }
    
    func forecastdayRow(forecastday: Forecastday, index: Int) -> some View {
        VStack(alignment: .leading, spacing:  SpacingConstants.space8) {
            HStack {
                if let dayName = viewModel.getDayName(date: forecastday.date ?? "") {
                    Text(dayName)
                        .font(.system(size: 20, weight: .medium))
                }
                Text("(H : \(viewModel.getDayMaxTemp(index: index))" + "\(viewModel.getTempSymbol)")
                Text(" L : \(viewModel.getDayMinTemp(index: index))" + "\(viewModel.getTempSymbol))")
            }
            Text("\(StringConstants.conditionText) : \(forecastday.day?.condition?.text ?? "")")
            Text("\(StringConstants.sunriseText) : \(forecastday.astro?.sunrise ?? "")")
            Text("\(StringConstants.sunsetText) : \(forecastday.astro?.sunset ?? "")")
        }
    }
    
    func navigationToSearchLocationView() -> some View {
        let searchModel = SearchLocationModel(locationCordinates: viewModel.enteredLocationCordinates, temperatureType: viewModel.temperatureType)
        let searchLocationViewModel = SearchLocationViewModel(model: searchModel)
        let searchLocationView = SearchLocationView(viewModel: searchLocationViewModel)
        return NavigationLink(destination: searchLocationView,
                              isActive: $viewModel.navigateToSearchLocation) {
            EmptyView()
        }
    }
    
}

#Preview {
    CurrentLocationView(viewModel: CurrentLocationViewModel(model: CurrentLocationModel( enteredLocationCordinates: CLLocationCoordinate2DMake(0, 0))))
}
