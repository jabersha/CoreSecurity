//
//  DeviceKeyProvider.swift
//  CoreSecurity
//
//  Created by Jabinho on 27/11/25.
//

import Foundation
import Security
import CryptoKit

@available(macOS 10.15, *)
public final class DeviceKeyProvider {

    private let key = "secure-device-hmac-key"

    public init() {}

    public func getOrCreateDeviceKey() -> String {
        if let existing = load() { return existing }

        let newKey = SymmetricKey(size: .bits256)
        let base64 = Data(newKey.withUnsafeBytes { Data($0) }).base64EncodedString()

        save(base64)
        return base64
    }

    private func save(_ value: String) {
        let data = Data(value.utf8)

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)
        SecItemAdd(query, nil)
    }

    private func load() -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)

        guard let data = result as? Data else { return nil }
        return String(decoding: data, as: UTF8.self)
    }
}
