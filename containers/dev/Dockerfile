FROM golang:1.25.14-bookworm@sha256:3b4a11519ad929d1e1d261a12cff056f0c85b735253d7d861346b9c6f8b36437 AS go
FROM node:26.10.0-bookworm-slim@sha256:3ffc19ea878019d9e9ae8971732ad4a03cda44f167107173174b60ed7c65bed3

LABEL org.opencontainers.image.source="https://github.com/danielfrg/dotfiles"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash bat build-essential ca-certificates cmake curl dnsutils fd-find ffmpeg \
    file git git-lfs gnupg iproute2 jq libffi-dev libssl-dev locales neovim \
    ninja-build openssh-client pkg-config postgresql-client procps python3 \
    python3-dev python3-venv ripgrep rsync sqlite3 sudo tar tmux unzip wget xz-utils zsh \
    chromium \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && ln -s /usr/bin/fdfind /usr/local/bin/fd \
    && ln -s /usr/bin/batcat /usr/local/bin/bat
COPY --from=go /usr/local/go /usr/local/go
ENV HOME=/home/danielfrg \
    SHELL=/bin/zsh \
    LANG=en_US.UTF-8 \
    PATH=/home/danielfrg/.local/bin:/home/danielfrg/.cargo/bin:/home/danielfrg/.bun/bin:/home/danielfrg/go/bin:/usr/local/go/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin \
    GOPATH=/home/danielfrg/go \
    PNPM_HOME=/home/danielfrg/.local/bin \
    UV_PYTHON_PREFERENCE=only-managed \
    PLAYWRIGHT_BROWSERS_PATH=/home/danielfrg/.cache/ms-playwright
COPY versions.env tools.lock.json install-tools.py /opt/dev/
RUN python3 /opt/dev/install-tools.py /opt/dev/tools.lock.json \
    && . /opt/dev/versions.env \
    && npm install --global --allow-scripts=@opencode/cli "pnpm@$PNPM_VERSION" "@opencode/cli@$OPENCODE_VERSION" \
    && UV_TOOL_DIR=/opt/dev/uv-tools UV_TOOL_BIN_DIR=/usr/local/bin UV_PYTHON_INSTALL_DIR=/opt/dev/python \
       uv tool install --python "$PYTHON_TOOL_VERSION" "ansible-core==$ANSIBLE_CORE_VERSION" \
    && UV_TOOL_DIR=/opt/dev/uv-tools UV_TOOL_BIN_DIR=/usr/local/bin UV_PYTHON_INSTALL_DIR=/opt/dev/python \
       uv tool install --python "$PYTHON_TOOL_VERSION" "pre-commit==$PRE_COMMIT_VERSION" \
    && rm -rf /root/.cache
# The Node base already owns UID 1000; rename that account instead of colliding.
RUN usermod --login danielfrg --home /home/danielfrg --shell /bin/zsh node \
    && groupmod --new-name danielfrg node \
    && printf 'danielfrg ALL=(ALL) NOPASSWD: ALL\n' > /etc/sudoers.d/danielfrg \
    && chmod 0440 /etc/sudoers.d/danielfrg \
    && install -d -o 1000 -g 1000 /home/danielfrg \
    && chown -R 1000:1000 /home/danielfrg
USER 1000:1000
WORKDIR /home/danielfrg
USER root
COPY profile/ /opt/dev/profile/
COPY bin/ /usr/local/bin/
RUN chmod 0755 /usr/local/bin/dev-entrypoint
USER 1000:1000
EXPOSE 4096
ENTRYPOINT ["dev-entrypoint"]
CMD ["serve"]
