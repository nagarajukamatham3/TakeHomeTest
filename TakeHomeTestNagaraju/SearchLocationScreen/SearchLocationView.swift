//
//  SearchLocationView.swift
//  TakeHomeTest
//
//  Created by Raju on 18/12/24.
//

import SwiftUI
import CoreLocation

struct SearchLocationView: View {
    @StateObject var viewModel: SearchLocationViewModel

    @Environment (\.presentationMode) var presnetaionmode
    var body: some View {
        NavigationStack {
            mainView
                .navigationBarBackButtonHidden(true)
        }
        .onAppear{
            viewModel.fetchWeatherReport(cordinates: viewModel.locationCordinates, days: 3)
            
            print("latitude --->>", viewModel.weatherModel?.location?.name)
        }
    }

    var mainView: some View {
        CustomLoadingView(isShowing: $viewModel.isLoading, loadingMessage: $viewModel.loadingMessage) {
            VStack(spacing: SpacingConstants.space4) {
                
                Spacer().frame(height: SpacingConstants.space50)
                if let cityName = viewModel.weatherModel?.location?.name {
                    Text(cityName)
                        .font(.system(size: 24, weight: .medium))
                }
                if viewModel.getTempareture != 0 {
                    Text(String(viewModel.getTempareture) +  viewModel.getTempSymbol)
                        .font(.system(size: 38, weight: .medium))
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
                HStack(spacing: SpacingConstants.space4){
                    sunRiseView
                    sunSetView
                }
                
                HStack(spacing: SpacingConstants.space4){
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
    
    var sunRiseView: some View {
        let forecastday = viewModel.weatherModel?.forecast?.forecastday?.first
        return VStack(spacing: SpacingConstants.space10) {
            Text(forecastday?.astro?.sunrise ?? "")
                .font(.system(size: 20, weight: .medium))
            
            Text(StringConstants.sunriseText)
                .font(.system(size: 12, weight: .regular))
        }.frame(width: 120, height: 60)
            .background(Color.black.opacity(0.15))
            .cornerRadius(RadiusConstant.radius8)
    }
    
    var sunSetView: some View {
        let forecastday = viewModel.weatherModel?.forecast?.forecastday?.first
        return VStack(spacing: SpacingConstants.space10) {
            Text(forecastday?.astro?.sunset ?? "")
                .font(.system(size: 20, weight: .medium))
            
            Text(StringConstants.sunsetText)
                .font(.system(size: 12, weight: .regular))
        }.frame(width: 120, height: 60)
            .background(Color.black.opacity(0.15))
            .cornerRadius(RadiusConstant.radius8)
    }
    
    var humadityView: some View {
        let forecastday = viewModel.weatherModel?.forecast?.forecastday?.first
        let humidity = Int(forecastday?.day?.avgHumidity ?? 0)
        return VStack(spacing: SpacingConstants.space10) {
 
                Text(String(humidity) + " %")
                    .font(.system(size: 20, weight: .medium))
                
            Text(StringConstants.humdityText)
                .font(.system(size: 12, weight: .regular))
        }.frame(width: 120, height: 60)
            .background(Color.black.opacity(0.15))
            .cornerRadius(RadiusConstant.radius8)
    }
    
    var visibilityKmsView: some View {
        let forecastday = viewModel.weatherModel?.forecast?.forecastday?.first
        let avgVisKm = Int(forecastday?.day?.avgVisKm ?? 0)
        return VStack(spacing: SpacingConstants.space10) {
                Text(String(avgVisKm) + " km")
                    .font(.system(size: 20, weight: .medium))
                
            Text(StringConstants.visibilityText)
                .font(.system(size: 12, weight: .regular))
        }.frame(width: 120, height: 60)
            .background(Color.black.opacity(0.15))
            .cornerRadius(RadiusConstant.radius8)
    }
    
    func forecastdayRow(forecastday: Forecastday, index: Int) -> some View {
        VStack(alignment: .leading, spacing: SpacingConstants.space8) {
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
}

#Preview {
    SearchLocationView(viewModel: SearchLocationViewModel(model: SearchLocationModel(locationCordinates: CLLocationCoordinate2DMake(0, 0), temperatureType: .celsius)))
}
