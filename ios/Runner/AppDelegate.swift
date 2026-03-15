import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // --- NEW: Read from Secrets.plist ---
    var mapsApiKey = ""
    if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
       let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
       let key = dict["MAPS_API_KEY"] as? String {
        mapsApiKey = key
    }

    GMSServices.provideAPIKey(mapsApiKey)

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
