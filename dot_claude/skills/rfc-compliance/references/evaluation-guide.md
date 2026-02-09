# Compliance Evaluation Guide

## Postel's Law

> "Be conservative in what you send, be liberal in what you accept."

When evaluating compliance:

- **Sending/producing**: Strict adherence to spec. Output must be valid per the standard.
- **Receiving/parsing**: Graceful handling of variations. Accept reasonable deviations without failing.

## Evaluation Workflow

### 1. Scope Definition
- Identify which RFC sections apply to the implementation
- Note sections that are out of scope (e.g., server-side requirements for a client library)
- If user requests focus on specific sections, prioritize those

### 2. Requirement Extraction
- Scan RFC for MUST/SHOULD/MAY keywords (per RFC 2119)
- Group requirements by section
- Note requirements that span multiple sections

### 3. Code Analysis
For each requirement:
- Locate relevant code paths
- Trace data flow for sending vs receiving
- Check error handling for edge cases

### 4. Compliance Assessment
Rate each requirement:
- **✅ Compliant** - Requirement fully satisfied
- **⚠️ Partial** - Requirement partially met or with caveats
- **❌ Non-compliant** - Requirement violated or unimplemented
- **➖ N/A** - Requirement doesn't apply to this implementation
- **❓ Unknown** - Cannot determine from code inspection

## Evidence Linking

Always cite both sources:
- RFC: `RFC 8555 §7.1.2` or `RFC 8555, Section 7.1.2`
- Code: `src/account.gleam:45` or function/module names

## Report Structure

1. **Executive Summary** - Overall compliance status, key findings
2. **Scope** - What was evaluated, what was excluded
3. **Critical Findings** - MUST/MUST NOT violations (if any)
4. **Recommendations** - SHOULD/SHOULD NOT deviations worth addressing
5. **Optional Features** - MAY items and their implementation status
6. **Detailed Findings** - Section-by-section analysis with evidence

## Common Patterns

### Sending (Conservative)
- Validate all output before transmission
- Use canonical formats (e.g., base64url, not base64)
- Include all required fields, even if seemingly redundant

### Receiving (Liberal)
- Accept case variations where spec is ambiguous
- Handle missing optional fields gracefully
- Provide clear errors for truly invalid input
