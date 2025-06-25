#!/bin/sh
# 2025-06-25
# Jim Bates: jim@batesiv.net
# Purpose: Use OpenAI API model to summarize e-mail

### Required Homebrew Packages ###
# brew install w3m zenity

### Add Homebrew bin to PATH ###
PATH=$PATH:/opt/homebrew/bin

### Source Profile to read OPENAPI environment variables
source ~/.openai

### Check Environment Variables for OPENAI ###
if [ -z $OPENAI_API_KEY ]; then
  osascript -e 'display alert "ENVIRONMENT UNSET" message "OPENAI_API_KEY is NOT set!" as critical'
  exit
fi

if [ -z $OPENAI_MODEL ]; then
  osascript -e 'display alert "ENVIRONMENT UNSET" message "OPENAI_MODEL is NOT set!" as critical'
  exit
fi

### Get e-mail from MailMate
# Read full message from stdin
# Convert HTML to Text
TEXT=$(cat | w3m -dump -T text/html 2>/dev/null )

# Submit text to OpenAI API for summarization processing
(
curl -s https://api.openai.com/v1/chat/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d @- <<EOF
{
  "model": "$OPENAI_MODEL",
  "messages": [
    {"role": "system", "content": "Summarize this email in concise, clear, bullet format with basic text output not markdown "},
    {"role": "user", "content": $(jq -Rs <<< "$TEXT")}
  ],
  "temperature": 0.3
}
EOF
# Parse the response and display it in a zenity window
) | jq -r '.choices[0].message.content' | zenity --text-info --title="OpenAI: Summarize E-Mail"
