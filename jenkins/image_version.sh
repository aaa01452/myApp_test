#!/bin/bash



response=$(curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${DOCKERHUB_CREDENTIALS}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/users/aaa01452/packages/container/myapp_test/versions?per_page=1")

# 使用 grep 和 sed 解析 JSON 並取得第一個 tag
tag_value=$(echo "$response" | sed -n 's/.*"tags":\s*\[\s*"\([^"]*\)".*/\1/p')

echo "$tag_value"
