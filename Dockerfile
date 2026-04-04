FROM ghcr.io/openclaw/openclaw:latest

USER root

# GitHub CLI - install from binary release
RUN curl -sL https://github.com/cli/cli/releases/latest/download/gh_*_linux_amd64.tar.gz | tar xz -C /tmp \
    && mv /tmp/gh_*_linux_amd64/bin/gh /usr/local/bin/gh \
    && rm -rf /tmp/gh_*

RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  jq \
  ripgrep \
  libasound2-dev \
  libicu-dev \
  libzstd-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# AWS CLI
RUN curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/aws.zip \
    && cd /tmp && unzip -q aws.zip \
    && ./aws/install --install-dir /usr/local/aws-cli --bin-dir /usr/local/bin \
    && rm -rf /tmp/aws*

RUN wget https://go.dev/dl/go1.26.1.linux-amd64.tar.gz && rm -rf /usr/local/go && tar -C /usr/local -xzf go1.26.1.linux-amd64.tar.gz

## Switch to user land
USER node

ENV GOPATH="/home/node/go"
ENV PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# beads
RUN go install github.com/steveyegge/beads/cmd/bd@latest

# sag
RUN go install github.com/steipete/sag/cmd/sag@latest

# Notification scripts
COPY scripts/notify.sh /opt/notify.sh
COPY scripts/entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/notify.sh /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["node", "dist/index.js", "gateway", "--bind", "lan", "--port", "18789"]
