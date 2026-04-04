FROM ghcr.io/openclaw/openclaw:latest

USER root

# GitHub CLI repo setup
RUN curl -sS https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  gh \
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

# Notification scripts
COPY scripts/notify.sh /opt/notify.sh
COPY scripts/entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/notify.sh /opt/entrypoint.sh

## Switch to user land
USER node

ENV GOPATH="/home/node/go"
ENV PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# beads
RUN go install github.com/steveyegge/beads/cmd/bd@latest

# sag
RUN go install github.com/steipete/sag/cmd/sag@latest

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["node", "dist/index.js", "gateway", "--bind", "lan", "--port", "18789"]

