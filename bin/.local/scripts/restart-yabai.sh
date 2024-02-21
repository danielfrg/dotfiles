#!/bin/bash

yabai --stop-service
yabai --start-service

skhd --reload
