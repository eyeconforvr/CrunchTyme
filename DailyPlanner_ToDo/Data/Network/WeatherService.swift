import Foundation

enum WeatherServiceError: LocalizedError {
    case invalidLocation
    case locationNotFound
    case invalidURL
    case httpStatus(Int)
    case invalidResponse
    case decoding(Error)
    case unavailable

    var errorDescription: String? {
        switch self {
        case .invalidLocation: return "Enter a city or valid latitude,longitude coordinates."
        case .locationNotFound: return "No matching weather location was found."
        case .invalidURL: return "The weather request could not be created."
        case .httpStatus(let status): return "Weather request failed (HTTP \(status))."
        case .invalidResponse: return "The weather server returned an invalid response."
        case .decoding: return "The weather response could not be decoded."
        case .unavailable: return "Current weather data is unavailable."
        }
    }
}

final class WeatherService: WeatherServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getWeather(for city: String) async throws -> OpenMeteoWeatherResponse {
        let coordinates = try await coordinates(for: city)
        let variables = "temperature_2m,apparent_temperature,relative_humidity_2m,precipitation,wind_speed_10m,weather_code,is_day"
        let url = try makeURL(host: "api.open-meteo.com", path: "/v1/forecast", items: [
            URLQueryItem(name: "latitude", value: String(coordinates.latitude)),
            URLQueryItem(name: "longitude", value: String(coordinates.longitude)),
            URLQueryItem(name: "current", value: variables),
            URLQueryItem(name: "hourly", value: variables),
            URLQueryItem(name: "daily", value: "temperature_2m_max,temperature_2m_min,sunrise,sunset,weather_code"),
            URLQueryItem(name: "forecast_days", value: "7"),
            URLQueryItem(name: "timezone", value: "auto"),
            URLQueryItem(name: "timeformat", value: "unixtime"),
            URLQueryItem(name: "temperature_unit", value: "celsius"),
            URLQueryItem(name: "wind_speed_unit", value: "kmh"),
            URLQueryItem(name: "precipitation_unit", value: "mm")
        ])
        return try await request(url)
    }

    private func coordinates(for query: String) async throws -> (latitude: Double, longitude: Double) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw WeatherServiceError.invalidLocation }
        let parts = trimmed.split(separator: ",", omittingEmptySubsequences: false)
        if parts.count == 2,
           let latitude = Double(parts[0].trimmingCharacters(in: .whitespaces)),
           let longitude = Double(parts[1].trimmingCharacters(in: .whitespaces)) {
            guard latitude.isFinite, longitude.isFinite,
                  (-90...90).contains(latitude), (-180...180).contains(longitude) else {
                throw WeatherServiceError.invalidLocation
            }
            return (latitude, longitude)
        }
        // Reject malformed numeric coordinates, but allow qualified city names.
        if parts.first.flatMap({ Double($0.trimmingCharacters(in: .whitespaces)) }) != nil {
            throw WeatherServiceError.invalidLocation
        }
        let url = try makeURL(host: "geocoding-api.open-meteo.com", path: "/v1/search", items: [
            URLQueryItem(name: "name", value: trimmed),
            URLQueryItem(name: "count", value: "1"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "format", value: "json")
        ])
        let response: OpenMeteoGeocodingResponse = try await request(url)
        guard let place = response.results?.first else { throw WeatherServiceError.locationNotFound }
        guard place.latitude.isFinite, place.longitude.isFinite,
              (-90...90).contains(place.latitude), (-180...180).contains(place.longitude) else {
            throw WeatherServiceError.invalidLocation
        }
        return (place.latitude, place.longitude)
    }

    private func makeURL(host: String, path: String, items: [URLQueryItem]) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = items
        guard let url = components.url else { throw WeatherServiceError.invalidURL }
        return url
    }

    private func request<Response: Decodable>(_ url: URL) async throws -> Response {
        // Preserve URLError and CancellationError for callers; never mask cancellation.
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse else { throw WeatherServiceError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else {
            throw WeatherServiceError.httpStatus(http.statusCode)
        }
        do {
            return try JSONDecoder().decode(Response.self, from: data)
        } catch {
            throw WeatherServiceError.decoding(error)
        }
    }
}
