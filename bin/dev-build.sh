#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title dev-build
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "イメージに付与するタグ" }
# @raycast.argument2 { "type": "text", "placeholder": "デプロイ対象ブランチ" }

# Documentation:
# @raycast.author tgc282278
# @raycast.authorURL https://raycast.com/tgc282278

gcloud builds submit --no-source --region=asia-northeast1 \
  --config=deploy/jbc-id-stage/cloudbuild.builder.yaml \
  --substitutions=_TAG=$1,_TARGET_BRANCH=$2
