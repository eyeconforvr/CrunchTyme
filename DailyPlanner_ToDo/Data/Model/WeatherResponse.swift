import Foundation

/// Provider DTOs only. Views and widgets consume WeatherModel/SharedWeatherData.
/// Requests use timeformat=unixtime so all timestamps are absolute UTC instants.
struct OpenMeteoWeatherResponse: Decodable {
    let timezone: String
    let utcOffsetSeconds: Int
    let current: Current?
    let hourly: Hourly?
    let daily: Daily?

    enum CodingKeys: String, CodingKey {
        case timezone, current, hourly, daily
        case utcOffsetSeconds = "utc_offset_seconds"
    }

    struct Current: Decodable {
        let time: TimeInterval
        let temperature: Double?
        let apparentTemperature: Double?
        let humidity: Double?
        let precipitation: Double?
        let windSpeed: Double?
        let weatherCode: Int?
        let isDay: Int?

        enum CodingKeys: String, CodingKey {
            case time, precipitation
            case temperature = "temperature_2m"
            case apparentTemperature = "apparent_temperature"
            case humidity = "relative_humidity_2m"
            case windSpeed = "wind_speed_10m"
            case weatherCode = "weather_code"
            case isDay = "is_day"
        }
    }

    struct Hourly: Decodable {
        let time: [TimeInterval]
        let temperature: [Double?]?
        let apparentTemperature: [Double?]?
        let humidity: [Double?]?
        let precipitation: [Double?]?
        let windSpeed: [Double?]?
        let weatherCode: [Int?]?
        let isDay: [Int?]?

        enum CodingKeys: String, CodingKey {
            case time, precipitation
            case temperature = "temperature_2m"
            case apparentTemperature = "apparent_temperature"
            case humidity = "relative_humidity_2m"
            case windSpeed = "wind_speed_10m"
            case weatherCode = "weather_code"
            case isDay = "is_day"
        }
    }

    struct Daily: Decodable {
        let time: [TimeInterval]
        let highTemperature: [Double?]?
        let lowTemperature: [Double?]?
        let sunrise: [TimeInterval?]?
        let sunset: [TimeInterval?]?
        let weatherCode: [Int?]?

        enum CodingKeys: String, CodingKey {
            case time, sunrise, sunset
            case highTemperature = "temperature_2m_max"
            case lowTemperature = "temperature_2m_min"
            case weatherCode = "weather_code"
        }
    }
}

struct OpenMeteoGeocodingResponse: Decodable {
    let results: [Place]?

    struct Place: Decodable {
        let name: String
        let latitude: Double
        let longitude: Double
    }
}
