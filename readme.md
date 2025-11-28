# CoreSecurity

O **CoreSecurity** é o módulo responsável por todas as camadas de segurança aplicadas às requisições, incluindo integridade do corpo, proteção contra replay, autenticação via HMAC, identificação segura de device/app e detecção de alterações no app (anti-tamper).

Ele funciona como base criptográfica e de segurança para o CoreNetwork.

---

# 🎯 1. Objetivos

- Garantir integridade de requisições (hash do body).
- Prevenir ataques de replay (nonce + timestamp + janela de validade).
- Garantir autenticidade (HMAC-SHA256).
- Fornecer identificação confiável de device.
- Adicionar contexto de segurança de versão do app.
- Sinalizar possíveis manipulações do binário (anti‑tamper).
- Manter as features desacopladas da segurança.

---

# 🧱 2. Arquitetura Interna

Organizado em três grandes camadas consumidas pelo CoreNetwork:

---

## 2.1 Camada de Integridade – Hash do Corpo

- Extrai body.
- Calcula SHA‑256.
- Injeta header:

```
X-Body-Hash: <hash-hex>
```

---

## 2.2 Camada Anti‑Replay – Nonce, Timestamp e HMAC

Processo:

1. Gera nonce.
2. Obtém timestamp UNIX.
3. Reusa hash do corpo.
4. Monta mensagem canônica:

```
timestamp + "\n" + nonce + "\n" + bodyHash
```

5. Calcula HMAC‑SHA256.
6. Injeta headers:

```
X-Nonce: <nonce>
X-Timestamp: <ts>
X-Signature: <hmac>
X-Time-Window: <interval>
```

---

## 2.3 Middleware de Segurança – Device, App e Anti-Tamper

### 🔹 Device

- `X-Device-ID` (persistido no Keychain)
- `X-Device-Model`
- `X-System-Name`
- `X-System-Version`

### 🔹 App

- `X-App-Version`
- `X-App-Build`

### 🔹 Anti‑Tamper

- `X-App-Integrity`
  - hash derivado de arquivos do bundle

---

# 🔧 3. Utilitários Internos

- **CryptoUtils** – SHA256, HMAC.
- **NonceGenerator** – UUIDs únicos.
- **DeviceIDProvider** – persistência segura via Keychain.
- **BundleHasher** – cálculo de integridade do bundle.
- **SecurityMiddleware** – aplica metadata de device/app/anti‑tamper.

---

# 🤝 4. Integração com CoreNetwork

Fluxo executado pelo SecureRequestBuilder:

```
applyHash()
applyNonce()
applyHMAC()
applyMiddlewareDeviceAppIntegrity()
```

O CoreSecurity nunca envia requisições — ele apenas prepara os dados.

---

# 🚀 5. Exemplo de Assinatura HMAC

```swift
let message = "\(timestamp)
\(nonce)
\(bodyHash)"
let signature = CryptoUtils.hmacSHA256(message, key: secretKey)
```

Inject:

```swift
request.addValue(signature, forHTTPHeaderField: "X-Signature")
```

---

# 🔒 6. Segurança e Boas Práticas

- Chaves privadas **nunca** devem ficar no app.
- O servidor deve validar:
  - integridade do body
  - timestamp dentro da janela
  - nonce não utilizado antes
  - assinatura HMAC correta
  - integridade do app
- DeviceID deve existir apenas em Keychain.

---

# 📦 7. Instalação

```swift
.package(url: "https://github.com/seu-org/CoreSecurity.git", branch: "main")
```

---

# ✅ 8. Resumo

- Camadas robustas de segurança.
- Totalmente integradas ao CoreNetwork.
- Arquitetura escalável e desacoplada.
- Proteção contra replay, adulteração e manipulação do app.
