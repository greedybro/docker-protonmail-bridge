#!/bin/bash

set -eufo pipefail

gpg --generate-key --batch /gpgparams
pass init pass-key

protonmail-bridge --cli <<EOF
login
$EMAIL
$PASSWORD
EOF

socat TCP-LISTEN:25,fork TCP:127.0.0.1:1025 &
socat TCP-LISTEN:143,fork TCP:127.0.0.1:1143 &

rm -f faketty
mkfifo faketty
cat faketty | protonmail-bridge --cli
