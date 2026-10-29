//
//  LocationService.swift
//  DailyPlanner_ToDo
//

import CoreLocation
import Observation

enum LocationError: LocalizedError {
    case notAuthorized

    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "Location access hasn't been granted."
        }
    }
}

@Observable
final class LocationService: NSObject, CLLocationManagerDelegate {

    // MARK: - State

    private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    private(set) var lastLocation: CLLocation?

    var isDetermined: Bool { authorizationStatus != .notDetermined }

    var isGranted: Bool {
        authorizationStatus == .authorizedWhenInUse
            || authorizationStatus == .authorizedAlways
    }

    var isDenied: Bool {
        authorizationStatus == .denied || authorizationStatus == .restricted
    }

    /// "lat,lon" string, e.g. "-26.1076,28.0567". Many weather APIs accept
    /// this directly as the query. nil until a location has been fetched.
    var coordinateQuery: String? {
        guard let coordinate = lastLocation?.coordinate else { return nil }
        return String(
            format: "%.4f,%.4f",
            coordinate.latitude,
            coordinate.longitude
        )
    }

    // MARK: - Private

    @ObservationIgnored private let manager = CLLocationManager()

    @ObservationIgnored
    private var pending: [CheckedContinuation<CLLocation, Error>] = []

    // MARK: - Init

    override init() {
        super.init()
        manager.delegate = self
        // City-level accuracy is plenty for weather and is faster and
        // more battery friendly than GPS-level accuracy.
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        authorizationStatus = manager.authorizationStatus
    }

    // MARK: - Public API

    /// Shows the system permission prompt (only the first time).
    func requestPermission() {
        #if DEBUG
        if Bundle.main.object(
            forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription"
        ) == nil {
            print("⚠️ LocationService: NSLocationWhenInUseUsageDescription is missing from Info.plist, so iOS will silently skip the permission prompt.")
        }
        print("LocationService: current authorization status = \(manager.authorizationStatus.rawValue) (0 = not determined, 1 = restricted, 2 = denied, 3 = always, 4 = when in use)")
        #endif

        manager.requestWhenInUseAuthorization()
    }

    /// One-shot fetch of the current location.
    /// Throws LocationError.notAuthorized if permission hasn't been given.
    @discardableResult
    func requestLocation() async throws -> CLLocation {
        guard isGranted else { throw LocationError.notAuthorized }

        return try await withCheckedThrowingContinuation { continuation in
            pending.append(continuation)
            manager.requestLocation()
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }

        lastLocation = location
        resumePending(with: .success(location))
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        resumePending(with: .failure(error))
    }

    private func resumePending(with result: Result<CLLocation, Error>) {
        let waiting = pending
        pending.removeAll()
        waiting.forEach { $0.resume(with: result) }
    }
}
