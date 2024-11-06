import UIKit
import Flutter
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let bluetoothChannel = FlutterMethodChannel(name: "things_to_study.bluetooth/channel",
                                                binaryMessenger: controller.binaryMessenger)

    bluetoothChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "isHeadphoneConnected" {
        result(self.isHeadphoneConnected())
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func isHeadphoneConnected() -> Bool {
    let audioSession = AVAudioSession.sharedInstance()
    return audioSession.currentRoute.outputs.contains { $0.portType == .bluetoothA2DP }
  }
}
