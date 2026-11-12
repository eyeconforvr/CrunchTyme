import Foundation

/// Keeps provider codes out of the presentation layer.

enum WeatherConditionMapper {
    struct Condition {
        let description: String
        let icon: String
    }

    static func map(code: Int?, isDay: Bool) -> Condition {
        switch code {
        case 0, 1:
            return Condition(description: isDay ? "Sunny" : "Clear",
                             icon: isDay ? "sun.max.fill" : "moon.stars.fill")
        case 2:
            return Condition(description: "Partly cloudy",
                             icon: isDay ? "cloud.sun.fill" : "cloud.moon.fill")
        case 3: return Condition(description: "Overcast", icon: "smoke.fill")
        case 45: return Condition(description: "Fog", icon: "cloud.fog.fill")
        case 48: return Condition(description: "Freezing fog", icon: "cloud.fog.fill")
        case 51, 53, 55, 56, 57:
            return Condition(description: "Light drizzle", icon: "cloud.drizzle.fill")
        case 61, 66, 80:
            return Condition(description: "Light rain", icon: "cloud.rain.fill")
        case 63, 81:
            return Condition(description: "Moderate rain", icon: "cloud.rain.fill")
        case 65, 67, 82:
            return Condition(description: "Heavy rain", icon: "cloud.heavyrain.fill")
        case 71, 77, 85:
            return Condition(description: "Light snow", icon: "cloud.snow.fill")
        case 73: return Condition(description: "Moderate snow", icon: "snow")
        case 75, 86: return Condition(description: "Heavy snow", icon: "snowflake")
        case 95, 96, 97, 99:
            return Condition(description: "Thunderstorm", icon: "cloud.bolt.rain.fill")
        default: return Condition(description: "Unknown", icon: "cloud")
        }
    }
}
