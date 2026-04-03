FROM ghcr.io/openclaw/openclaw:latest

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  jq \
  ripgrep \
  libasound2-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# AWS CLI
RUN curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/aws.zip \
    && cd /tmp && unzip -q aws.zip \
    && ./aws/install --install-dir /usr/local/aws-cli --bin-dir /usr/local/bin \
    && rm -rf /tmp/aws*

RUN wget https://go.dev/dl/go1.26.1.linux-amd64.tar.gz && rm -rf /usr/local/go && tar -C /usr/local -xzf go1.26.1.linux-amd64.tar.gz

# beads
RUN curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash

## Switch to user land
USER node

ENV PATH="$PATH:/usr/local/go/bin:/home/node/go/bin"

# go
RUN go install github.com/steipete/sag/cmd/sag@latest

