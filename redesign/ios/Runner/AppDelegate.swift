import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Read Google Maps API Key from .env asset
    var apiKey: String?
    if let envPath = Bundle.main.path(forResource: "flutter_assets/.env", ofType: nil) {
      if let envContent = try? String(contentsOfFile: envPath, encoding: .utf8) {
        let lines = envContent.components(separatedBy: .newlines)
        for line in lines {
          let parts = line.components(separatedBy: "=")
          if parts.count >= 2 {
            let key = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
            if key == "GOOGLE_MAPS_API_KEY" {
              var val = parts[1...].joined(separator: "=").trimmingCharacters(in: .whitespacesAndNewlines)
              // Strip quotes if any
              if val.hasPrefix("\"") && val.hasSuffix("\"") {
                val = String(val.dropFirst().dropLast())
              } else if val.hasPrefix("'") && val.hasSuffix("'") {
                val = String(val.dropFirst().dropLast())
              }
              apiKey = val
              break
            }
          }
        }
      }
    }
    
    if let key = apiKey, !key.isEmpty {
      GMSServices.provideAPIKey(key)
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
