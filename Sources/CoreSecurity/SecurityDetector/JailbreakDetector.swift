//
//  JailbreakDetector.swift
//  CoreSecurity
//
//  Created by Jabinho on 27/11/25.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

public final class JailbreakDetector {

    public init() {}

    public func detect() -> DeviceRisk {

        if isEmulator() {
            return .emulator
        }

        if hasSuspiciousFiles() { return .compromised }
        if canWriteOutsideSandbox() { return .compromised }
        if canOpenRestrictedPaths() { return .compromised }

        return .safe
    }

    // MARK: - Checks

    private func hasSuspiciousFiles() -> Bool {

        let suspiciousPaths = [
            "/Applications/Cydia.app",
            "/Applications/FakeCarrier.app",
            "/Applications/Icy.app",
            "/Applications/IntelliScreen.app",
            "/Applications/SBSettings.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/"
        ]

        for path in suspiciousPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }

        return false
    }

    private func canWriteOutsideSandbox() -> Bool {
        let path = "/private/jbr_test.txt"
        do {
            try "test".write(toFile: path, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }

    private func canOpenRestrictedPaths() -> Bool {
        let restricted = "/private/var/lib/apt"
        let result = fopen(restricted, "r")
        if result != nil {
            fclose(result)
            return true
        }
        return false
    }

    private func isEmulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}
