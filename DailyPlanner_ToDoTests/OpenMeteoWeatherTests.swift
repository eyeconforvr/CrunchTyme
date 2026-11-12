import XCTest
@testable import DailyPlanner_ToDo

@MainActor
final class OpenMeteoWeatherTests: XCTestCase {
    private let now = Date(timeIntervalSince1970: 1_789_214_400) // 2026-09-12 12:00 UTC

    private func fixture() -> [String: Any] {
        let hour = now.timeIntervalSince1970
        let day = hour - 14 * 3600 // midnight in Johannesburg
        return [
            "timezone": "Africa/Johannesburg", "utc_offset_seconds": 7200,
            "current": ["time": hour, "temperature_2m": 22.5, "apparent_temperature": 21.0,
                        "relative_humidity_2m": 62, "precipitation": 0.4, "wind_speed_10m": 12.3,
                        "weather_code": 2, "is_day": 1],
            "hourly": ["time": [hour - 3600, hour, hour + 3600, hour + 24 * 3600],
                       "temperature_2m": [20, 22.5, 21, 18], "weather_code": [0, 2, 0, 3],
                       "is_day": [1, 1, 0, 1], "apparent_temperature": [19, 21, 20, 17],
                       "relative_humidity_2m": [60, 62, 65, 70],
                       "precipitation": [0, 0.4, 0, 0], "wind_speed_10m": [10, 12.3, 11, 9]],
            "daily": ["time": [day, day + 86400], "temperature_2m_max": [26, 27],
                      "temperature_2m_min": [14, 15], "weather_code": [2, 95],
                      "sunrise": [day + 6 * 3600, day + 30 * 3600],
                      "sunset": [day + 18 * 3600, day + 42 * 3600]]
        ]
    }

    private func decode(_ object: [String: Any]) throws -> OpenMeteoWeatherResponse {
        try JSONDecoder().decode(OpenMeteoWeatherResponse.self, from: JSONSerialization.data(withJSONObject: object))
    }

    func testDTOMapsCurrentHourlyDailyAndMetrics() throws {
        let response = try decode(fixture())
        let model = try WeatherMapper.map(from: response, locationName: "Sandton", now: now)
        XCTAssertEqual(model.currentTemp, "22.5°C")
        XCTAssertEqual(model.highTemp, "26.0°C")
        XCTAssertEqual(model.lowTemp, "14.0°C")
        XCTAssertEqual(model.condition, "Partly cloudy")
        XCTAssertEqual(model.icon, "cloud.sun.fill")
        XCTAssertEqual(model.sunrise, "06:00 AM")
        XCTAssertEqual(model.sunset, "06:00 PM")
        XCTAssertEqual(model.sunriseDate?.timeIntervalSince1970, now.timeIntervalSince1970 - 8 * 3600)
        XCTAssertEqual(model.metrics.feelsLikeTemperature, 21)
        XCTAssertEqual(model.metrics.humidity, 62)
        XCTAssertEqual(model.metrics.precipitation, 0.4)
        XCTAssertEqual(model.metrics.windSpeed, 12.3)
        XCTAssertEqual(model.dailyForecast.count, 2)
        XCTAssertEqual(model.dailyForecast.last?.condition, "Thunderstorm")
        XCTAssertEqual(model.dailyForecast.first?.highTemp, "26.0°C")
        XCTAssertEqual(model.hourlyForecast.map(\.time), ["Now", "3 PM"])
        XCTAssertEqual(model.hourlyForecast.last?.icon, "moon.stars.fill")
        XCTAssertEqual(model.hourlyForecast.first?.metrics.humidity, 62)
    }

    func testAllSupportedWMOCodesAndUnknownFallback() {
        let groups: [(codes: [Int], description: String)] = [
            ([0, 1], "Sunny"), ([2], "Partly cloudy"), ([3], "Overcast"),
            ([45], "Fog"), ([48], "Freezing fog"), ([51, 53, 55, 56, 57], "Light drizzle"),
            ([61, 66, 80], "Light rain"), ([63, 81], "Moderate rain"), ([65, 67, 82], "Heavy rain"),
            ([71, 77, 85], "Light snow"), ([73], "Moderate snow"), ([75, 86], "Heavy snow"),
            ([95, 96, 97, 99], "Thunderstorm")
        ]
        for group in groups {
            for code in group.codes {
                XCTAssertEqual(WeatherConditionMapper.map(code: code, isDay: true).description, group.description)
                XCTAssertFalse(WeatherConditionMapper.map(code: code, isDay: false).icon.isEmpty)
            }
        }
        XCTAssertEqual(WeatherConditionMapper.map(code: 0, isDay: false).description, "Clear")
        XCTAssertEqual(WeatherConditionMapper.map(code: 2, isDay: false).icon, "cloud.moon.fill")
        for code in [nil, -1, 999] as [Int?] {
            XCTAssertEqual(WeatherConditionMapper.map(code: code, isDay: true).description, "Unknown")
        }
    }

    func testNullAndShortForecastArraysDoNotInventZeroValuesOrCrash() throws {
        var object = fixture()
        object["hourly"] = ["time": [now.timeIntervalSince1970, now.timeIntervalSince1970 + 3600],
                            "temperature_2m": [NSNull()], "weather_code": [999]] as [String: Any]
        object["daily"] = ["time": [now.timeIntervalSince1970 - 14 * 3600],
                           "sunrise": [NSNull()]] as [String: Any]
        let model = try WeatherMapper.map(from: decode(object), now: now)
        XCTAssertEqual(model.highTemp, "--°C")
        XCTAssertEqual(model.hourlyForecast.count, 2)
        XCTAssertEqual(model.hourlyForecast.last?.highTemp, "--°C")
        XCTAssertEqual(model.hourlyForecast.first?.condition, "Unknown")
        XCTAssertNil(model.hourlyForecast.last?.metrics.humidity)
        XCTAssertNil(model.sunriseDate)
        XCTAssertEqual(model.sunrise, "--")
    }

    func testMissingForecastSectionsAreAllowedButCurrentTemperatureIsRequired() throws {
        var object = fixture()
        object.removeValue(forKey: "daily")
        object.removeValue(forKey: "hourly")
        let model = try WeatherMapper.map(from: decode(object), now: now)
        XCTAssertTrue(model.dailyForecast.isEmpty)
        XCTAssertTrue(model.hourlyForecast.isEmpty)
        object["current"] = ["time": now.timeIntervalSince1970, "temperature_2m": NSNull()]
        XCTAssertThrowsError(try WeatherMapper.map(from: decode(object), now: now)) {
            guard case WeatherServiceError.unavailable = $0 else { return XCTFail("Unexpected error: \($0)") }
        }
    }

    func testForecastLabelsUseLocationTimezoneAcrossMidnight() throws {
        var object = fixture()
        object["timezone"] = "Pacific/Auckland"
        object["utc_offset_seconds"] = 43200
        object["hourly"] = ["time": [now.timeIntervalSince1970, now.timeIntervalSince1970 + 3600],
                            "temperature_2m": [10, 11], "weather_code": [0, 2], "is_day": [0, 0]]
        let model = try WeatherMapper.map(from: decode(object), now: now)
        XCTAssertEqual(model.hourlyForecast.map(\.time), ["Now", "1 AM"])
        XCTAssertEqual(model.timeZoneIdentifier, "Pacific/Auckland")
    }

    private func session(handler: @escaping (URLRequest) throws -> (Int, Data)) -> URLSession {
        WeatherStubURLProtocol.handler = handler
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [WeatherStubURLProtocol.self]
        return URLSession(configuration: configuration)
    }

    func testCoordinatesSkipGeocodingAndRequestRequiredVariablesWithoutKey() async throws {
        let data = try JSONSerialization.data(withJSONObject: fixture())
        let session = session { request in
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(url.host, "api.open-meteo.com")
            XCTAssertEqual(url.scheme, "https")
            let items = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems)
            let query = Dictionary(uniqueKeysWithValues: items.map { ($0.name, $0.value ?? "") })
            XCTAssertEqual(query["latitude"], "-33.9249")
            XCTAssertEqual(query["longitude"], "18.4241")
            XCTAssertEqual(query["timezone"], "auto")
            XCTAssertEqual(query["timeformat"], "unixtime")
            XCTAssertEqual(query["forecast_days"], "7")
            XCTAssertNil(query["apikey"])
            for field in ["temperature_2m", "apparent_temperature", "relative_humidity_2m", "precipitation", "wind_speed_10m", "weather_code", "is_day"] {
                XCTAssertTrue(query["current"]?.contains(field) == true)
                XCTAssertTrue(query["hourly"]?.contains(field) == true)
            }
            return (200, data)
        }
        defer { session.invalidateAndCancel() }
        let response = try await WeatherService(session: session).getWeather(for: "-33.9249,18.4241")
        XCTAssertEqual(response.current?.temperature, 22.5)
    }

    func testCityIsGeocodedBeforeForecastRequest() async throws {
        let data = try JSONSerialization.data(withJSONObject: fixture())
        let session = session { request in
            let url = try XCTUnwrap(request.url)
            if url.host == "geocoding-api.open-meteo.com" {
                let query = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
                XCTAssertEqual(query?.first { $0.name == "name" }?.value, "Cape Town")
                return (200, Data(#"{"results":[{"name":"Cape Town","latitude":-33.9,"longitude":18.4}]}"#.utf8))
            }
            XCTAssertTrue(url.absoluteString.contains("latitude=-33.9"))
            XCTAssertTrue(url.absoluteString.contains("longitude=18.4"))
            return (200, data)
        }
        defer { session.invalidateAndCancel() }
        _ = try await WeatherService(session: session).getWeather(for: "Cape Town")
    }

    func testHTTPAndDecodingAndNetworkErrorsPropagate() async throws {
        for status in [400, 429, 503] {
            let session = session { _ in (status, Data()) }
            defer { session.invalidateAndCancel() }
            do {
                _ = try await WeatherService(session: session).getWeather(for: "0,0")
                XCTFail("Expected HTTP error")
            } catch WeatherServiceError.httpStatus(let code) { XCTAssertEqual(code, status) }
        }
        let malformed = session { _ in (200, Data("not JSON".utf8)) }
        defer { malformed.invalidateAndCancel() }
        do {
            _ = try await WeatherService(session: malformed).getWeather(for: "0,0")
            XCTFail("Expected decoding error")
        } catch WeatherServiceError.decoding { }
        let offline = session { _ in throw URLError(.notConnectedToInternet) }
        defer { offline.invalidateAndCancel() }
        do {
            _ = try await WeatherService(session: offline).getWeather(for: "0,0")
            XCTFail("Expected network error")
        } catch let error as URLError { XCTAssertEqual(error.code, .notConnectedToInternet) }
    }

    func testUnknownCityAndInvalidCoordinates() async throws {
        let session = session { _ in (200, Data(#"{"results":[]}"#.utf8)) }
        defer { session.invalidateAndCancel() }
        do {
            _ = try await WeatherService(session: session).getWeather(for: "NoSuchCity")
            XCTFail("Expected location-not-found error")
        } catch WeatherServiceError.locationNotFound { }
        for query in ["", "91,0", "0,181", "nan,0", "12,", "1,2,3"] {
            do {
                _ = try await WeatherService(session: session).getWeather(for: query)
                XCTFail("Expected invalid-location error for \(query)")
            } catch WeatherServiceError.invalidLocation { }
        }
    }

    func testRepositoryKeepsProviderDTOBehindExistingInterface() async throws {
        let service = StubService(response: try decode(fixture()))
        let repository: WeatherRepositoryProtocol = WeatherRepository(weatherService: service, locationNameResolver: StubLocationNameResolver())
        let model = try await repository.getWeather(for: "-26.1,28.0")
        XCTAssertEqual(service.lastQuery, "-26.1,28.0")
        XCTAssertEqual(model.currentTemp, "22.5°C")
        XCTAssertEqual(model.locationName, "Current location")
    }

    func testViewModelSavesCompatibleWidgetSnapshotAndPreservesItOnFailure() async throws {
        let defaults = try XCTUnwrap(UserDefaults(suiteName: "group.com.alfrxdjr.DailyPlanner-ToDo"))
        let oldData = defaults.data(forKey: "sharedWeatherData")
        defer { defaults.set(oldData, forKey: "sharedWeatherData") }
        let model = try WeatherMapper.map(from: decode(fixture()), locationName: "Sandton", now: now)
        let repository = StubRepository(model: model)
        let viewModel = WeatherViewModel(weatherRepository: repository)
        try await viewModel.fetchWeather(city: "Sandton")
        XCTAssertFalse(viewModel.isLoading)
        let snapshot = try XCTUnwrap(WeatherDataStore.load())
        XCTAssertEqual(snapshot.currentTemp, viewModel.weather.currentTemp)
        XCTAssertEqual(snapshot.condition, viewModel.weather.condition)
        XCTAssertEqual(snapshot.dailyForecast.count, viewModel.weather.dailyForecast.count)
        XCTAssertEqual(snapshot.dailyForecast.first?.highTemp, "26.0°C")
        XCTAssertEqual(snapshot.locationName, "Sandton")
        XCTAssertEqual(snapshot.timeZoneIdentifier, "Africa/Johannesburg")
        XCTAssertEqual(snapshot.sunriseDate, viewModel.weather.sunriseDate)
        let savedData = defaults.data(forKey: "sharedWeatherData")
        XCTAssertNotNil(snapshot.sunriseDate)
        repository.error = URLError(.timedOut)
        do {
            try await viewModel.fetchWeather(city: "Sandton")
            XCTFail("Expected failure")
        } catch { }
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(defaults.data(forKey: "sharedWeatherData"), savedData)
        XCTAssertEqual(viewModel.weather.currentTemp, snapshot.currentTemp)
    }

    func testOldWidgetSnapshotsStillDecode() throws {
        let data = Data(#"{"currentTemp":"20°C","highTemp":"25°C","lowTemp":"10°C","condition":"Sunny","icon":"sun.max.fill","sunrise":"06:00 AM","sunset":"06:00 PM","dailyForecast":[]}"#.utf8)
        let snapshot = try JSONDecoder().decode(SharedWeatherData.self, from: data)
        XCTAssertEqual(snapshot.currentTemp, "20°C")
        XCTAssertNil(snapshot.locationName)
        XCTAssertNil(snapshot.sunriseDate)
    }

    func testSlowFallbackCannotOverwriteNewerDeviceWeatherOrWidgetSnapshot() async throws {
        let defaults = try XCTUnwrap(UserDefaults(suiteName: "group.com.alfrxdjr.DailyPlanner-ToDo"))
        let oldData = defaults.data(forKey: "sharedWeatherData")
        defer { defaults.set(oldData, forKey: "sharedWeatherData") }
        let repository = PendingRepository()
        let viewModel = WeatherViewModel(weatherRepository: repository)
        let fallbackStarted = expectation(description: "Fallback started")
        repository.onStart = { _ in fallbackStarted.fulfill() }
        let fallback = _Concurrency.Task { try await viewModel.fetchWeather(city: "Sandton") }
        await fulfillment(of: [fallbackStarted], timeout: 2)

        let deviceStarted = expectation(description: "Device query started")
        repository.onStart = { _ in deviceStarted.fulfill() }
        let device = _Concurrency.Task { try await viewModel.fetchWeather(city: "-33.9249,18.4241") }
        await fulfillment(of: [deviceStarted], timeout: 2)
        repository.complete("-33.9249,18.4241", with: WeatherModel(currentTemp: "18", locationName: "Current location"))
        try await device.value
        repository.complete("Sandton", with: WeatherModel(currentTemp: "30", locationName: "Sandton"))
        try await fallback.value

        XCTAssertEqual(viewModel.weather.currentTemp, "18°C")
        XCTAssertEqual(viewModel.weather.locationName, "Current location")
        XCTAssertEqual(WeatherDataStore.load()?.locationName, "Current location")
        XCTAssertEqual(WeatherDataStore.load()?.currentTemp, "18°C")
        XCTAssertFalse(viewModel.isLoading)
    }

    func testCancelledLocationLoadDoesNotPublishWeather() async throws {
        let defaults = try XCTUnwrap(UserDefaults(suiteName: "group.com.alfrxdjr.DailyPlanner-ToDo"))
        let oldData = defaults.data(forKey: "sharedWeatherData")
        defer { defaults.set(oldData, forKey: "sharedWeatherData") }
        let repository = PendingRepository()
        let viewModel = WeatherViewModel(weatherRepository: repository)
        let started = expectation(description: "Request started")
        repository.onStart = { _ in started.fulfill() }
        let request = _Concurrency.Task { try await viewModel.fetchWeather(city: "Sandton") }
        await fulfillment(of: [started], timeout: 2)
        request.cancel()
        repository.complete("Sandton", with: WeatherModel(currentTemp: "30", locationName: "Sandton"))
        do {
            try await request.value
            XCTFail("Expected cancellation")
        } catch is CancellationError { }
        XCTAssertEqual(viewModel.weather.locationName, "")
        XCTAssertEqual(defaults.data(forKey: "sharedWeatherData"), oldData)
    }

    func testResolvedDeviceNameReachesTrayModelAndWidgetSnapshot() async throws {
        let defaults = try XCTUnwrap(UserDefaults(suiteName: "group.com.alfrxdjr.DailyPlanner-ToDo"))
        let oldData = defaults.data(forKey: "sharedWeatherData")
        defer { defaults.set(oldData, forKey: "sharedWeatherData") }
        let service = StubService(response: try decode(fixture()))
        let resolver = StubLocationNameResolver(name: " Cape Town ")
        let viewModel = WeatherViewModel(weatherRepository: WeatherRepository(
            weatherService: service, locationNameResolver: resolver
        ))
        try await viewModel.fetchWeather(city: "-33.9249,18.4241")
        XCTAssertEqual(service.lastQuery, "-33.9249,18.4241")
        XCTAssertEqual(resolver.latitude, -33.9249)
        XCTAssertEqual(resolver.longitude, 18.4241)
        XCTAssertEqual(viewModel.weather.locationName, "Cape Town")
        XCTAssertEqual(WeatherDataStore.load()?.locationName, "Cape Town")
    }

    func testPlaceNameLookupFailureKeepsDeviceWeatherWithoutUsingSandton() async throws {
        let service = StubService(response: try decode(fixture()))
        let resolver = StubLocationNameResolver()
        resolver.error = URLError(.notConnectedToInternet)
        let repository = WeatherRepository(weatherService: service, locationNameResolver: resolver)
        let weather = try await repository.getWeather(for: "-33.9249,18.4241")
        XCTAssertEqual(weather.currentTemp, "22.5°C")
        XCTAssertEqual(weather.locationName, "Current location")
        XCTAssertEqual(service.lastQuery, "-33.9249,18.4241")
    }

    func testFallbackCityNameDoesNotRequireReverseGeocoding() async throws {
        let service = StubService(response: try decode(fixture()))
        let resolver = StubLocationNameResolver(name: "Should not be used")
        let weather = try await WeatherRepository(weatherService: service, locationNameResolver: resolver)
            .getWeather(for: "Sandton")
        XCTAssertEqual(weather.locationName, "Sandton")
        XCTAssertNil(resolver.latitude)
    }

    private final class StubLocationNameResolver: WeatherLocationNameResolving {
        let name: String?
        var error: Error?
        var latitude: Double?
        var longitude: Double?

        init(name: String? = nil) { self.name = name }

        func locationName(latitude: Double, longitude: Double) async throws -> String? {
            self.latitude = latitude
            self.longitude = longitude
            if let error { throw error }
            return name
        }
    }

    private final class PendingRepository: WeatherRepositoryProtocol {
        var onStart: ((String) -> Void)?
        private var pending: [String: CheckedContinuation<WeatherModel, Error>] = [:]

        func getWeather(for city: String) async throws -> WeatherModel {
            try await withCheckedThrowingContinuation { continuation in
                pending[city] = continuation
                onStart?(city)
            }
        }

        func complete(_ query: String, with model: WeatherModel) {
            pending.removeValue(forKey: query)?.resume(returning: model)
        }
    }

    private final class StubRepository: WeatherRepositoryProtocol {
        let model: WeatherModel
        var error: Error?
        init(model: WeatherModel) { self.model = model }
        func getWeather(for city: String) async throws -> WeatherModel {
            if let error { throw error }
            return model
        }
    }

    private final class StubService: WeatherServiceProtocol {
        let response: OpenMeteoWeatherResponse
        var lastQuery: String?
        var error: Error?
        init(response: OpenMeteoWeatherResponse) { self.response = response }
        func getWeather(for city: String) async throws -> OpenMeteoWeatherResponse {
            lastQuery = city
            if let error { throw error }
            return response
        }
    }
}

private final class WeatherStubURLProtocol: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var handler: ((URLRequest) throws -> (Int, Data))?
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        do {
            guard let handler = Self.handler, let url = request.url else { throw URLError(.badURL) }
            let (status, data) = try handler(request)
            guard let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: nil) else {
                throw URLError(.badServerResponse)
            }
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch { client?.urlProtocol(self, didFailWithError: error) }
    }
    override func stopLoading() { }
}
