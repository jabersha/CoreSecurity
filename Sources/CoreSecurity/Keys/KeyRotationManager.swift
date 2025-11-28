//
//  KeyRotationManager.swift
//  CoreSecurity
//
//  Created by Jabinho on 27/11/25.
//

import Foundation
import CryptoKit

@available(macOS 10.15, *)
public final class KeyRotationManager {

    private let clientKeyStore: ClientKeyStore
    private let deviceKeyProvider: DeviceKeyProvider

    public init(
        clientKeyStore: ClientKeyStore = ClientKeyStore(),
        deviceKeyProvider: DeviceKeyProvider = DeviceKeyProvider()
    ) {
        self.clientKeyStore = clientKeyStore
        self.deviceKeyProvider = deviceKeyProvider
    }

    /// Obtém a chave atual composta (clientKey + deviceKey)
    public func currentCompositeKey(clientFallback: String) -> SymmetricKey {
        let deviceKey = deviceKeyProvider.getOrCreateDeviceKey()

        let clientKey = getValidClientKey() ?? clientFallback

        return CompositeKey.generate(clientKey: clientKey, deviceKey: deviceKey)
    }

    /// Retorna a chave do servidor se estiver válida
    private func getValidClientKey() -> String? {
        guard let key = clientKeyStore.getClientKey(),
              !clientKeyStore.isExpired() else {
            return nil
        }
        return key
    }

    /// Chamado após login ou endpoint dedicado
    public func updateClientKey(fromServer newKey: String, expiresAt: Date) {
        clientKeyStore.save(clientKey: newKey, expiresAt: expiresAt)
    }
}
