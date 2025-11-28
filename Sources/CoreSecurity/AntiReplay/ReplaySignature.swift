//
//  ReplaySignature.swift
//  CoreSecurity
//
//  Created by Jabinho on 27/11/25.
//

import Foundation

public struct ReplaySignaturePayload {
    public let timestamp: Int
    public let nonce: String
    public let bodyHash: String
}
