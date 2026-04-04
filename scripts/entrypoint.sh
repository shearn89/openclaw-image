#!/bin/bash
# Entrypoint that sends startup/shutdown Telegram notifications

set -e

# Ensure AWS CLI can find creds from the persistent workspace secrets
# without baking secrets into the public image.
AWS_SECRETS_DIR="/home/node/.openclaw/workspace/.secrets"
if [ -d "$AWS_SECRETS_DIR" ]; then
  rm -rf /home/node/.aws
  ln -s "$AWS_SECRETS_DIR" /home/node/.aws
  chmod 700 /home/node/.aws || true
  chmod 600 /home/node/.aws/credentials /home/node/.aws/config 2>/dev/null || true
fi

# Trap SIGTERM and SIGINT
trap echo "Shutting down..."; /opt/notify.sh "🔴 Clawd shutting down"; exit 0 SIGTERM SIGINT

# Send startup notification
/opt/notify.sh "🟢 Clawd is up!"

# Run the original command (keep this shell as PID 1 so traps fire)
"$@" &
wait $!
