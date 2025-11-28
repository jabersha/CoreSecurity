//
//  Untitled.swift
//  CoreSecurity
//
//  Created by Jabinho on 27/11/25.
//

import Foundation

public enum NonceGenerator {
    public static func generate() -> String {
        UUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
}
