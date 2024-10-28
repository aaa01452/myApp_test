#!/bin/bash

# 使用 curl 呼叫 API 並將回傳值儲存在變數中
response=$(curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${DOCKERHUB_CREDENTIALS}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/users/aaa01452/packages/container/myapp_test/versions?per_page=1")

# 使用 jq 解析 tags 的第一筆數值
tag_value=$(echo "$response" | jq -r '.[0].metadata.container.tags[0]')

# 將數值輸出
echo "$tag_value"
