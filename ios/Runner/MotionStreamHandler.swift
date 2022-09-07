//
//  MotionStreamHandler.swift
//  Runner
//
//  Created by Galiiabanu Bakirova on 10.08.22.
//

import Foundation
import CoreMotion

@available(iOS 14.0, *)
class MotionStreamHandler: NSObject, FlutterStreamHandler {
    let headphonesManager = CMHeadphoneMotionManager()
    private let queue = OperationQueue()
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        
        if headphonesManager.isDeviceMotionAvailable {
            headphonesManager.startDeviceMotionUpdates(to: queue) {
                (data,error) in
                if data != nil {
                    //get motion
                    let motion = data?.userAcceleration
                    events(motion!.y)
                }
            }
        }
        
       /* if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: queue) { (data,error) in
                if data != nil {
                //Get pressure
                let pressurePascals = data?.pressure
                    events(pressurePascals!.doubleValue * 10.0)
             }
            }
        }*/
        return nil
    }
    
    func onCancel(withArguments arguments:Any?) -> FlutterError? {
        headphonesManager.stopDeviceMotionUpdates()
        return nil
    }
    
}
