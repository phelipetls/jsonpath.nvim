#!/bin/bash
cd ~/.suckless
for folder in *; do sudo make clean install -C ~/suckless/$folder; done
