---
name: jwt-library-flaws
description: Detect JWT library implementation vulnerabilities during code review. Use when reviewing JWT library implementations, auditing authentication/authorization code, encountering JWT parsing/verification logic, or investigating auth bypass vulnerabilities. Triggers: JWT verification, token signing, alg header handling, signature validation, JWS/JWE implementation, authentication bypass, algorithm confusion.
---

# JWT Library Vulnerability Detection

Identify implementation flaws in JWT libraries—not consumer misuse, but bugs in verification logic itself.

## Core Vulnerabilities

| Flaw | Detection Question |
|------|-------------------|
| **None Algorithm** | Does unknown/empty `alg` fail closed? Is "none" explicitly rejected? |
| **Algorithm Confusion** | Can `alg` header switch key type (RS→HS)? Is key type enforced? |
| **Empty Signature** | Does empty signature input cause verification to pass? |
| **Unknown Alg Fallthrough** | Does unsupported algorithm return error or empty/default value? |
| **Kid Injection** | Is `kid` sanitized before file/DB lookup? |
| **Embedded JWK** | Are `jwk`/`jku`/`x5u` headers trusted from token? |
| **Signature Skip** | Is there a decode path that bypasses verification? |

## Code Review Checklist

### Algorithm Handling
- [ ] Algorithm allowlist exists (not denylist)
- [ ] Algorithm specified server-side, not from token header
- [ ] Unknown algorithms throw/return error
- [ ] Case-insensitive "none"/"None"/"NONE" all rejected

### Signature Verification
- [ ] Empty/missing signature fails verification
- [ ] Signature computation errors propagate (not swallowed)
- [ ] No decode-without-verify public API

### Key Management
- [ ] Key type enforced (RSA key can't be used for HMAC)
- [ ] `kid` parameter sanitized (no path traversal, SQL injection)
- [ ] Embedded keys (`jwk`, `jku`, `x5u`) not trusted

## Red Flags

```
// DANGEROUS: Algorithm from token drives verification
alg = header["alg"]
verify(token, alg, key)

// DANGEROUS: Empty result instead of error
func getSignature(alg) -> string {
    if alg == "HS256": return hmac(...)
    return ""  // Should throw!
}

// DANGEROUS: Comparison passes on empty
if computedSig == providedSig  // Both empty = true!
```

## Secure Patterns

```
// CORRECT: Server specifies algorithm
verify(token, allowedAlgorithms=["RS256"], key)

// CORRECT: Fail on unknown
func getSignature(alg) -> Result<string, Error> {
    if alg == "HS256": return Ok(hmac(...))
    return Err("unsupported algorithm")
}

// CORRECT: Require non-empty signature
if sig.isEmpty(): return Err("missing signature")
if !constantTimeCompare(computed, provided): return Err("invalid")
```

## References

- [Vulnerability Catalog](references/vulnerability-catalog.md) - CVE details and attack patterns
- [Secure Patterns](references/secure-patterns.md) - Correct implementation examples
