//
//  DeviceIDProvider.swift
//  CoreSecurity
//
//  Created by Jabinho on 27/11/25.
//

import Foundation
import Security

public final class DeviceIDProvider {

    private let key = "secure-device-id"

    public init() {}

    public func getDeviceID() -> String {
        if let value = load() { return value }

        let newID = UUID().uuidString
        save(newID)
        return newID
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
