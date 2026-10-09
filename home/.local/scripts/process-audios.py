#!/usr/bin/env python3
"""Transcribe audio files with parakeet and convert the resulting SRT to Markdown."""

from __future__ import annotations

import argparse
import re
import shutil
import subprocess
import sys
from pathlib import Path

AUDIO_EXTENSIONS = {
    ".aac",
    ".aiff",
    ".flac",
    ".m4a",
    ".mkv",
    ".mov",
    ".mp3",
    ".mp4",
    ".ogg",
    ".wav",
    ".webm",
}
TIMESTAMP = re.compile(
    r"^\d{2}:\d{2}:\d{2},\d+\s+-->\s+\d{2}:\d{2}:\d{2},\d+$"
)


def srt_to_markdown(srt_path: Path) -> Path:
    """Convert an SRT file to a simple dated Markdown document."""
    name = srt_path.stem
    date = name.split(" ", 1)[0]
    markdown_path = srt_path.with_suffix(".md")
    body = []

    for line in srt_path.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if stripped and not stripped.isdigit() and not TIMESTAMP.fullmatch(stripped):
            body.append(stripped)

    markdown_path.write_text(
        f"---\ndate: {date}\n---\n\n" + "\n".join(body), encoding="utf-8"
    )
    return markdown_path


def process_audio(audio_path: Path, parakeet_dir: Path, completed_dir: Path) -> str | None:
    """Process one audio file and return an error description on failure."""
    print(f"Processing: {audio_path.name}")
    result = subprocess.run(
        ["uv", "run", "parakeet", str(audio_path)],
        cwd=parakeet_dir,
        check=False,
    )
    if result.returncode != 0:
        print(f"  Failed: parakeet returned exit code {result.returncode}.")
        return "parakeet failed"

    srt_path = audio_path.with_suffix(".srt")
    if not srt_path.exists():
        print(f"  Failed: expected SRT not found at {srt_path}.")
        return "missing srt"

    try:
        markdown_path = srt_to_markdown(srt_path)
    except (OSError, UnicodeError) as error:
        print(f"  Failed: could not convert SRT to Markdown: {error}")
        return "md conversion failed"

    for path in (audio_path, srt_path, markdown_path):
        shutil.move(path, completed_dir / path.name)
    print(f"  Done: moved audio, SRT, and Markdown to {completed_dir}.")
    return None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input-dir", type=Path, default=Path("~/Downloads/audios"))
    parser.add_argument(
        "--parakeet-dir", type=Path, default=Path("~/code/danielfrg/parakeet-asr")
    )
    parser.add_argument(
        "--completed-dir", type=Path, default=Path("~/Downloads/audios/completed")
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    input_dir = args.input_dir.expanduser().resolve()
    parakeet_dir = args.parakeet_dir.expanduser().resolve()
    completed_dir = args.completed_dir.expanduser().resolve()

    if not input_dir.is_dir():
        print(f"Input directory does not exist: {input_dir}", file=sys.stderr)
        return 1
    if not parakeet_dir.is_dir():
        print(
            f"Parakeet directory does not exist: {parakeet_dir}. "
            "Pass --parakeet-dir with the correct path.",
            file=sys.stderr,
        )
        return 1

    completed_dir.mkdir(parents=True, exist_ok=True)
    audio_files = sorted(
        path
        for path in input_dir.iterdir()
        if path.is_file() and path.suffix.lower() in AUDIO_EXTENSIONS
    )
    if not audio_files:
        print(f"No audio files found in {input_dir}.")
        return 0

    failures: list[tuple[Path, str]] = []
    for audio_path in audio_files:
        reason = process_audio(audio_path, parakeet_dir, completed_dir)
        if reason:
            failures.append((audio_path, reason))

    print(f"\nCompleted: {len(audio_files) - len(failures)}")
    print(f"Failed:    {len(failures)}")
    if failures:
        print("\nFailures:")
        for path, reason in failures:
            print(f"  - {path.name}: {reason}")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
