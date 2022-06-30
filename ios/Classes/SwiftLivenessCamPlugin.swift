import Flutter
import UIKit

public class SwiftLivenessCamPlugin: NSObject, FlutterPlugin{
  var result :FlutterResult?


  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "liveness_cam", binaryMessenger: registrar.messenger())
    let instance = SwiftLivenessCamPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    self.result = result

    if call.method == "start" {
      result(FlutterMethodNotImplemented)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }

}
