#!/bin/bash

set -ex

GH_USERNAME=danielfrg
# GH_TOKEN=<TOKEN>
# GH_ORGANIZATION=algorithmia

# bash ./githubapi-get.sh "${GH_USERNAME}:${GH_TOKEN}" "/user/repos" > github-repos.txt
# bash ./githubapi-get.sh "${GH_USERNAME}:${GH_TOKEN}" "/orgs/${GH_ORGANIZATION}/repos" > company-repos.txt

# cat github-repos.txt | jq -s '.[] | map({ arg: .html_url, uid: .id, title: .name, subtitle: .description }) | { items: . }' > github-repos.json
cat github-repos.txt | jq -n '[inputs] | add | map({ arg: .html_url, uid: .id, title: .name, subtitle: .description }) | { items: . }' > github-repos.json
# cat github-repos.txt | jq -s '.' > github-repos.json
# cat github-repos.txt | jq -n '[inputs] | add' > github-repos.json
