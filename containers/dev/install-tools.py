"""Install only named binaries from checksum-pinned public release artifacts."""
import hashlib
import io
import json
from pathlib import Path
import subprocess
import sys
import tarfile
import zipfile


for artifact in json.loads(Path(sys.argv[1]).read_text()):
    data = subprocess.check_output(["curl", "--fail", "--silent", "--show-error", "--location", "--retry", "3", artifact["url"]])
    if hashlib.sha256(data).hexdigest() != artifact["sha256"]:
        raise SystemExit("Checksum mismatch: " + artifact["url"])
    for member, target in artifact["binaries"].items():
        if not member:
            binary = data
        elif artifact["url"].endswith(".zip"):
            with zipfile.ZipFile(io.BytesIO(data)) as archive:
                names = [n for n in archive.namelist() if Path(n).name == member and not n.endswith("/")]
                if len(names) != 1:
                    raise SystemExit("Ambiguous/missing binary: " + member)
                binary = archive.read(names[0])
        else:
            with tarfile.open(fileobj=io.BytesIO(data), mode="r:gz") as archive:
                entries = [e for e in archive.getmembers() if e.isfile() and Path(e.name).name == member]
                if len(entries) != 1:
                    raise SystemExit("Ambiguous/missing binary: " + member)
                binary = archive.extractfile(entries[0]).read()
        destination = Path("/usr/local/bin") / target
        destination.write_bytes(binary)
        destination.chmod(0o755)
        print("Installed " + target, flush=True)
