//
//  DeviceInfo.swift
//  CoreSecurity
//
//  Created by Jabinho on 27/11/25.
//

#if canImport(UIKit)
import UIKit
#endif
import Foundation

public struct DeviceInfo {

    public static var model: String {
        #if canImport(UIKit)
        UIDevice.current.model
        #else
        "unknown"
        #endif
    }

    public static var systemName: String {
        #if canImport(UIKit)
        UIDevice.current.systemName
        #else
        "unknown"
        #endif
    }

    public static var systemVersion: String {
        #if canImport(UIKit)
        UIDevice.current.systemVersion
        #else
        "unknown"
        #endif
    }
}
