#!/usr/bin/env python3
"""Fetch data from a public REST API, parse it, and save structured JSON output.

Uses only the Python standard library so it runs without external dependencies.
"""

from __future__ import annotations

import argparse
import json
import sys
import urllib.error
import urllib.request
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

DEFAULT_API_URL = "https://jsonplaceholder.typicode.com/users"
DEFAULT_OUTPUT_PATH = Path(__file__).resolve().parent / "response.json"
DEFAULT_TIMEOUT_SECONDS = 15


def fetch_json(url: str, timeout: int = DEFAULT_TIMEOUT_SECONDS) -> tuple[int, Any]:
    """Send an HTTP GET request to a REST API endpoint and decode the JSON body."""
    headers = {
        "Accept": "application/json",
        "User-Agent": "cs-fundamental-api-fetcher/1.0",
    }
    request = urllib.request.Request(url, headers=headers, method="GET")

    with urllib.request.urlopen(request, timeout=timeout) as response:
        status_code = response.status
        charset = response.headers.get_content_charset() or "utf-8"
        raw_body = response.read().decode(charset)
        parsed = json.loads(raw_body)
        return status_code, parsed


def normalize_record(item: Any) -> Any:
    """Extract clean summary fields for known user records, preserving other schemas."""
    if not isinstance(item, dict):
        return item

    # Simplify JSONPlaceholder / GitHub-style user payloads while preserving details.
    if {"id", "name", "username", "email"}.issubset(item.keys()):
        company = item.get("company")
        address = item.get("address")
        return {
            "id": item.get("id"),
            "name": item.get("name"),
            "username": item.get("username"),
            "email": item.get("email"),
            "city": address.get("city") if isinstance(address, dict) else None,
            "company": company.get("name") if isinstance(company, dict) else company,
            "website": item.get("website"),
        }
    return item


def build_output_payload(url: str, status_code: int, raw_data: Any, limit: int | None) -> dict[str, Any]:
    """Build a structured JSON document wrapping parsed records and request metadata."""
    if isinstance(raw_data, list):
        selected = raw_data[:limit] if (limit is not None and limit > 0) else raw_data
        parsed_data: Any = [normalize_record(entry) for entry in selected]
        record_count = len(parsed_data)
    else:
        parsed_data = normalize_record(raw_data)
        record_count = 1

    return {
        "metadata": {
            "source_url": url,
            "status_code": status_code,
            "fetched_at_utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
            "record_count": record_count,
        },
        "data": parsed_data,
    }


def save_json(payload: dict[str, Any], output_path: Path) -> None:
    """Write formatted JSON to disk, creating parent directories if needed."""
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", encoding="utf-8", newline="\n") as handle:
        json.dump(payload, handle, indent=2, ensure_ascii=False)
        handle.write("\n")


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    """Parse command-line options for the API fetcher."""
    parser = argparse.ArgumentParser(
        description="Fetch a public REST API endpoint, parse JSON, and save to response.json."
    )
    parser.add_argument(
        "--url",
        default=DEFAULT_API_URL,
        help=f"Public REST API URL to query (default: {DEFAULT_API_URL})",
    )
    parser.add_argument(
        "--limit",
        type=int,
        default=5,
        help="Maximum number of list items to keep in response.json (default: 5; 0 for all).",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=DEFAULT_OUTPUT_PATH,
        help=f"Output JSON file path (default: {DEFAULT_OUTPUT_PATH})",
    )
    parser.add_argument(
        "--timeout",
        type=int,
        default=DEFAULT_TIMEOUT_SECONDS,
        help=f"HTTP request timeout in seconds (default: {DEFAULT_TIMEOUT_SECONDS})",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    """Run the API fetch, parse, and save workflow."""
    args = parse_args(argv)

    print(f"Requesting: {args.url}")
    try:
        status_code, raw_data = fetch_json(args.url, timeout=args.timeout)
    except urllib.error.HTTPError as exc:
        print(f"HTTP error {exc.code}: {exc.reason}", file=sys.stderr)
        return 1
    except urllib.error.URLError as exc:
        print(f"Network error: {exc.reason}", file=sys.stderr)
        return 1
    except json.JSONDecodeError as exc:
        print(f"Failed to parse JSON response: {exc}", file=sys.stderr)
        return 1

    limit = args.limit if args.limit > 0 else None
    payload = build_output_payload(args.url, status_code, raw_data, limit=limit)
    save_json(payload, args.output)

    print(f"HTTP Status : {status_code}")
    print(f"Records     : {payload['metadata']['record_count']}")
    print(f"Saved JSON  : {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
