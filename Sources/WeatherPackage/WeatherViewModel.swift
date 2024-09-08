//
//  WeatherViewModel.swift
//  MiniApps
//
//  Created by Yoji on 08.09.2024.
//

import Foundation
import NetworkService
import LocationService

final class WeatherViewModel {
    private let locationService: LocationService
    private let networkService: NetworkService
    private let key: String
    private var language = {
        "&lang=\(Locale.current.language.languageCode ?? "en")"
    }()
    
    init() {
        self.networkService = NetworkService()
        self.key = self.networkService.weatherKey ?? ""
        self.locationService = LocationService()
        self.locationService.requestWhenInUseAuthorization {}
    }
    
    func updateWeather(completion: @escaping @Sendable (Int)->Void) {
        if self.locationService.isAuthorized {
            self.locationService.getLocation { [weak self] lat, lon in
                guard let self else { return }
                let coordinates = Coordinates(lat: lat, lon: lon)
                self.getNewWeatherBy(coordinates: coordinates, completion: completion)
            }
        } else {
            let coordinates = Coordinates()
            print(coordinates)
            self.getNewWeatherBy(coordinates: coordinates, completion: completion)
        }
    }
    
    private func getNewWeatherBy(coordinates: Coordinates, completion: @escaping @Sendable (Int)->Void) {
        let basicUrl = self.networkService.getUrlBy(lat: coordinates.lat, lon: coordinates.lon)
        let url = basicUrl + self.key + self.language
        
        Task {
            let response: WeatherResponse? = await url.handleAsDecodable()
            guard let response else { return }
            let temperature = response.main.temp.toRoundedInt
            completion(temperature)
        }
    }
}

private extension Float {
    var toRoundedInt: Int {
        Int(self.rounded(.toNearestOrEven))
    }
}

extension String {
    @MainActor
    public func handleAsDecodable <T: Decodable>() async -> T? {
        do {
            guard let url = URL(string: self) else {
                return nil
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            print("♦️\(error)")
            return nil
        }
    }
}
