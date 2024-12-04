import Foundation
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var weatherDescription: String = ""
    @Published var temperature: String = ""
    @Published var backgroundImage: String = "default" // Default background
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchWeather(for cityName: String) {
        fetchCoordinates(for: cityName)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = "Failed to fetch location: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] location in
                self?.fetchWeather(lat: location.latitude, lon: location.longitude)
            })
            .store(in: &cancellables)
    }
    
    private func fetchCoordinates(for cityName: String) -> AnyPublisher<CLLocationCoordinate2D, Error> {
        guard let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=1&appid=YOUR_API_KEY") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [GeocodingResponse].self, decoder: JSONDecoder())
            .tryMap { locations in
                guard let location = locations.first else {
                    throw URLError(.badServerResponse)
                }
                return CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func fetchWeather(lat: Double, lon: Double) {
        guard let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=hourly,minutely&appid=YOUR_API_KEY&units=metric") else {
            error = "Invalid URL"
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(err) = completion {
                    self?.error = "Failed to fetch weather: \(err.localizedDescription)"
                }
            }, receiveValue: { [weak self] weatherResponse in
                self?.updateWeatherData(from: weatherResponse)
            })
            .store(in: &cancellables)
    }
    
    private func updateWeatherData(from response: WeatherResponse) {
        guard let currentWeather = response.current.weather.first else { return }
        weatherDescription = currentWeather.description
        temperature = "\(Int(response.current.temp))°C"
        
        switch currentWeather.icon {
        case "01d", "01n":
            backgroundImage = "sunny"
        case "02d", "02n":
            backgroundImage = "cloudy"
        case "09d", "09n", "10d", "10n":
            backgroundImage = "rain"
        case "13d", "13n":
            backgroundImage = "snow"
        default:
            backgroundImage = "default"
        }
        
        
    }
}
