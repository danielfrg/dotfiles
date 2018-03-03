#!/bin/bash

set -e
set -x

kill $(ps aux | grep onepassword | grep -v grep | awk '{print $2}')
rm -rf ~/Library/Application\ Support/1Password\ 4
