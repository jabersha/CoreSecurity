//
//  CompositeKey.swift
//  CoreSecurity
//
//  Created by Jabinho on 27/11/25.
//

import Foundation
import CryptoKit

@available(macOS 10.15, *)
public enum CompositeKey {

    public static func generate(clientKey: String, deviceKey: String) -> SymmetricKey {
        let combined = clientKey + deviceKey
        let data = Data(combined.utf8)
        let hash = SHA256.hash(data: data)
        return SymmetricKey(data: Data(hash))
    }
}
