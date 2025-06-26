# OpenAI API E-Mail Summary
Jim Bates <jim@batesiv.net>
2025-06-25

## Purpose
This MailMate bundle allows you to use your personal OpenAPI API KEY to summarize the body of an e-mail.

## Requirements
### Install Homebrew
https://brew.sh

### Homebrew
You need to install 2 packages
- w3m
- zenity
  
`brew install w3m zenity`

### OpenAI - Go buy some credits
https://auth.openai.com/log-in

### Environment Variables
- You need to create a `.openai` configuration file in your home directory
- Add 2 variables
  - `export OPENAI_API_KEY="sk-proj-<YOUR KEY HERE>m4A"`
  - `export OPENAI_MODEL="gpt-4o"`
