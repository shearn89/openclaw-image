#!/bin/bash
# Send a Telegram message
# Usage: notify.sh "message"
TOKEN="8380971051:AAGGX6PfViUu3LZqnBUQEXag6f5DTlRv4xQ"
CHAT_ID="8614905358"
MSG="$1"
curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
  -d chat_id="$CHAT_ID" \
  -d text="$MSG" > /dev/null 2>&1
