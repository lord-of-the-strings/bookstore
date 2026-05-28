#!/bin/bash
set -a
source <(grep -v '^#' ../.env | sed 's/ *= */=/g')
set +a
./gradlew bootRun
