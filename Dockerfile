FROM ghcr.io/openclaw/openclaw:latest

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  jq \
  libasound2-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget https://go.dev/dl/go1.26.1.linux-amd64.tar.gz && rm -rf /usr/local/go && tar -C /usr/local -xzf go1.26.1.linux-amd64.tar.gz

USER node
ENV PATH="$PATH:/usr/local/go/bin:/home/node/go/bin"
RUN go install github.com/steipete/sag/cmd/sag@latest
