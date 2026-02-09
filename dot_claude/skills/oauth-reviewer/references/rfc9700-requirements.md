# RFC 9700 — Normative Requirements

Full requirements extracted from [RFC 9700: OAuth 2.0 Security Best Current Practice](https://www.rfc-editor.org/rfc/rfc9700.txt). Organized by topic with RFC section references.

## Deprecated Grants

### D1 — No Resource Owner Password Credentials (§2.4)
> The resource owner password credentials grant MUST NOT be used.

This grant type passes user credentials directly to the client, defeating the purpose of OAuth delegation.

### D2 — No Implicit Grant (§2.1.2)
> Clients SHOULD NOT use the implicit grant or any response type causing access tokens to be issued in the authorization response.

Access tokens in the front channel (URL fragment) are exposed to browser history, referrer headers, and scripts.

---

## Redirect URI Validation

### R1 — Exact String Matching (§2.1, §4.1)
> Authorization servers MUST use exact string matching to compare redirect URIs.

**Exception**: Native apps using localhost may vary the port component only.

Pattern matching, substring matching, and wildcard URIs are prohibited — they enable redirect URI manipulation attacks.

### R2 — No Open Redirectors on Clients (§4.11)
> Clients MUST NOT expose open redirectors.

An open redirector on the client's redirect URI domain can be chained with a valid redirect_uri to leak authorization codes or tokens.

### R3 — No HTTP Scheme (§2.1)
> Authorization responses MUST NOT be transmitted over unencrypted HTTP.

**Exception**: Native apps using `http://localhost` or `http://127.0.0.1` loopback.

### R4 — Reject Invalid Redirect URIs Without Auto-Redirect (§4.11)
> Authorization servers MUST NOT automatically redirect the user agent on invalid client_id or redirect_uri combinations.

Display an error to the user instead. Auto-redirecting to an attacker-controlled URI leaks request parameters.

---

## PKCE (Proof Key for Code Exchange)

### P1 — Public Clients Must Use PKCE (§2.1.1)
> Public clients MUST use PKCE (RFC 7636).

Public clients cannot securely store client secrets, so PKCE is the primary defense against authorization code interception.

### P2 — Confidential Clients Should Use PKCE (§2.1.1)
> Confidential clients SHOULD use PKCE.

Even with client authentication, PKCE protects against authorization code injection and provides defense-in-depth.

### P3 — AS Must Support PKCE (§2.1.1)
> Authorization servers MUST support PKCE.

The AS must accept `code_challenge` and `code_verifier` parameters and enforce the challenge/verifier binding.

### P4 — Enforce code_verifier When code_challenge Present (§4.8)
> When a code_challenge was included in the authorization request, the AS MUST require a valid code_verifier in the token request.

Failure to enforce allows PKCE bypass — the attacker simply omits the verifier.

### P5 — Reject Unsolicited code_verifier (§4.8)
> The AS MUST reject token requests that include a code_verifier when no code_challenge was present in the authorization request.

This prevents PKCE downgrade attacks where the attacker strips the code_challenge from the authorization request.

### P6 — Prefer S256 Method (§2.1.1)
> Clients SHOULD use the S256 challenge method.

The `plain` method exposes the verifier if the authorization request is intercepted. S256 is a one-way transform.

### P7 — Transaction-Specific, User-Agent Bound (§2.1.1)
> Code challenge and nonce values MUST be transaction-specific and bound to the user agent session.

Reusing values across transactions or not binding to the session opens replay attacks.

---

## CSRF Protection

### C1 — Client Must Prevent CSRF (§2.1, §4.7)
> Clients MUST prevent CSRF on the redirect URI using one of:
> - PKCE (code_verifier is implicitly session-bound)
> - OpenID Connect nonce parameter
> - State parameter with a one-time, cryptographic CSRF token

If using `state`, it must be unpredictable, tied to the user's session, and validated upon receipt.

### C2 — State Invalidated After First Use (§4.2.4)
> The state parameter SHOULD be invalidated after first use at the client.

Accepting replayed state values allows CSRF replay.

---

## Authorization Code Handling

### A1 — Codes Invalidated After First Use (§4.2.4, §4.3)
> Authorization codes MUST be invalidated after their first use at the token endpoint.

Short-lived codes (recommended: seconds to minutes) reduce the attack window.

### A2 — Revoke Tokens on Code Replay (§4.2.4)
> If the AS detects an authorization code replay attempt, it SHOULD revoke all tokens previously issued for that grant.

This limits the impact of code theft.

### A3 — Validate Nonce in ID Token (§2.1.1, §4.5)
> Confidential OpenID Connect clients relying on nonce for code injection defense MUST validate the nonce claim in the ID Token received from the token endpoint.

All tokens must be disregarded until nonce validation succeeds.

---

## Token Security

### T1 — Sender-Constrained Access Tokens (§2.2, §4.10)
> Authorization servers and resource servers SHOULD use sender-constrained access tokens.

Methods: Mutual TLS certificate binding (RFC 8705) or DPoP (RFC 9449). Prevents token theft and replay.

### T2 — Minimum Privilege (§2.3)
> Access tokens SHOULD be restricted to the minimum privileges required.

Use narrow scopes, `authorization_details` (RFC 9396), or resource indicators.

### T3 — Audience Restriction (§2.3)
> Access tokens SHOULD be audience-restricted to the intended resource server(s).

Prevents a compromised RS from replaying tokens to other services. Use `aud` claim (RFC 9068) or token introspection.

### T4 — No Tokens in URI Query Parameters (§2.2)
> Access tokens MUST NOT be passed in URI query parameters (per RFC 6750).

Query parameters appear in server logs, browser history, and referrer headers.

---

## Refresh Tokens

### RT1 — Public Client Refresh Token Protection (§2.2, §4.14)
> For public clients, refresh tokens MUST be sender-constrained OR rotation MUST be used.

Rotation: each use of a refresh token issues a new one and invalidates the old. Detect replay by checking if an already-rotated token is reused.

### RT2 — Bound to Scope and Resource Server (§2.2)
> Refresh tokens MUST be bound to the scope and resource server(s) of the original grant.

Prevents scope escalation via refresh.

### RT3 — Replay Detection (§2.2, §4.14)
> Refresh token replay MUST be detected via sender-constraining or rotation.

If a rotated-out refresh token is presented, the AS should revoke the entire token family.

---

## Client Authentication

### CA1 — Enforce Where Feasible (§2.5)
> Authorization servers SHOULD enforce client authentication where feasible.

All confidential clients must authenticate. Public clients cannot, but other mechanisms (PKCE, redirect URI validation) compensate.

### CA2 — Prefer Asymmetric Methods (§2.5)
> Asymmetric cryptography for client authentication is RECOMMENDED.

Methods: Mutual TLS (RFC 8705) or `private_key_jwt` (RFC 7523). Avoids shared secret management issues.

---

## Mix-Up Attack Prevention

### M1 — Multi-AS Clients Must Defend (§2.1, §4.4)
> Clients interacting with multiple authorization servers MUST implement mix-up defense.

Methods:
- **SHOULD** use the `iss` response parameter (RFC 9207)
- **MAY** use distinct redirect URIs per authorization server

Mix-up attacks trick the client into sending an authorization code intended for one AS to the attacker's AS.

---

## Transport & Response Headers

### TH1 — End-to-End TLS (§2.6, §4.13)
> End-to-end TLS per BCP 195 is RECOMMENDED for all OAuth endpoints.

### TH2 — Reverse Proxy Header Sanitization (§4.13)
> Reverse proxies MUST sanitize inbound headers to prevent spoofing of security-relevant values (e.g., X-Forwarded-For, X-Real-IP).

Internal communications between proxy and application server must be authenticated and integrity-protected.

### TH3 — No 307 Redirects with Credentials (§4.12)
> Authorization servers MUST NOT use HTTP 307 redirects for responses containing credentials.

307 preserves the request method and body — a POST with credentials would be re-sent to the redirect target. Use 303 instead.

### TH4 — Referrer Policy (§4.2)
> Authorization endpoint and result pages SHOULD apply `Referrer-Policy: no-referrer`.

Prevents authorization codes and tokens from leaking via the Referer header.

### TH5 — No Third-Party Resources on Auth Pages (§4.2)
> Authorization endpoint and consent pages SHOULD NOT include third-party resources or links.

External resources can capture authorization codes via Referer headers.

---

## In-Browser Communication

### B1 — Verify postMessage Origin and Source (§4.17)
> Initiator and receiver MUST be strictly verified when using postMessage or similar cross-document messaging.

Check `event.origin` against an allowlist. Verify `event.source` is the expected window.

### B2 — No CORS at Authorization Endpoint (§2.6)
> CORS MUST NOT be supported at the authorization endpoint.

The authorization endpoint involves user interaction and redirects — CORS would enable cross-origin token theft.

### B3 — CORS at Token Endpoint (§2.6)
> CORS MAY be supported at the token endpoint and other direct-access endpoints.

Needed for browser-based clients (SPAs) making direct token requests.

---

## Authorization Server Metadata

### AS1 — Publish Metadata (§2.6)
> Authorization servers are RECOMMENDED to publish metadata per RFC 8414.

Enables automated discovery and reduces configuration errors.

### AS2 — Publish PKCE Support (§2.6)
> Authorization servers SHOULD publish `code_challenge_methods_supported` in metadata.

Clients need this to know which PKCE methods the AS accepts.

### AS3 — Clients Use Metadata (§2.6)
> Clients are RECOMMENDED to use AS metadata for configuration.

Hardcoded endpoint URLs are fragile and error-prone.

---

## Open Redirection

### OR1 — AS Authenticates Before Redirect (§4.11)
> Authorization servers MUST authenticate the user before redirecting to the client (except for silent auth/SSO use cases).

### OR2 — AS Only Auto-Redirects to Trusted URIs (§4.11)
> Authorization servers SHOULD only automatically redirect to pre-registered, trusted redirect URIs.

---

## Attacker Model (§3)

RFC 9700 defends against five attacker types:

| ID | Attacker | Capability |
|----|----------|------------|
| A1 | Web attacker | Controls arbitrary endpoints; can lure users to attacker-controlled sites |
| A2 | Network attacker | Full eavesdropping and manipulation of network traffic |
| A3 | Auth response reader | Can read (not modify) authorization responses (e.g., via Referer leakage) |
| A4 | Auth request reader | Can read (not modify) authorization requests (e.g., via browser history) |
| A5 | Token holder | Has acquired a valid access token (e.g., via compromised RS) |
