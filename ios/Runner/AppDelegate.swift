import UIKit
import Flutter
import CoreMotion

@available(iOS 14.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let METHOD_CHANNEL_NAME = "com.gb.accelerometer/method"
    let MOTION_CHANNEL_NAME = "com.gb.accelerometer/motion"
    let pressureStreamHandler = PressureStreamHandler()
    let motionStreamHandler = MotionStreamHandler()
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    
    let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME, binaryMessenger: controller.binaryMessenger)
    
    methodChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        switch call.method {
        case "isSensorAvailable":
            result(CMHeadphoneMotionManager.authorizationStatus)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    })
      
      let motionChannel = FlutterEventChannel(name: MOTION_CHANNEL_NAME, binaryMessenger: controller.binaryMessenger)
      motionChannel.setStreamHandler(motionStreamHandler)
    
    let pressureChannel = FlutterEventChannel(name: MOTION_CHANNEL_NAME, binaryMessenger: controller.binaryMessenger)
    pressureChannel.setStreamHandler(pressureStreamHandler)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
