//
//  WeatherService.swift
//  Weather App
//
//  Created by Irfan T on 03/12/24.
//

import Combine
import Foundation


struct WeatherResponse: Codable {
    let current: CurrentWeather
    let daily: [DailyWeather]
}

struct CurrentWeather: Codable {
    let temp: Double
    let weather: [WeatherCondition]
}

struct DailyWeather: Codable {
    let temp: Temperature
    let weather: [WeatherCondition]
}

struct WeatherCondition: Codable {
    let description: String
    let icon: String
}

struct Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
}



struct GeocodingResponse: Codable {
    let name: String
    let lat: Double
    let lon: Double
}



class WeatherService {
    
    private var api_key = "ba380997dac35333209da7dd828d8d1b"
    private var baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, Error> {
        guard let url = URL(string: "\(baseUrl)?q=\(city)&appid=\(api_key)&units=metric") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
