#!/bin/bash
for folder in ~/suckless/*; do sudo make clean install -C "$folder"; done
