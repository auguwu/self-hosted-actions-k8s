#!/bin/bash

echo "[::actions] Now running runner..."

REG_TOKEN=$(curl -sX POST -H "Authorization: token $ACCESS_TOKEN" https://api.github.com/orgs/$ORGANIZATION/actions/runners/registration-token | jq .token --raw-output)
cd /build/runner
./config.sh --url https://github.com/$ORGANIZATION --token ${REG_TOKEN}

echo "[::actions] Configuration has been setup!"

cleanup() {
  echo "[::actions] Removing runner..."
  ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
