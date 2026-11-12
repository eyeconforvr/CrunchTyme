import Foundation

struct WeatherRepository: WeatherRepositoryProtocol {
    let weatherService: WeatherServiceProtocol
    private let locationNameResolver: WeatherLocationNameResolving

    init(
        weatherService: WeatherServiceProtocol,
        locationNameResolver: WeatherLocationNameResolving = WeatherLocationNameResolver()
    ) {
        self.weatherService = weatherService
        self.locationNameResolver = locationNameResolver
    }

    func getWeather(for city: String) async throws -> WeatherModel {
        let response = try await weatherService.getWeather(for: city)
        var locationName = city.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = city.split(separator: ",")
        if parts.count == 2,
           let latitude = Double(parts[0].trimmingCharacters(in: .whitespaces)),
           let longitude = Double(parts[1].trimmingCharacters(in: .whitespaces)) {
            locationName = "Current location"
            do {
                if let name = try await locationNameResolver.locationName(latitude: latitude, longitude: longitude) {
                    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmed.isEmpty { locationName = trimmed }
                }
            } catch is CancellationError {
                throw CancellationError()
            } catch {
                // A place-name lookup failure must not discard valid local weather.
                // Keep the generic label rather than mislabeling device weather as Sandton.
            }
        }
        return try WeatherMapper.map(from: response, locationName: locationName)
    }
}
