import Foundation
import Security

public final class ClientKeyStore {

    private let key = "secure-client-key"
    private let expirationKey = "secure-client-key-expiration"

    public init() {}

    public func save(clientKey: String, expiresAt: Date) {
        saveToKeychain(key: key, value: clientKey)
        saveToKeychain(key: expirationKey, value: String(expiresAt.timeIntervalSince1970))
    }

    public func getClientKey() -> String? {
        return loadFromKeychain(key: key)
    }

    public func isExpired() -> Bool {
        guard
            let expString = loadFromKeychain(key: expirationKey),
            let expSec = TimeInterval(expString)
        else { return true }

        return Date() > Date(timeIntervalSince1970: expSec)
    }

    // MARK: - Private Keychain helpers

    private func saveToKeychain(key: String, value: String) {
        let data = Data(value.utf8)

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)
        SecItemAdd(query, nil)
    }

    private func loadFromKeychain(key: String) -> String? {
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
//
//  ClienteKeyStore.swift
//  CoreSecurity
//
//  Created by Jabinho on 27/11/25.
//

