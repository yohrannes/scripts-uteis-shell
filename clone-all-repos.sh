#!/bin/bash
# download a maximum of 1000 @vilmibm's repos and organize them under `./vilmibm/`:
read -p "Digite o nome do usuario desejado:" user
gh repo list $user --limit 1000 | while read -r repo _; do
  gh repo clone "$repo" "$repo"
done
