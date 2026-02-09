# OAuth Attack Patterns & Detection Guide

Attack scenarios from RFC 9700 §4 with code-level detection guidance.

---

## Authorization Code Interception (§4.3, §4.5)

**Attack**: Attacker intercepts the authorization code from the redirect URI (via malicious app on device, open redirector, or network eavesdropping) and exchanges it for tokens.

**Detection Questions**:
- Is PKCE used for all authorization code flows?
- Are authorization codes single-use?
- Are codes short-lived (seconds, not minutes)?

**Vulnerable Pattern**:
```
# Client sends auth request without PKCE
GET /authorize?response_type=code&client_id=X&redirect_uri=Y&state=Z
# Attacker intercepts code from redirect
# Attacker exchanges code at token endpoint (no code_verifier required)
```

**Secure Pattern**:
```
# Client generates code_verifier and code_challenge
verifier = random(32)
challenge = base64url(sha256(verifier))

GET /authorize?response_type=code&client_id=X&redirect_uri=Y
    &code_challenge=CHALLENGE&code_challenge_method=S256

# Token request requires the verifier
POST /token
    code=AUTH_CODE&code_verifier=VERIFIER
```

---

## Authorization Code Injection (§4.5)

**Attack**: Attacker obtains a valid authorization code (e.g., from their own authorization) and injects it into a victim's session via CSRF on the redirect URI.

**Detection Questions**:
- Does the client validate that the code was issued for its current session?
- Is PKCE used (code_verifier is session-bound)?
- For OIDC: is the nonce validated in the ID token?

**Vulnerable Pattern**:
```
# Client accepts any valid code at redirect URI
GET /callback?code=ATTACKER_CODE&state=VALID_STATE
# If state is not bound to the authorization request, injection succeeds
```

**Mitigation**: PKCE binds the code to the original session. The attacker's code won't match the victim's code_verifier.

---

## PKCE Downgrade Attack (§4.8)

**Attack**: Attacker strips `code_challenge` from the authorization request. If the AS doesn't enforce PKCE when it's expected, the flow proceeds without protection.

**Detection Questions**:
- Does the AS require PKCE for public clients unconditionally?
- Does the AS reject token requests with code_verifier if no code_challenge was in the auth request?
- Does the AS reject token requests without code_verifier if code_challenge was present?

**Vulnerable Pattern**:
```
# AS logic
if code_challenge is present:
    store_challenge(code_challenge)
# No enforcement if code_challenge is absent for public clients
```

**Secure Pattern**:
```
# AS logic
if client.is_public() and code_challenge is absent:
    reject("PKCE required for public clients")
if code_challenge is present and code_verifier is absent:
    reject("code_verifier required")
if code_challenge is absent and code_verifier is present:
    reject("unexpected code_verifier")
```

---

## Redirect URI Manipulation (§4.1)

**Attack**: Attacker registers or exploits a redirect URI that partially matches the legitimate one (subdomain, path prefix) to capture authorization codes.

**Detection Questions**:
- Does the AS compare redirect URIs using exact string match?
- Are wildcards, pattern matching, or subdomain matching used?
- Can different redirect URIs be registered per client?

**Vulnerable Pattern**:
```
# AS uses prefix/pattern matching
registered: https://client.example.com/callback
attack:     https://client.example.com/callback/../attacker
attack:     https://client.example.com/callback?redirect=evil.com
```

**Secure Pattern**:
```
# Exact string comparison
if request.redirect_uri != client.registered_redirect_uri:
    reject("redirect_uri mismatch")
```

---

## Mix-Up Attack (§4.4)

**Attack**: When a client works with multiple authorization servers, the attacker's AS tricks the client into sending the authorization code to the wrong token endpoint.

**Scenario**:
1. Client initiates flow with honest AS
2. Attacker's AS intercepts and returns a redirect to the client
3. Client sends the honest AS's code to attacker's token endpoint

**Detection Questions**:
- Does the client interact with multiple authorization servers?
- Does the client verify the `iss` parameter in the authorization response (RFC 9207)?
- Are distinct redirect URIs used per AS?

**Vulnerable Pattern**:
```
# Client doesn't track which AS initiated the flow
GET /callback?code=CODE&state=STATE
# Client uses whichever AS is "configured" without verifying origin
```

**Secure Pattern**:
```
# Client validates iss matches the AS that started the flow
GET /callback?code=CODE&state=STATE&iss=https://honest-as.example.com
if response.iss != session.expected_issuer:
    reject("issuer mismatch — possible mix-up attack")
```

---

## CSRF on Redirect URI (§4.7)

**Attack**: Attacker crafts a redirect URI response with an authorization code tied to the attacker's account, causing the victim to link the attacker's identity.

**Detection Questions**:
- Is state/nonce/PKCE used to bind the redirect response to the user's session?
- Is the state parameter cryptographically random and single-use?
- Is it verified against server-side session state?

**Vulnerable Pattern**:
```
# No state or PKCE
GET /authorize?response_type=code&client_id=X&redirect_uri=Y
# Attacker forges: GET /callback?code=ATTACKER_CODE
# Victim's browser follows the link, client accepts the code
```

---

## Token Leakage via Referrer (§4.2)

**Attack**: Authorization codes or tokens in URL fragments/query parameters leak via the Referer header when the page loads external resources or the user navigates away.

**Detection Questions**:
- Does the authorization response page set `Referrer-Policy: no-referrer`?
- Does the page include third-party scripts, images, or tracking pixels?
- Are tokens or codes ever placed in URL query parameters?

**Vulnerable Pattern**:
```html
<!-- Authorization response page includes external resources -->
<img src="https://analytics.example.com/pixel.gif">
<!-- Referer: https://client.example.com/callback?code=SECRET_CODE -->
```

---

## Refresh Token Replay (§4.14)

**Attack**: Attacker steals a refresh token and uses it before or after the legitimate client.

**Detection Questions**:
- Are refresh tokens rotated on each use?
- If rotation is used, does reuse of an old refresh token trigger revocation of the entire token family?
- Are refresh tokens sender-constrained (mTLS, DPoP)?

**Vulnerable Pattern**:
```
# No rotation — stolen refresh token usable indefinitely
POST /token
    grant_type=refresh_token&refresh_token=STOLEN_RT
# Returns new access token, same refresh token still valid
```

**Secure Pattern**:
```
# Rotation with replay detection
POST /token
    grant_type=refresh_token&refresh_token=RT_v1
# Returns: access_token=AT_new, refresh_token=RT_v2
# RT_v1 is now invalidated

# If RT_v1 is used again (by attacker):
# AS detects replay → revokes RT_v2 and all associated access tokens
```

---

## Open Redirector Abuse (§4.11)

**Attack**: An open redirector on the client or AS domain is chained with a legitimate redirect_uri to exfiltrate codes/tokens.

**Detection Questions**:
- Does the client have any endpoint that redirects to a user-supplied URL?
- Does the AS redirect to unregistered URIs on error?
- Are error responses auto-redirected?

**Vulnerable Pattern**:
```
# Client has an open redirector
GET /redirect?url=https://attacker.com

# Attacker uses it as redirect_uri (if AS allows)
GET /authorize?redirect_uri=https://client.example.com/redirect?url=https://attacker.com
```

---

## Access Token Replay (§4.10)

**Attack**: Stolen access token is replayed to a resource server by a different party.

**Detection Questions**:
- Are access tokens sender-constrained (bound to client's TLS cert or DPoP proof)?
- Are tokens audience-restricted?
- Is token introspection used for validation?

**Mitigation Hierarchy**:
1. **Best**: Sender-constrained tokens (mTLS or DPoP) — token is bound to the client's key
2. **Good**: Short-lived tokens with audience restriction
3. **Minimal**: Opaque tokens with introspection (but still replayable within lifetime)

---

## 307 Redirect Credential Leak (§4.12)

**Attack**: AS uses HTTP 307 redirect for a POST request containing credentials. The browser re-sends the POST body (including credentials) to the redirect target.

**Detection Questions**:
- Does the AS ever redirect POST requests?
- Are 303 redirects used instead of 307?
- Do any redirects carry credential data in the request body?

**Secure**: Always use 303 (See Other) for redirects after POST, which converts POST to GET and drops the body.

---

## Reverse Proxy Header Spoofing (§4.13)

**Attack**: Attacker sends forged headers (X-Forwarded-For, X-Forwarded-Proto) to manipulate the AS's perception of the request origin, potentially bypassing IP-based restrictions or TLS requirements.

**Detection Questions**:
- Does the reverse proxy strip/sanitize inbound X-Forwarded-* headers?
- Is the connection between proxy and application server authenticated?
- Does the application trust these headers for security decisions?
