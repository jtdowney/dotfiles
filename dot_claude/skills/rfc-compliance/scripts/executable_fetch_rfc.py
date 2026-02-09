#!/usr/bin/env python3
"""Fetch an RFC as plain text from rfc-editor.org."""

import sys
import urllib.request
import urllib.error


def fetch_rfc(rfc_number: str) -> str:
    """Fetch RFC text content by number."""
    # Normalize input: strip 'rfc' prefix if present
    num = rfc_number.lower().replace("rfc", "").strip()

    url = f"https://www.rfc-editor.org/rfc/rfc{num}.txt"

    try:
        with urllib.request.urlopen(url, timeout=30) as response:
            return response.read().decode("utf-8")
    except urllib.error.HTTPError as e:
        if e.code == 404:
            raise ValueError(f"RFC {num} not found") from e
        raise


def main():
    if len(sys.argv) != 2:
        print("Usage: fetch_rfc.py <rfc_number>", file=sys.stderr)
        print("Example: fetch_rfc.py 8555", file=sys.stderr)
        sys.exit(1)

    try:
        content = fetch_rfc(sys.argv[1])
        print(content)
    except ValueError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Failed to fetch RFC: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
