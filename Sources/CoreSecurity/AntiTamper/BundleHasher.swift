//
//  BundleHasher.swift
//  CoreSecurity
//
//  Created by Jabinho on 27/11/25.
//

import Foundation
import CryptoKit

@available(macOS 10.15, *)
public enum BundleHasher {

    public static func infoPlistHash() -> String {
        guard
            let url = Bundle.main.url(forResource: "Info", withExtension: "plist"),
            let data = try? Data(contentsOf: url)
        else { return "" }

        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
