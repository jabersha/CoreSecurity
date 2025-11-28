//
//  CryptoUtils.swift
//  CoreSecurity
//
//  Created by Jabinho on 27/11/25.
//

import Foundation
import CryptoKit

@available(macOS 10.15, *)
public enum CryptoUtils {

    public static func sha256(_ text: String) -> String {
        let data = Data(text.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }

    public static func hmacSHA256(message: String, key: String) -> String {
        let keyData = SymmetricKey(data: Data(key.utf8))
        let messageData = Data(message.utf8)
        let code = HMAC<SHA256>.authenticationCode(for: messageData, using: keyData)
        return Data(code).map { String(format: "%02x", $0) }.joined()
    }
}
