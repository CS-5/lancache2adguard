#!/bin/bash

source create_list.sh &&
python3 -m http.server 8080 &
crond -f