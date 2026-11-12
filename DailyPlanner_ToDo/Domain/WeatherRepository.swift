import Foundation

struct WeatherRepository: WeatherRepositoryProtocol {
    let weatherService: WeatherServiceProtocol

    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }

    func getWeather(for city: String) async throws -> WeatherModel {
        let response = try await weatherService.getWeather(for: city)
        let isCoordinates = city.contains(",") && city.split(separator: ",").first
            .flatMap { Double($0.trimmingCharacters(in: .whitespaces)) } != nil
        return try WeatherMapper.map(from: response, locationName: isCoordinates ? "Current location" : city)
    }
}
