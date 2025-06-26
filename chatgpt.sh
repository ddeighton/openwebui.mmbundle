#!/bin/bash

API_KEY="${OPENAI_API_KEY}"
MODEL="${OPENAI_MODEL}"
HISTORY_FILE="/tmp/chatgpt_history.json"

# Initialize history
if [ ! -f "$HISTORY_FILE" ]; then
  echo '[{"role":"system","content":"You are a helpful assistant."}]' > "$HISTORY_FILE"
fi

while true; do
  echo -n "You: "
  read -r USER_INPUT

  [ -z "$USER_INPUT" ] && continue

  TMP_HISTORY=$(mktemp)
  jq --arg content "$USER_INPUT" '. + [{"role":"user","content":$content}]' "$HISTORY_FILE" > "$TMP_HISTORY"
  mv "$TMP_HISTORY" "$HISTORY_FILE"

  RESPONSE=$(curl -s https://api.openai.com/v1/chat/completions \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    -d @- <<EOF
{
  "model": "$MODEL",
  "messages": $(cat "$HISTORY_FILE"),
  "temperature": 0.5
}
EOF
)

  REPLY=$(echo "$RESPONSE" | jq -r '.choices[0].message.content')

  # Append assistant response to history
  TMP_HISTORY=$(mktemp)
  jq --arg content "$REPLY" '. + [{"role":"assistant","content":$content}]' "$HISTORY_FILE" > "$TMP_HISTORY"
  mv "$TMP_HISTORY" "$HISTORY_FILE"

  echo -e "\nChatGPT: $REPLY\n"
done
