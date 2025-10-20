#!/bin/sh
# 2025-10-20
# Daniel Deighton: dan-git@deightime.net
# Purpose: Use Open WebUI API model to summarize e-mail

### Required Homebrew Packages ###
# brew install w3m zenity

### Add Homebrew bin to PATH ###
PATH=$PATH:/opt/homebrew/bin

### Source Profile to read OPENAPI environment variables
source ~/.openwebui

### Set URL
URL="${OPENWEBUI_URL:-http://localhost:3000/api/chat/completions}"
### Set PROMPT
DEFAULT_OPENWEBUI_PROMPT="Summarize this email in concise, clear, bullet format with basic text output"
PROMPT="${OPENWEBUI_PROMPT:-$DEFAULT_OPENWEB_PROMPT}"

### Zenity Options
ZENITY_FONT=${FONT:-HelveticaNeue}
ZENITY_FONT_SIZE=${FONTSIZE:-12}

### Check Environment Variables for OPENWEBUI ###
if [ -z $OPENWEBUI_API_KEY ]; then
  osascript -e 'display alert "ENVIRONMENT UNSET" message "OPENWEBUI_API_KEY is NOT set!" as critical'
  exit
fi

if [ -z $OPENWEBUI_MODEL ]; then
  osascript -e 'display alert "ENVIRONMENT UNSET" message "OPENWEBUI_MODEL is NOT set!" as critical'
  exit
fi

### Get e-mail from MailMate
# Read full message from stdin
# Convert HTML to Text
TEXT=$(cat | w3m -dump -T text/html 2>/dev/null )

# Submit text to OpenAI API for summarization processing
(
curl -s $URL \
  -H "Authorization: Bearer $OPENWEBUI_API_KEY" \
  -H "Content-Type: application/json" \
  -d @- <<EOF
{
  "model": "$OPENWEBUI_MODEL",
  "messages": [
    {"role": "system", "content": "$PROMPT"},
    {"role": "user", "content": $(jq -Rs <<< "$TEXT")}
  ],
  "temperature": ${TEMP:-0.3}
}
EOF
# Parse the response and display it in a zenity window
) | jq -r '.choices[0].message.content' | zenity --text-info --title="OpenWebUI: Summarize E-Mail" --font="${ZENITY_FONT} ${ZENITY_FONT_SIZE}" $ZENITY_OPTIONS 

#    {"role": "system", "content": "Summarize this email in concise, clear, bullet format with basic text output not markdown "},