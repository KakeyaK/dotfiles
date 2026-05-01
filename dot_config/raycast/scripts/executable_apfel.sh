#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Apfel
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🍎
# @raycast.argument1 { "type": "text", "placeholder": "What is a lion?" }
# @raycast.packageName AI

# Documentation:
# @raycast.description Call apfel CLI with streaming
# @raycast.author Kim
# @raycast.authorURL kakeya.kim

apfel --stream "$1"

