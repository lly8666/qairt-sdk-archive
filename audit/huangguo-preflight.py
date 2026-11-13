#!/usr/bin/env python3
"""Read-only upstream short-drama site preflight; no media files or credentials stored."""
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import urljoin, urlsplit

import requests
from bs4 import BeautifulSoup

source = Path(sys.argv[1])
report_path = Path(sys.argv[2])
rules = json.loads((source / "app/src/main/assets/site-default.json").read_text(encoding="utf-8"))
origin = rules["origin"].rstrip("/")
headers = {"User-Agent": rules["headers"]["User-Agent"], "Referer": origin + "/"}
session = requests.Session()
session.headers.update(headers)
checks = []
samples = {}
def record(name, status, **extra):
    row = {"name": name, "status": status, **extra}
    checks.append(row)
    print(json.dumps(row, ensure_ascii=False, sort_keys=True), flush=True)

def page(name, path, expect_cards=True):
    url = urljoin(origin + "/", path.lstrip("/"))
    try:
        response = session.get(url, timeout=(12, 20))
        code = response.status_code
        if code != 200:
            record(name, "http_error", http=code)
            return None
        soup = BeautifulSoup(response.text, "html.parser")
        cards = soup.select(rules["selectors"]["cards"])
        ids = [x.get("data-track-id", "") for x in cards if re.fullmatch(r"\d+", x.get("data-track-id", ""))]
        valid = len(response.content) >= 1000 and (not expect_cards or bool(ids))
        record(name, "ok" if valid else "structure_mismatch", http=code, card_count=len(ids), bytes=len(response.content))
        if ids:
            samples[name] = ids[0]
        return soup
    except Exception as exc:
        record(name, "network_error", error=str(exc)[:160])
        return None

page("home", "/")
page("recommend", "/recommend")
page("newest", "/newest")
for cat in rules["categories"]:
    page("category:" + cat, "/" + cat + "/")
page("search", "/search/?keyword=AI")
page("tags", "/sitemap/tag/1.xml", expect_cards=False)

# Each sample is a live title page and its playback metadata; no video download.
tested = set()
for name in ("home", "recommend", "category:ai-duanju", "category:ai-manju"):
    vid = samples.get(name)
    if not vid or vid in tested:
        continue
    tested.add(vid)
    soup = page("detail:" + name, "/video/" + vid + "/", expect_cards=False)
    if soup is None:
        continue
    node = soup.select_one(rules["selectors"]["content"])
    if node is None:
        record("metadata:" + name, "missing_video_initial_data")
        continue
    try:
        data = json.loads(node.string or node.get_text())
        source_url = str(data.get("videoSrc") or "")
        linked_eps = []
        for link in soup.select('a[href]'):
            m = re.match(r"/video/" + re.escape(vid) + r"/(?:ep-(\d+)/)?$", urlsplit(urljoin(origin, link.get("href", ""))).path)
            if m:
                linked_eps.append(int(m.group(1) or 1))
        record("metadata:" + name, "ok" if source_url.startswith("https://") and str(data.get("id")) == vid and linked_eps else "structure_mismatch",
               has_https_play_url=source_url.startswith("https://"),
               episode_count=len(set(linked_eps)),
               video_host=urlsplit(source_url).hostname or "")
        if not source_url.startswith("https://"):
            continue
        result = session.get(source_url, timeout=(12, 18), headers={"Range": "bytes=0-16383"}, stream=True)
        snippet = next(result.iter_content(chunk_size=16384), b"")
        result.close()
        is_m3u8 = b"#EXTM3U" in snippet
        record("play_manifest:" + name,
               "ok" if result.status_code in (200, 206) and (is_m3u8 or "video/" in result.headers.get("Content-Type", "")) else "unverified",
               http=result.status_code, m3u8=is_m3u8, content_type=result.headers.get("Content-Type", "")[:80])
        if is_m3u8:
            lines = snippet.decode("utf-8", "replace").splitlines()
            targets = [x.strip() for x in lines if x.strip() and not x.startswith("#")]
            if targets:
                media_url = urljoin(source_url, targets[0])
                if media_url.startswith("https://"):
                    head = session.get(media_url, timeout=(12, 18), headers={"Range": "bytes=0-127"}, stream=True)
                    preview = next(head.iter_content(chunk_size=128), b"")
                    head.close()
                    record("play_child:" + name, "ok" if head.status_code in (200, 206) and preview else "unverified",
                           http=head.status_code, bytes_probed=len(preview), host=urlsplit(media_url).hostname)
    except Exception as exc:
        record("play:" + name, "network_or_parse_error", error=str(exc)[:160])

report_path.parent.mkdir(parents=True, exist_ok=True)
summary = {"timestamp_utc": datetime.now(timezone.utc).isoformat(), "source": "colin4k/HuangguoAPP-for-Andriod",
           "origin": origin, "checks": checks,
           "caveats": ["Live probes are from a GitHub-hosted network and may differ by geography, cookies, or anti-bot rules.",
                       "A playback metadata/HLS probe is not a device video-decoding test.",
                       "Login and device UI are not exercised."]}
report_path.write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print("REPORT", report_path, "CHECKS", len(checks))
