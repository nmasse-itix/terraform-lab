#!/bin/bash

set -Eeuo pipefail

echo -n > users.yaml
echo "username,password" > users.csv

read -p 'MASTER KEY: ' -s MASTER_KEY

for i in $(seq 1 80); do
  user="$(printf 'user%02d' $i)"
  password="$(echo -n "$MASTER_KEY:$user" | openssl dgst -sha256 -binary | openssl base64 | cut -c 1-8)"
  echo "$user,$password" >> users.csv
  hash="$(echo -n "$password" | mkpasswd -m sha512crypt -s)"
  cat >> users.yaml <<EOF
- name: $user
  gecos: Utilisateur $i
  shell: /bin/bash
  primary_group: lab
  lock_passwd: false
  passwd: $hash
EOF
done

cat user-data.yaml users.yaml | gzip -c > user-data.yaml.gz
