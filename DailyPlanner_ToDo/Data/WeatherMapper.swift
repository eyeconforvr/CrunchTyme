import Foundation

/// The repository uses this mapper to keep Open-Meteo DTOs out of the UI.
struct WeatherMapper {
    static func map(
        from response: OpenMeteoWeatherResponse,
        locationName: String = "",
        now: Date = Date()
    ) throws -> WeatherModel {
        guard let current = response.current,
              let temperature = current.temperature, temperature.isFinite else {
            throw WeatherServiceError.unavailable
        }
        let zone = TimeZone(identifier: response.timezone)
            ?? TimeZone(secondsFromGMT: response.utcOffsetSeconds)
            ?? TimeZone(secondsFromGMT: 0)
            ?? .current
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = zone
        let startHour = calendar.dateInterval(of: .hour, for: now)?.start ?? now
        let endHour = startHour.addingTimeInterval(24 * 60 * 60)

        func format(_ date: Date, _ pattern: String) -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.calendar = calendar
            formatter.timeZone = zone
            formatter.dateFormat = pattern
            return formatter.string(from: date)
        }
        func date(_ timestamp: TimeInterval?) -> Date? {
            guard let timestamp, timestamp.isFinite else { return nil }
            return Date(timeIntervalSince1970: timestamp)
        }

        let daily = response.daily
        let todayIndex = daily?.time.firstIndex { timestamp in
            guard let day = date(timestamp) else { return false }
            return calendar.isDate(day, inSameDayAs: now)
        }
        let sunrise = todayIndex.flatMap { date(value(daily?.sunrise, at: $0)) }
        let sunset = todayIndex.flatMap { date(value(daily?.sunset, at: $0)) }
        let isDay = current.isDay.map { $0 == 1 }
            ?? sunrise.flatMap { rise in sunset.map { now >= rise && now < $0 } }
            ?? false
        let condition = WeatherConditionMapper.map(code: current.weatherCode, isDay: isDay)

        let dailyForecast = (daily?.time ?? []).enumerated().compactMap { index, timestamp -> DailyForecastModel? in
            guard let day = date(timestamp) else { return nil }
            let condition = WeatherConditionMapper.map(code: value(daily?.weatherCode, at: index), isDay: true)
            return DailyForecastModel(
                day: format(day, "EEEE"),
                highTemp: temperatureText(value(daily?.highTemperature, at: index)),
                lowTemp: temperatureText(value(daily?.lowTemperature, at: index)),
                icon: condition.icon,
                condition: condition.description
            )
        }
        let hourly = response.hourly
        let hourlyForecast = (hourly?.time ?? []).enumerated().compactMap { index, timestamp -> HourlyForecastModel? in
            guard let hour = date(timestamp), hour >= startHour, hour < endHour else { return nil }
            let condition = WeatherConditionMapper.map(code: value(hourly?.weatherCode, at: index),
                                                       isDay: value(hourly?.isDay, at: index) == 1)
            let temp = temperatureText(value(hourly?.temperature, at: index))
            return HourlyForecastModel(
                metrics: WeatherMetrics(
                    feelsLikeTemperature: finite(value(hourly?.apparentTemperature, at: index)),
                    humidity: finite(value(hourly?.humidity, at: index)),
                    precipitation: finite(value(hourly?.precipitation, at: index)),
                    windSpeed: finite(value(hourly?.windSpeed, at: index))
                ),
                time: hour == startHour ? "Now" : format(hour, "h a"),
                highTemp: temp, lowTemp: temp,
                icon: condition.icon, condition: condition.description
            )
        }
        return WeatherModel(
            sunrise: sunrise.map { format($0, "hh:mm a") } ?? "--",
            sunset: sunset.map { format($0, "hh:mm a") } ?? "--",
            currentTemp: number(temperature),
            highTemp: number(todayIndex.flatMap { value(daily?.highTemperature, at: $0) }),
            lowTemp: number(todayIndex.flatMap { value(daily?.lowTemperature, at: $0) }),
            icon: condition.icon,
            condition: condition.description,
            isDay: isDay,
            dailyForecast: dailyForecast,
            hourlyForecast: hourlyForecast,
            metrics: WeatherMetrics(feelsLikeTemperature: finite(current.apparentTemperature),
                                    humidity: finite(current.humidity),
                                    precipitation: finite(current.precipitation),
                                    windSpeed: finite(current.windSpeed)),
            locationName: locationName,
            timeZoneIdentifier: zone.identifier,
            sunriseDate: sunrise,
            sunsetDate: sunset
        )
    }

    private static func value<T>(_ values: [T?]?, at index: Int) -> T? {
        guard let values, values.indices.contains(index) else { return nil }
        return values[index]
    }

    private static func finite(_ value: Double?) -> Double? {
        guard let value, value.isFinite else { return nil }
        return value
    }

    private static func number(_ value: Double?) -> String {
        guard let value = finite(value) else { return "--" }
        return String(format: "%.1f", locale: Locale(identifier: "en_US_POSIX"), value)
    }

    private static func temperatureText(_ value: Double?) -> String {
        number(value) + "°C"
    }
}
