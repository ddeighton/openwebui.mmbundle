# Open WebUI API E-Mail Summary
Daniel Deighton <dan-git@deightime.net>
2025-10-20

## Purpose
This MailMate bundle allows you to use your personal Open Web UI API KEY to summarize the body of an e-mail.

## Requirements
### Install Homebrew
https://brew.sh

### Homebrew
You need to install 2 packages
- w3m
- zenity
  
`brew install w3m zenity`

### Open WebUI - Find your API key
Under Settings | Account | API Key

### Environment Variables
- You need to create a `.openwebui` configuration file in your home directory
- Add 2 variables
  - `export OPENWEBUI_API_KEY="<YOUR KEY HERE>"`
  - `export OPENWEBUI_MODEL="llama3.2:latest"`
  - `export OPENWEBUI_URL=<Your URL>`  # Defaults to "http://localhost:3000/api/chat/completions"
- The following variables are optional:
  - `export OPENWEBUI_PROMPT=<Prompt to send to Open Webui>`
  - `export FONT=<Font that you prefer>` # Defaults to "HelveticaNeue"
  - `export FONTSIZE=<Preferred Font size>` # Defaults to 12
  - `export TEMP=<Preferred Temperature>` # Defaults to 0.3
  - `export ZENITY_OPTIONS=<Other options for zenity>` # For example, ="--width=800 --height=600" will set the size of the output window.
 
##
References:
- https://github.com/mailmate
- https://github.com/mailmate/mailmate_manual/wiki/Bundles
- https://manual.mailmate-app.com/preferences.html#bundles_preferences
