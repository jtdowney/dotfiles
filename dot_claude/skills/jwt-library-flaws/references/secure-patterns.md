# Secure JWT Implementation Patterns

## Algorithm Enforcement

### Allowlist Pattern
```python
ALLOWED_ALGORITHMS = frozenset(["RS256", "RS384", "RS512"])

def verify(token: str, key: Key) -> Claims:
    header = decode_header(token)
    alg = header.get("alg", "")

    if alg not in ALLOWED_ALGORITHMS:
        raise InvalidAlgorithmError(f"Algorithm '{alg}' not permitted")

    return _verify_with_algorithm(token, alg, key)
```

### Key Type Enforcement
```python
def verify(token: str, key: Key, algorithms: List[str]) -> Claims:
    header = decode_header(token)
    alg = header["alg"]

    if alg not in algorithms:
        raise InvalidAlgorithmError("Algorithm not in allowed list")

    # Enforce key type matches algorithm family
    if alg.startswith("HS"):
        if not isinstance(key, bytes):
            raise KeyTypeError("HMAC algorithms require symmetric key (bytes)")
    elif alg.startswith("RS") or alg.startswith("PS"):
        if not isinstance(key, RSAPublicKey):
            raise KeyTypeError("RSA algorithms require RSA public key")
    elif alg.startswith("ES"):
        if not isinstance(key, EllipticCurvePublicKey):
            raise KeyTypeError("ECDSA algorithms require EC public key")

    return _verify_signature(token, alg, key)
```

---

## Signature Computation

### Error Propagation Pattern
```go
func GetSignature(alg string, key []byte, input []byte) ([]byte, error) {
    switch alg {
    case "HS256":
        return computeHMAC(sha256.New, key, input), nil
    case "HS384":
        return computeHMAC(sha512.New384, key, input), nil
    case "HS512":
        return computeHMAC(sha512.New, key, input), nil
    default:
        return nil, fmt.Errorf("unsupported algorithm: %s", alg)
    }
}

func Verify(token string, key []byte, allowedAlgs []string) (Claims, error) {
    header, payload, sig, err := parse(token)
    if err != nil {
        return nil, err
    }

    alg := header.Alg
    if !contains(allowedAlgs, alg) {
        return nil, ErrAlgorithmNotAllowed
    }

    computed, err := GetSignature(alg, key, signingInput(header, payload))
    if err != nil {
        return nil, err  // Propagate error, don't swallow
    }

    if len(sig) == 0 {
        return nil, ErrEmptySignature
    }

    if !hmac.Equal(computed, sig) {
        return nil, ErrSignatureInvalid
    }

    return decodeClaims(payload)
}
```

---

## None Algorithm Rejection

### Explicit Check Pattern
```python
def verify(token: str, key: Key, algorithms: List[str]) -> Claims:
    header = decode_header(token)
    alg = header.get("alg", "").strip()

    # Explicit none rejection (case-insensitive)
    if alg.lower() == "none" or alg == "":
        raise InvalidAlgorithmError("'none' algorithm is not permitted")

    if alg not in algorithms:
        raise InvalidAlgorithmError(f"Algorithm '{alg}' not in allowed list")

    sig = get_signature(token)
    if not sig:
        raise InvalidSignatureError("Token has no signature")

    return _verify_signature(token, alg, key)
```

---

## Empty Signature Protection

### Non-Empty Validation Pattern
```rust
fn verify(token: &str, key: &Key, allowed: &[Algorithm]) -> Result<Claims, Error> {
    let parts: Vec<&str> = token.split('.').collect();
    if parts.len() != 3 {
        return Err(Error::MalformedToken);
    }

    let signature = base64_decode(parts[2])?;

    // CRITICAL: Reject empty signatures
    if signature.is_empty() {
        return Err(Error::EmptySignature);
    }

    let header = decode_header(parts[0])?;

    if !allowed.contains(&header.alg) {
        return Err(Error::AlgorithmNotAllowed);
    }

    let computed = compute_signature(&header.alg, key, &signing_input)?;

    // Constant-time comparison
    if !constant_time_eq(&computed, &signature) {
        return Err(Error::InvalidSignature);
    }

    decode_claims(parts[1])
}
```

---

## Kid Sanitization

### Safe Key Lookup Pattern
```python
import re
import os

# Allowlist pattern for key IDs
KID_PATTERN = re.compile(r'^[a-zA-Z0-9_-]{1,64}$')

def get_key_by_kid(kid: str) -> Key:
    # Validate kid format
    if not kid or not KID_PATTERN.match(kid):
        raise InvalidKeyIdError("Invalid key ID format")

    # Use mapping, not file path construction
    key_mapping = {
        "key-2024-01": load_key("/keys/key1.pem"),
        "key-2024-02": load_key("/keys/key2.pem"),
    }

    if kid not in key_mapping:
        raise KeyNotFoundError(f"Unknown key ID: {kid}")

    return key_mapping[kid]
```

### Database Lookup Pattern
```python
def get_key_by_kid(kid: str, db: Database) -> Key:
    # Parameterized query - never string interpolation
    result = db.execute(
        "SELECT key_material FROM signing_keys WHERE kid = ? AND active = 1",
        (kid,)  # Parameter binding
    )

    if not result:
        raise KeyNotFoundError("Key not found")

    return deserialize_key(result[0])
```

---

## Embedded Key Rejection

### Ignore Untrusted Headers Pattern
```python
UNTRUSTED_HEADERS = {"jwk", "jku", "x5u", "x5c"}

def verify(token: str, key: Key, algorithms: List[str]) -> Claims:
    header = decode_header(token)

    # Warn or reject tokens with embedded key headers
    untrusted = set(header.keys()) & UNTRUSTED_HEADERS
    if untrusted:
        raise UntrustedHeaderError(
            f"Token contains untrusted headers: {untrusted}. "
            "Embedded keys are not accepted."
        )

    # Use only server-configured key
    return _verify_signature(token, header["alg"], key)
```

---

## Constant-Time Comparison

### Language-Specific Patterns

**Python**:
```python
import hmac

def verify_signature(computed: bytes, provided: bytes) -> bool:
    return hmac.compare_digest(computed, provided)
```

**Go**:
```go
import "crypto/subtle"

func verifySignature(computed, provided []byte) bool {
    return subtle.ConstantTimeCompare(computed, provided) == 1
}
```

**Rust**:
```rust
use constant_time_eq::constant_time_eq;

fn verify_signature(computed: &[u8], provided: &[u8]) -> bool {
    constant_time_eq(computed, provided)
}
```

**Node.js**:
```javascript
const crypto = require('crypto');

function verifySignature(computed, provided) {
    if (computed.length !== provided.length) {
        return false;
    }
    return crypto.timingSafeEqual(computed, provided);
}
```

---

## Complete Secure Verification Flow

```python
from typing import List, Set
import hmac

ALLOWED_ALGORITHMS: Set[str] = {"RS256", "RS384", "RS512"}
FORBIDDEN_HEADERS: Set[str] = {"jwk", "jku", "x5u", "x5c"}

def verify_jwt(token: str, key: Key, allowed_algorithms: List[str] = None) -> Claims:
    """
    Securely verify a JWT token.

    Implements:
    - Algorithm allowlisting
    - None algorithm rejection
    - Empty signature rejection
    - Key type enforcement
    - Embedded key rejection
    - Constant-time comparison
    """
    allowed = set(allowed_algorithms or ALLOWED_ALGORITHMS)

    # Parse token
    parts = token.split('.')
    if len(parts) != 3:
        raise MalformedTokenError("Token must have 3 parts")

    header_b64, payload_b64, sig_b64 = parts
    header = decode_header(header_b64)

    # 1. Reject untrusted headers
    untrusted = set(header.keys()) & FORBIDDEN_HEADERS
    if untrusted:
        raise UntrustedHeaderError(f"Forbidden headers: {untrusted}")

    # 2. Get and validate algorithm
    alg = header.get("alg", "").strip()
    if not alg or alg.lower() == "none":
        raise InvalidAlgorithmError("Algorithm required and 'none' forbidden")

    if alg not in allowed:
        raise InvalidAlgorithmError(f"Algorithm '{alg}' not permitted")

    # 3. Validate key type matches algorithm
    _validate_key_type(alg, key)

    # 4. Decode and validate signature presence
    provided_sig = base64url_decode(sig_b64)
    if len(provided_sig) == 0:
        raise InvalidSignatureError("Empty signature not permitted")

    # 5. Compute expected signature
    signing_input = f"{header_b64}.{payload_b64}".encode()
    computed_sig = compute_signature(alg, key, signing_input)

    # 6. Constant-time comparison
    if not hmac.compare_digest(computed_sig, provided_sig):
        raise InvalidSignatureError("Signature verification failed")

    # 7. Decode and return claims
    return decode_claims(payload_b64)
```

---

## Summary: Defense Checklist

| Defense | Implementation |
|---------|---------------|
| Algorithm allowlist | Explicit set of permitted algorithms |
| None rejection | Case-insensitive check, empty string check |
| Empty sig rejection | Length check before comparison |
| Key type enforcement | Match key class to algorithm family |
| Kid sanitization | Allowlist pattern, parameterized queries |
| Embedded key rejection | Check and reject jwk/jku/x5u/x5c headers |
| Constant-time compare | Use `hmac.compare_digest` or equivalent |
| Error propagation | Return errors, don't return empty/default |
