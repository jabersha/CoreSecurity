//
//  AESCipher.swift
//  CoreSecurity
//
//  Created by Jabinho on 27/11/25.
//

import Foundation
import CryptoKit

@available(macOS 10.15, *)
public enum AESCipher {

    public static func encrypt(_ text: String, using key: SymmetricKey) throws -> Data {
        let data = Data(text.utf8)
        return try AES.GCM.seal(data, using: key).combined!
    }

    public static func decrypt(_ encrypted: Data, using key: SymmetricKey) throws -> String {
        let sealed = try AES.GCM.SealedBox(combined: encrypted)
        let decrypted = try AES.GCM.open(sealed, using: key)
        return String(decoding: decrypted, as: UTF8.self)
    }
}
