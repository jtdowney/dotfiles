---
name: rfc-compliance
description: Evaluate a project's compliance with an RFC or standard. Use when asked to assess, audit, or check implementation against RFC specifications, IETF standards, W3C specs, or similar technical standards. Applies Postel's Law—be conservative in what you send, be liberal in what you accept.
---

# RFC Compliance Evaluation

Evaluate a codebase against an RFC or technical standard, applying Postel's Law throughout.

## Workflow

### 1. Fetch the Standard

For IETF RFCs, use the fetch script:

```bash
python3 scripts/fetch_rfc.py <number>
```

For other standards (W3C, WHATWG, etc.), use WebFetch to retrieve the specification.

### 2. Define Scope

Clarify with the user:
- Which role does this implementation play? (client, server, both)
- Any specific sections to focus on?
- Known areas of concern?

Exclude sections that don't apply (e.g., server requirements for a client-only library).

### 3. Extract Requirements

Scan the RFC for requirement keywords per [RFC 2119](references/rfc2119.md):
- **MUST/MUST NOT** - Absolute requirements (evaluate first)
- **SHOULD/SHOULD NOT** - Strong recommendations (evaluate second)
- **MAY** - Optional features (evaluate last)

### 4. Evaluate Compliance

For each requirement, locate the relevant code and assess:
- **✅ Compliant** - Requirement fully satisfied
- **⚠️ Partial** - Met with caveats
- **❌ Non-compliant** - Violated or missing
- **➖ N/A** - Doesn't apply
- **❓ Unknown** - Cannot determine

Apply Postel's Law:
- **Sending**: Implementation must strictly conform to spec
- **Receiving**: Implementation should accept reasonable variations

See [evaluation-guide.md](references/evaluation-guide.md) for detailed patterns.

### 5. Report Findings

Write a narrative report with embedded checklist elements:

1. **Executive Summary** - Overall status, critical issues
2. **Scope** - What was evaluated and excluded
3. **Critical Findings** - MUST/MUST NOT violations with evidence
4. **Recommendations** - SHOULD deviations worth addressing
5. **Optional Features** - MAY items and their status
6. **Detailed Analysis** - Section-by-section findings

Always cite both RFC sections (`RFC 8555 §7.1`) and code locations (`src/account.gleam:45`).

## Example

User: "help me evaluate this acme library against rfc 8555"

1. Run `python3 scripts/fetch_rfc.py 8555` to get the RFC text
2. Ask: "This appears to be an ACME client library. Should I focus on any particular sections, or evaluate client requirements comprehensively?"
3. Extract MUST/SHOULD/MAY requirements from relevant sections
4. Trace each requirement through the codebase
5. Produce a narrative report with findings and recommendations
