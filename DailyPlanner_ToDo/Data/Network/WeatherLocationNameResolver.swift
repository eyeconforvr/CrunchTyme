import CoreLocation
import MapKit

/// Converts the coordinates selected by RootTabView into a display name only.
/// Weather requests continue using those coordinates, never the resolved name.
final class WeatherLocationNameResolver: WeatherLocationNameResolving {
    func locationName(latitude: Double, longitude: Double) async throws -> String? {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        guard let request = MKReverseGeocodingRequest(location: location) else { return nil }
        let items = try await request.mapItems
        guard let address = items.first?.addressRepresentations else { return nil }
        return address.cityName ?? address.cityWithContext
    }
}
