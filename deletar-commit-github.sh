#!/bin/bash

# Deletar commit do github

### BAZER BACKUP DOS ARQUIVOS LOCALMENTE ANTES!!!!

git reset --hard "HEAD^"
git push origin -f
