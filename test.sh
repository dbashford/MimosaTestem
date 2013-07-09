#!/bin/bash
if [ "$1" == ci ]; then
  testem ci --file "/Users/dbashford/mygithub/MimosaTestem/.mimosa/testemRequire/testem.json"
else
  testem --file "/Users/dbashford/mygithub/MimosaTestem/.mimosa/testemRequire/testem.json"
fi