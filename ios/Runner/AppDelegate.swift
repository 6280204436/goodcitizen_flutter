import UIKit
import Flutter
import UserNotifications
import CoreLocation
import GoogleMaps // Import Google Maps SDK

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var foregroundLocationTimer: Timer?
    private var locationEmitTimer: Timer?
    private var authToken: String = ""
    private var lastKnownLocation: CLLocation?
    private var minDistanceForUpdate: Double = 0.0 // meters
    private var isSilentPushReceived = false
    private var silentPushPayload: [AnyHashable: Any]?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Google Maps SDK with error handling
        let googleMapsApiKey = "AIzaSyD7x-mHIFb-SFE-D4r0sABCiT5IfM-1FmU" // Replace with your actual Google Maps API key
       // Replace with your actual API key
            if googleMapsApiKey.isEmpty {
                print("❌ Google Maps API key is missing. Please provide a valid API key in AppDelegate.")
                logError("Google Maps API key is missing")
            } else {
                GMSServices.provideAPIKey(googleMapsApiKey)
                print("✅ Google Maps SDK initialized successfully with API key: \(String(googleMapsApiKey.prefix(10)))...")
            }

        GeneratedPluginRegistrant.register(with: self)
        setupLocationManager()
        registerForPushNotifications(application)
        UNUserNotificationCenter.current().delegate = self

        print("🚀 App launched at: \(Date().description)")
        print("📋 Launch options: \(String(describing: launchOptions))")

        if let notificationPayload = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            print("🚀💀 KILL MODE NOTIFICATION RECEIVED: App launched from push!")
            print("📦 Payload: \(notificationPayload)")
            print("⏰ Timestamp: \(Date().description)")
            print("📱 App State: INACTIVE (Kill Mode Launch)")
            print("🔍 APS Dictionary: \(notificationPayload["aps"] ?? "No APS")")

            if let aps = notificationPayload["aps"] as? [String: Any], aps["content-available"] as? Int == 1 {
                print("🤫 SILENT PUSH DETECTED IN KILL MODE!")
                isSilentPushReceived = true
                silentPushPayload = notificationPayload
                handleSilentPushInKillMode(payload: notificationPayload)
            } else {
                print("📢 REGULAR PUSH DETECTED IN KILL MODE!")
            }
            logPushNotification(payload: notificationPayload, type: "kill_mode_notification")
        } else {
            print("🔍 No kill mode notification in launch options")
        }

        setupFlutterMethodChannel()
        setupAppStateObservers()
        refreshTokenFromUserDefaults()

        if !authToken.isEmpty {
            print("🔑 Found stored auth token: \(String(authToken.prefix(10)))...")
            print("✅ Auth token loaded from storage")
        } else {
            print("⚠️ No stored auth token found, waiting for token from Flutter")
            print("📝 API operations will be skipped until token is provided")
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - Silent Push Handling

    private func handleSilentPushInKillMode(payload: [AnyHashable: Any]) {
        print("🤫 Handling silent push in kill mode...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.getCurrentLocationAndEmitToSocket(reason: "Silent Push (Kill Mode)", payload: payload)
        }
    }

    private func handleSilentPushInBackground(payload: [AnyHashable: Any]) {
        print("🤫 Handling silent push in background mode...")
        getCurrentLocationAndEmitToSocket(reason: "Silent Push (Background)", payload: payload)
    }

    private func getCurrentLocationAndEmitToSocket(reason: String, payload: [AnyHashable: Any]) {
        print("📍 Getting location for \(reason)...")
        guard CLLocationManager.locationServicesEnabled() else {
            print("❌ Location services not enabled")
            logError("Location services not enabled for \(reason)")
            return
        }

        let authStatus = locationManager.authorizationStatus
        guard authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways else {
            print("❌ Location authorization not granted. Status: \(authStatus.rawValue)")
            logError("Location authorization not granted for \(reason)")
            return
        }

        if let location = locationManager.location {
            print("📍 Location obtained for \(reason):")
            print("   Lat: \(location.coordinate.latitude)")
            print("   Lng: \(location.coordinate.longitude)")
            print("   Accuracy: \(location.horizontalAccuracy)m")
            performSilentPushLocationEmission(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                accuracy: location.horizontalAccuracy,
                reason: reason,
                payload: payload
            )
        } else {
            print("❌ No location available, requesting fresh location...")
            locationManager.requestLocation()
        }
    }

    // MARK: - API Helper
    private func sendLocationToBackend(latitude: Double, longitude: Double, accuracy: Double, reason: String, rideId: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !authToken.isEmpty else {
            let errorMessage = "Cannot send location to backend - no auth token available"
            print("❌ \(errorMessage)")
            logError(errorMessage)
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            return
        }

        let urlString = "https://api.agoodcitizen.in/v1/web-socket/save_location?lat=\(latitude)&long=\(longitude)"
        guard let url = URL(string: urlString) else {
            let errorMessage = "Invalid URL for location API: \(urlString)"
            print("❌ \(errorMessage)")
            logError(errorMessage)
            completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("*/*", forHTTPHeaderField: "Accept")

        let body: [String: Any] = [
            "accuracy": accuracy,
            "timestamp": Date().timeIntervalSince1970,
            "reason": reason,
            "app_state": UIApplication.shared.applicationState.rawValue == 0 ? "FOREGROUND" : UIApplication.shared.applicationState.rawValue == 1 ? "INACTIVE" : "BACKGROUND",
            "ride_id": rideId as Any
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("❌ Failed to serialize request body: \(error)")
            logError("Failed to serialize request body: \(error)")
            completion(.failure(error))
            return
        }

        print("🌐 Sending location to backend: \(urlString)")
        print("   Headers: Authorization: Bearer \(String(authToken.prefix(10)))...")
        print("   Body: \(body)")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Failed to send location to backend: \(error)")
                self.logError("Failed to send location to backend: \(error)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let errorMessage = "Invalid response from backend"
                print("❌ \(errorMessage)")
                self.logError(errorMessage)
                completion(.failure(NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                print("✅ Successfully sent location to backend. Status: \(httpResponse.statusCode)")
                completion(.success(()))
            } else {
                let errorMessage = "Failed to send location. Status: \(httpResponse.statusCode)"
                print("❌ \(errorMessage)")
                self.logError(errorMessage)
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }
        task.resume()
    }

    private func performSilentPushLocationEmission(
        latitude: Double,
        longitude: Double,
        accuracy: Double,
        reason: String,
        payload: [AnyHashable: Any]
    ) {
        var rideId: String?
        if let customData = payload["data"] as? [String: Any] {
            rideId = customData["ride_id"] as? String
        }

        var locationData: [String: Any] = [
            "lat": latitude,
            "long": longitude,
            "timestamp": Date().timeIntervalSince1970,
            "accuracy": accuracy,
            "reason": reason,
            "app_state": UIApplication.shared.applicationState.rawValue == 0 ? "FOREGROUND" : UIApplication.shared.applicationState.rawValue == 1 ? "INACTIVE" : "BACKGROUND"
        ]

        if let rideId = rideId {
            locationData["ride_id"] = rideId
        }

        print("🔌 Preparing to emit location data for \(reason):")
        print("   Lat: \(latitude)")
        print("   Lng: \(longitude)")
        print("   Ride ID: \(rideId ?? "Not available")")
        print("   App State: \(locationData["app_state"] ?? "Unknown")")

        sendLocationToBackend(latitude: latitude, longitude: longitude, accuracy: accuracy, reason: reason, rideId: rideId) { result in
            switch result {
            case .success:
                print("✅ Location successfully sent to backend for \(reason)")
                self.logSilentPushLocationEmission(
                    latitude: latitude,
                    longitude: longitude,
                    accuracy: accuracy,
                    reason: reason,
                    payload: payload,
                    response: ["status": "success"]
                )
            case .failure(let error):
                print("❌ Failed to send location to backend for \(reason): \(error)")
                self.logSilentPushLocationEmission(
                    latitude: latitude,
                    longitude: longitude,
                    accuracy: accuracy,
                    reason: reason,
                    payload: payload,
                    response: ["status": "failed", "error": error.localizedDescription]
                )
            }
        }
    }

    // MARK: - Location Manager Setup

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Minimum distance (meters) before an update is triggered
        locationManager.allowsBackgroundLocationUpdates = true // Allow background updates
        locationManager.pausesLocationUpdatesAutomatically = false // Prevent pausing in background
        locationManager.activityType = .other // Adjust based on your use case (e.g., .automotiveNavigation for ridesharing)
        
        // Request both "When In Use" and "Always" authorization
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        // Start monitoring significant location changes for background resilience
        locationManager.startMonitoringSignificantLocationChanges()
        
        // Start updating location immediately if authorized
        let authStatus = locationManager.authorizationStatus
        if authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            print("📍 Started location updates in setupLocationManager")
        }
        
        print("📍 Location Manager setup completed at: \(Date().description)")
    }

    // MARK: - App State Observers

    private func setupAppStateObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }

    @objc private func appDidBecomeActive() {
        print("📱 App became ACTIVE - Starting foreground location tracking")
        startForegroundLocationTracking()
        startLocationEmitTimer()
        isSilentPushReceived = false
        silentPushPayload = nil
        refreshTokenFromUserDefaults()
    }

    @objc private func appDidEnterBackground() {
        print("📱 App entered BACKGROUND - Ensuring location updates continue")
        stopForegroundLocationTracking() // Stop foreground-specific timers
        if CLLocationManager.locationServicesEnabled() {
            let authStatus = locationManager.authorizationStatus
            if authStatus == .authorizedAlways {
                locationManager.startUpdatingLocation() // Ensure continuous updates in background
                print("📍 Started continuous location updates in background")
            } else {
                print("⚠️ No 'Always' authorization, falling back to significant location changes")
                locationManager.startMonitoringSignificantLocationChanges()
            }
        } else {
            print("❌ Location services not enabled in background")
            logError("Location services not enabled in background")
        }
    }

    // MARK: - Location Tracking

    private func startForegroundLocationTracking() {
        stopForegroundLocationTracking()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        foregroundLocationTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            self.getCurrentLocationAndPrint(reason: "Foreground 30s Timer")
        }
        print("📍 Started foreground location tracking with 30s timer at: \(Date().description)")
    }

    private func stopForegroundLocationTracking() {
        foregroundLocationTimer?.invalidate()
        foregroundLocationTimer = nil
        print("📍 Stopped foreground location tracking timer at: \(Date().description)")
    }

    public func setAuthToken(_ token: String) {
        guard !token.isEmpty else {
            print("❌ Invalid auth token provided: empty")
            logError("Invalid auth token provided: empty")
            return
        }
        authToken = token
        UserDefaults.standard.set(token, forKey: "auth_token")
        UserDefaults.standard.set(token, forKey: "authToken")
        UserDefaults.standard.synchronize()
        print("🔑 Auth token set and stored: \(String(token.prefix(10)))...")
        print("✅ Token length: \(token.count) characters")
        print("✅ API operations are now enabled")
    }

    private func refreshTokenFromUserDefaults() {
        if let storedToken = UserDefaults.standard.string(forKey: "authToken"), !storedToken.isEmpty {
            authToken = storedToken
            print("🔄 Token retrieved from UserDefaults with key 'authToken': \(String(storedToken.prefix(10)))...")
            print("✅ Full auth token (preview): \(String(storedToken.prefix(20)))...")
            print("✅ Token length: \(storedToken.count) characters")
        } else if let storedToken = UserDefaults.standard.string(forKey: "auth_token"), !storedToken.isEmpty {
            authToken = storedToken
            print("🔄 Token retrieved from UserDefaults with key 'auth_token': \(String(storedToken.prefix(10)))...")
            print("✅ Full auth token (preview): \(String(storedToken.prefix(20)))...")
            print("✅ Token length: \(storedToken.count) characters")
        } else {
            print("⚠️ No auth token found in UserDefaults for keys 'authToken' or 'auth_token'")
            authToken = ""
        }
    }

    private func startLocationEmitTimer() {
        stopLocationEmitTimer()
        locationEmitTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            self.emitCurrentLocation()
        }
        print("📍🔌 Started location emit timer (10s interval) at: \(Date().description)")
    }

    private func stopLocationEmitTimer() {
        locationEmitTimer?.invalidate()
        locationEmitTimer = nil
        print("📍🔌 Stopped location emit timer at: \(Date().description)")
    }

    private func emitCurrentLocation() {
        if authToken.isEmpty {
            if let storedToken = UserDefaults.standard.string(forKey: "authToken"), !storedToken.isEmpty {
                authToken = storedToken
                print("🔑 Retrieved auth token from UserDefaults for location emission: \(String(storedToken.prefix(10)))...")
            } else {
                print("⚠️ Skipping location emission - no auth token available in UserDefaults")
                logError("Cannot emit location - no auth token available in UserDefaults")
                return
            }
        }
        if let location = locationManager.location {
            if shouldEmitLocation(newLocation: location) {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                let accuracy = location.horizontalAccuracy
                let reason = "Location Emit Timer"

                sendLocationToBackend(latitude: latitude, longitude: longitude, accuracy: accuracy, reason: reason, rideId: nil) { result in
                    switch result {
                    case .success:
                        print("✅ Location successfully sent to backend for \(reason)")
                        self.logLocationEmission(location: location)
                    case .failure(let error):
                        print("❌ Failed to send location to backend for \(reason): \(error)")
                        self.logError("Failed to send location to backend: \(error)")
                    }
                }

                lastKnownLocation = location
            } else {
                print("📍🔌 Skipping location emit - moved less than \(minDistanceForUpdate)m")
            }
        } else {
            print("📍🔌 No current location available for emission")
            locationManager.requestLocation()
        }
    }

    private func shouldEmitLocation(newLocation: CLLocation) -> Bool {
        guard let lastLocation = lastKnownLocation else {
            return true
        }
        let distance = lastLocation.distance(from: newLocation)
        return distance >= minDistanceForUpdate
    }

    private func getCurrentLocationAndPrint(reason: String) {
        if let location = locationManager.location {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let timestamp = Date().description
            print("📍 LOCATION (\(reason)): Lat: \(latitude), Lng: \(longitude)")
            print("⏰ Location Timestamp: \(timestamp)")
            print("🎯 Accuracy: \(location.horizontalAccuracy)m")
            logLocation(latitude: latitude, longitude: longitude, reason: reason)
        } else {
            print("❌ Location not available for reason: \(reason)")
            locationManager.requestLocation()
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print("📍 Location Updated: Lat: \(latitude), Lng: \(longitude)")
        print("⏰ Update Timestamp: \(Date().description)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location Manager Error: \(error)")
        logError("Location Manager Error: \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("📍 Location Authorization Status Changed: \(status.rawValue)")
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Location authorization granted")
            if UIApplication.shared.applicationState == .active {
                startForegroundLocationTracking()
            }
        case .denied, .restricted:
            print("❌ Location authorization denied/restricted")
            logError("Location authorization denied or restricted")
        case .notDetermined:
            print("🔍 Location authorization not determined")
        @unknown default:
            print("🔍 Unknown location authorization status")
        }
    }

    // MARK: - Push Notification Registration

    private func registerForPushNotifications(_ application: UIApplication) {
        print("📱 Registering for push notifications at: \(Date().description)...")
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            print("🔍 Push notification authorization granted: \(granted)")
            if let error = error {
                print("❌ Push notification authorization error: \(error)")
                self.logError("Push notification authorization error: \(error)")
            } else if !granted {
                print("❌ Push notification authorization denied by user")
                self.logError("Push notification authorization denied by user")
            }
            DispatchQueue.main.async {
                print("🔍 Requesting remote notification registration...")
                application.registerForRemoteNotifications()
            }
        }
    }

    override func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("✅ Device Token registered: \(token)")
        print("⏰ Timestamp: \(Date().description)")
        UserDefaults.standard.set(token, forKey: "device_token")
        logDeviceToken(token)
    }

    override func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("❌ Failed to register for remote notifications: \(error)")
        print("⏰ Timestamp: \(Date().description)")
        logError("Failed to register for remote notifications: \(error)")
    }

    // MARK: - Push Notification Handler

    override func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        let appState = application.applicationState.rawValue == 0 ? "FOREGROUND" : application.applicationState.rawValue == 1 ? "INACTIVE" : "BACKGROUND"
        print("🔔 NOTIFICATION RECEIVED!")
        print("📦 Payload: \(userInfo)")
        print("⏰ Timestamp: \(Date().description)")
        print("📱 App State: \(appState)")
        print("🔍 APS Dictionary: \(userInfo["aps"] ?? "No APS")")

        if let aps = userInfo["aps"] as? [String: Any], aps["content-available"] as? Int == 1 {
            print("🤫 SILENT PUSH DETECTED!")
            if application.applicationState == .background {
                print("🤫 Handling silent push in BACKGROUND mode")
                handleSilentPushInBackground(payload: userInfo)
            } else if application.applicationState == .inactive {
                print("🤫 Handling silent push in INACTIVE mode")
                handleSilentPushInBackground(payload: userInfo)
            } else {
                print("🤫 Silent push received in FOREGROUND - no special handling needed")
            }
            logPushNotification(payload: userInfo, type: "silent_push")
        } else {
            print("📢 REGULAR PUSH DETECTED!")
            logPushNotification(payload: userInfo, type: "regular_push")
        }

        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(name: "com.example/silent_push", binaryMessenger: controller.binaryMessenger)
            channel.invokeMethod("onPushNotification", arguments: userInfo) { result in
                print("📡 MethodChannel result: \(String(describing: result))")
            }
        } else {
            print("❌ No FlutterViewController available for MethodChannel")
        }

        completionHandler(.newData)
    }

    // MARK: - UNUserNotificationCenterDelegate

    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        print("🔔 FOREGROUND NOTIFICATION RECEIVED!")
        print("📦 Payload: \(userInfo)")
        print("⏰ Timestamp: \(Date().description)")
        print("📱 App State: FOREGROUND")
        print("🔍 APS Dictionary: \(userInfo["aps"] ?? "No APS")")
        logPushNotification(payload: userInfo, type: "foreground_notification")

        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(name: "com.example/silent_push", binaryMessenger: controller.binaryMessenger)
            channel.invokeMethod("onPushNotification", arguments: userInfo) { result in
                print("📡 MethodChannel result: \(String(describing: result))")
            }
        } else {
            print("❌ No FlutterViewController available for MethodChannel")
        }

        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }

    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        print("🔔 NOTIFICATION TAPPED!")
        print("📦 Payload: \(userInfo)")
        print("⏰ Timestamp: \(Date().description)")
        print("📱 App State: \(UIApplication.shared.applicationState.rawValue == 0 ? "FOREGROUND" : "INACTIVE")")
        print("🔍 APS Dictionary: \(userInfo["aps"] ?? "No APS")")
        logPushNotification(payload: userInfo, type: "tapped_notification")

        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(name: "com.example/silent_push", binaryMessenger: controller.binaryMessenger)
            channel.invokeMethod("onPushNotification", arguments: userInfo) { result in
                print("📡 MethodChannel result: \(String(describing: result))")
            }
        } else {
            print("❌ No FlutterViewController available for MethodChannel")
        }

        completionHandler()
    }

    // MARK: - Flutter Method Channel

    private func setupFlutterMethodChannel() {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            print("❌ Failed to get FlutterViewController for MethodChannel at: \(Date().description)")
            logError("Failed to get FlutterViewController for MethodChannel")
            return
        }

        let channel = FlutterMethodChannel(
            name: "com.example/silent_push",
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
            case "getPushLogs":
                let logs = UserDefaults.standard.array(forKey: "push_logs") as? [[String: Any]] ?? []
                print("📜 Returning \(logs.count) push logs to Flutter at: \(Date().description)")
                result(logs)
            case "getLocationLogs":
                let logs = UserDefaults.standard.array(forKey: "location_logs") as? [[String: Any]] ?? []
                print("📍 Returning \(logs.count) location logs to Flutter at: \(Date().description)")
                result(logs)
            case "getCurrentLocation":
                self.getCurrentLocationAndPrint(reason: "Flutter Request")
                if let location = self.locationManager.location {
                    let locationData: [String: Any] = [
                        "latitude": location.coordinate.latitude,
                        "longitude": location.coordinate.longitude,
                        "timestamp": Date().timeIntervalSince1970,
                        "accuracy": location.horizontalAccuracy
                    ]
                    print("📍 Returning location to Flutter: \(locationData)")
                    result(locationData)
                } else {
                    print("📍 No location available for Flutter request")
                    result(nil)
                }
            case "setAuthToken":
                if let token = call.arguments as? String {
                    self.setAuthToken(token)
                    result("Token set successfully")
                } else {
                    print("❌ Invalid token argument: \(String(describing: call.arguments))")
                    result(FlutterError(code: "INVALID_TOKEN", message: "Token must be a non-empty string", details: nil))
                }
            case "startLocationEmit":
                self.startLocationEmitTimer()
                result("Location emit timer started")
            case "stopLocationEmit":
                self.stopLocationEmitTimer()
                result("Location emit timer stopped")
            case "emitLocationNow":
                self.emitCurrentLocation()
                result("Manual location emission triggered")
            case "getSilentPushLogs":
                let logs = UserDefaults.standard.array(forKey: "silent_push_logs") as? [[String: Any]] ?? []
                print("🤫 Returning \(logs.count) silent push logs to Flutter at: \(Date().description)")
                result(logs)
            case "getAuthTokenStatus":
                self.refreshTokenFromUserDefaults()
                let status: [String: Any] = [
                    "hasToken": !self.authToken.isEmpty,
                    "tokenLength": self.authToken.count,
                    "tokenPreview": self.authToken.isEmpty ? "No token" : String(self.authToken.prefix(10)) + "...",
                    "storedToken": UserDefaults.standard.string(forKey: "auth_token") ?? "No stored token",
                    "flutterStoredToken": UserDefaults.standard.string(forKey: "authToken") ?? "No Flutter stored token",
                    "currentToken": self.authToken.isEmpty ? "No current token" : String(self.authToken.prefix(10)) + "..."
                ]
                print("🔍 Returning auth token status to Flutter: \(status)")
                result(status)
            case "clearAuthToken":
                self.authToken = ""
                UserDefaults.standard.removeObject(forKey: "auth_token")
                UserDefaults.standard.removeObject(forKey: "authToken")
                UserDefaults.standard.synchronize()
                print("🗑️ Auth token cleared")
                result("Auth token cleared")
            case "refreshTokenFromStorage":
                self.refreshTokenFromUserDefaults()
                let status: [String: Any] = [
                    "hasToken": !self.authToken.isEmpty,
                    "tokenLength": self.authToken.count,
                    "tokenPreview": self.authToken.isEmpty ? "No token" : String(self.authToken.prefix(10)) + "..."
                ]
                print("🔄 Returning refreshed token status to Flutter: \(status)")
                result(status)
            case "getNoAuthTokenErrors":
                let logs = UserDefaults.standard.array(forKey: "error_logs") as? [[String: Any]] ?? []
                let filteredLogs = logs.filter { log in
                    if let message = log["message"] as? String {
                        return message.contains("Cannot emit location - no auth token available in UserDefaults") ||
                               message.contains("Cannot send location to backend - no auth token available")
                    }
                    return false
                }
                print("📜 Returning \(filteredLogs.count) no-auth-token error logs to Flutter at: \(Date().description)")
                result(filteredLogs)
            default:
                print("❌ Unimplemented method: \(call.method) at: \(Date().description)")
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // MARK: - Logging Helpers

    private func logPushNotification(payload: [AnyHashable: Any], type: String) {
        var logs = UserDefaults.standard.array(forKey: "push_logs") as? [[String: Any]] ?? []
        let logEntry: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970,
            "type": type,
            "payload": payload,
            "app_state": UIApplication.shared.applicationState.rawValue == 0 ? "FOREGROUND" : UIApplication.shared.applicationState.rawValue == 1 ? "INACTIVE" : "BACKGROUND"
        ]
        logs.append(logEntry)
        if logs.count > 50 {
            logs = Array(logs.suffix(50))
        }
        UserDefaults.standard.set(logs, forKey: "push_logs")
        print("📜 Logged \(type) at: \(Date().description)")
    }

    private func logLocation(latitude: Double, longitude: Double, reason: String) {
        var logs = UserDefaults.standard.array(forKey: "location_logs") as? [[String: Any]] ?? []
        let logEntry: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970,
            "latitude": latitude,
            "longitude": longitude,
            "reason": reason,
            "app_state": UIApplication.shared.applicationState.rawValue == 0 ? "FOREGROUND" : UIApplication.shared.applicationState.rawValue == 1 ? "INACTIVE" : "BACKGROUND"
        ]
        logs.append(logEntry)
        if logs.count > 100 {
            logs = Array(logs.suffix(100))
        }
        UserDefaults.standard.set(logs, forKey: "location_logs")
        print("📍 Logged location (\(reason)) at: \(Date().description)")
    }

    private func logLocationEmission(location: CLLocation) {
        var logs = UserDefaults.standard.array(forKey: "socket_emit_logs") as? [[String: Any]] ?? []
        let logEntry: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970,
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "accuracy": location.horizontalAccuracy,
            "app_state": UIApplication.shared.applicationState.rawValue == 0 ? "FOREGROUND" : UIApplication.shared.applicationState.rawValue == 1 ? "INACTIVE" : "BACKGROUND",
            "payload": ["lat": location.coordinate.latitude, "long": location.coordinate.longitude, "timestamp": Date().timeIntervalSince1970, "accuracy": location.horizontalAccuracy]
        ]
        logs.append(logEntry)
        if logs.count > 100 {
            logs = Array(logs.suffix(100))
        }
        UserDefaults.standard.set(logs, forKey: "socket_emit_logs")
        print("🔌 Logged socket emission at: \(Date().description)")
    }

    private func logSilentPushLocationEmission(
        latitude: Double,
        longitude: Double,
        accuracy: Double,
        reason: String,
        payload: [AnyHashable: Any],
        response: [String: String]
    ) {
        var logs = UserDefaults.standard.array(forKey: "silent_push_logs") as? [[String: Any]] ?? []
        let logEntry: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970,
            "latitude": latitude,
            "longitude": longitude,
            "accuracy": accuracy,
            "reason": reason,
            "payload": payload,
            "response": response,
            "app_state": UIApplication.shared.applicationState.rawValue == 0 ? "FOREGROUND" : UIApplication.shared.applicationState.rawValue == 1 ? "INACTIVE" : "BACKGROUND"
        ]
        logs.append(logEntry)
        if logs.count > 100 {
            logs = Array(logs.suffix(100))
        }
        UserDefaults.standard.set(logs, forKey: "silent_push_logs")
        print("🤫 Logged silent push location emission at: \(Date().description)")
    }

    private func logDeviceToken(_ token: String) {
        var logs = UserDefaults.standard.array(forKey: "device_token_logs") as? [[String: Any]] ?? []
        let logEntry: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970,
            "token": token
        ]
        logs.append(logEntry)
        if logs.count > 10 {
            logs = Array(logs.suffix(10))
        }
        UserDefaults.standard.set(logs, forKey: "device_token_logs")
        print("📜 Logged device token at: \(Date().description)")
    }

    private func logError(_ message: String) {
        var logs = UserDefaults.standard.array(forKey: "error_logs") as? [[String: Any]] ?? []
        let logEntry: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970,
            "message": message
        ]
        logs.append(logEntry)
        if logs.count > 50 {
            logs = Array(logs.suffix(50))
        }
        UserDefaults.standard.set(logs, forKey: "error_logs")
        print("❌ Logged error: \(message) at: \(Date().description)")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        foregroundLocationTimer?.invalidate()
        locationEmitTimer?.invalidate()
    }
}
