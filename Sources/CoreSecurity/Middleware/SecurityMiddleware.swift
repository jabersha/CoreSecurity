//
//  SecurityMiddleware.swift
//  CoreSecurity
//
//  Created by Jabinho on 27/11/25.
//

import Foundation

@available(macOS 10.15, *)
public final class SecurityMiddleware {

    private let deviceIDProvider: DeviceIDProvider

    public init(deviceIDProvider: DeviceIDProvider = DeviceIDProvider()) {
        self.deviceIDProvider = deviceIDProvider
    }

    public func apply(to request: inout URLRequest) {
        
        let risk = JailbreakDetector().detect()
        request.setValue(risk.rawValue, forHTTPHeaderField: "X-Device-Risk")
        request.setValue(deviceIDProvider.getDeviceID(), forHTTPHeaderField: "X-Device-ID")
        request.setValue(DeviceInfo.model, forHTTPHeaderField: "X-Device-Model")
        request.setValue(DeviceInfo.systemName, forHTTPHeaderField: "X-System-Name")
        request.setValue(DeviceInfo.systemVersion, forHTTPHeaderField: "X-System-Version")

        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"

        request.setValue(version, forHTTPHeaderField: "X-App-Version")
        request.setValue(build, forHTTPHeaderField: "X-App-Build")

        request.setValue(BundleHasher.infoPlistHash(), forHTTPHeaderField: "X-App-Integrity")
    }
}
