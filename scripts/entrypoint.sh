#!/bin/bash
# Entrypoint that sends startup/shutdown Telegram notifications

# Trap SIGTERM and SIGINT
trap 'echo "Shutting down..."; /opt/notify.sh "🔴 Clawd shutting down"; exit 0' SIGTERM SIGINT

# Send startup notification
/opt/notify.sh "🟢 Clawd is up!"

# Run the original command
exec "$@"
