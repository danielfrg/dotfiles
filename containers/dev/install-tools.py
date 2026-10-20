"""Download development tools from their versioned public releases."""
import io
from pathlib import Path
import subprocess
import tarfile
import zipfile


tools = [
    ("https://github.com/astral-sh/uv/releases/download/0.13.2/uv-x86_64-unknown-linux-gnu.tar.gz", {"uv": "uv", "uvx": "uvx"}),
    ("https://github.com/oven-sh/bun/releases/download/bun-v1.4.3/bun-linux-x64.zip", {"bun": "bun"}),
    ("https://github.com/casey/just/releases/download/1.59.0/just-1.59.0-x86_64-unknown-linux-musl.tar.gz", {"just": "just"}),
    ("https://github.com/starship/starship/releases/download/v1.27.0/starship-x86_64-unknown-linux-musl.tar.gz", {"starship": "starship"}),
    ("https://github.com/argoproj/argo-cd/releases/download/v3.5.5/argocd-linux-amd64", {"": "argocd"}),
    ("https://github.com/mikefarah/yq/releases/download/v4.54.1/yq_linux_amd64", {"": "yq"}),
    ("https://github.com/google/yamlfmt/releases/download/v0.21.0/yamlfmt_0.21.0_Linux_x86_64.tar.gz", {"yamlfmt": "yamlfmt"}),
    ("https://github.com/cli/cli/releases/download/v2.102.0/gh_2.102.0_linux_amd64.tar.gz", {"gh": "gh"}),
    ("https://github.com/junegunn/fzf/releases/download/v0.74.5/fzf-0.74.5-linux_amd64.tar.gz", {"fzf": "fzf"}),
    ("https://github.com/ajeetdsouza/zoxide/releases/download/v0.10.0/zoxide-0.10.0-x86_64-unknown-linux-musl.tar.gz", {"zoxide": "zoxide"}),
    ("https://github.com/eza-community/eza/releases/download/v0.23.5/eza_x86_64-unknown-linux-gnu.tar.gz", {"eza": "eza"}),
    ("https://dl.k8s.io/release/v1.34.3/bin/linux/amd64/kubectl", {"": "kubectl"}),
    ("https://get.helm.sh/helm-v3.19.0-linux-amd64.tar.gz", {"helm": "helm"}),
    ("https://releases.hashicorp.com/terraform/1.16.6/terraform_1.16.6_linux_amd64.zip", {"terraform": "terraform"}),
]

for url, binaries in tools:
    data = subprocess.check_output(["curl", "--fail", "--silent", "--show-error", "--location", "--retry", "3", url])
    for member, target in binaries.items():
        if not member:
            binary = data
        elif url.endswith(".zip"):
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
