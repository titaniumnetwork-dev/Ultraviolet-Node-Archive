#!/bin/bash
# Enter replit username below to enable always on.
username=""
# Set this to 0 to disable auto-restarting when fixes are attempted.
restart="1"


# Checks if a static folder exists and downloads the recommended submodule if it doesn't. It also assumes this is your first run, and does npm install.
if [ ! -d "static" ]; then
  npm install
  git submodule update --init --recursive
  npm install
  npm update
else
  # A very scuffed way of keeping the repo up to date. I am working on a better way, but I am not finished yet.
  if [[ "$(git status)" != *"Your branch is up-to-date with 'origin/main'"* ]]; then
    git pull
    git submodule foreach git pull
    npm install
    npm update
  fi
fi


# This adds your replit to https://ping.mat1.repl.co that ping your site periodically to keep it from going to sleep. "${PWD##*/}" gets the local directory, which will be the project name for most people. This was done so I could support hosting multiple instances of Ultraviolet with always-on enabled.
if [[ "$username" != "" ]] && [[ ! -f always ]]; then
  [[ "$(curl --silent -d "url=https://${PWD##*/}.$username.repl.co" --retry 5 -X POST https://ping.mat1.repl.co)" = *"302: Found"* ]] && touch always || echo 'Could not enable always on. Try again later.'
fi
[[ -f always ]] && echo 'Always on enabled.'


npm start || echo -e '\n\nAn error occured; attempting the most common fixes.'; sleep 3; npm install && npm update && git submodule update --init --recursive && [[ $restart = 1 ]] && echo 'Attempting to restart Ultraviolet.' && npm start || echo 'Finished attempting fixes. Please restart the script or run npm start.'
