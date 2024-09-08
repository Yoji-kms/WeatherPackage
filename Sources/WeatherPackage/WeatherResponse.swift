//
//  WeatherResponse.swift
//  Weather App
//
//  Created by Yoji on 25.10.2023.
//

import Foundation

struct WeatherResponse: Decodable {
    let main: MainDataResponse
    let name: String?
}
