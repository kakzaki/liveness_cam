import Flutter
import UIKit
import FaceIdentifier

public class SwiftLivenessCamPlugin: NSObject, FlutterPlugin, FaceIdentifierDelegate {
  var result :FlutterResult?


  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "liveness_cam", binaryMessenger: registrar.messenger())
    let instance = SwiftLivenessCamPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    self.result = result

    if call.method == "start" {
      let viewController = UIApplication.shared.keyWindow?.rootViewController

      if viewController != nil {
            let client = FaceIdentifierClient()
        client.delegate = self
        client.showFaceIdentifier(viewController!)
      } else {
        result(FlutterError(code: "Unexpected nil", message: "Identifier-face: Could not retrieve rootViewController", details: "Expected rootViewController to be not nil"))
      }
    } else {
      result(FlutterMethodNotImplemented)
    }
  }

  public func faceIdentifierResult(_ faceResult: FaceIdentifierResult) {
      if let result = self.result {
            if faceResult != nil {
            result(faceResult.asJson())
          } else {
            result(FlutterError(code: "Unexpected nil", message: "Identifier-face: Could not retrieve face result", details: "Expected face result shouldn't be nil"))
          }
         }
  }
}
