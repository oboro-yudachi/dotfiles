#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title dev-deploy
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "ビルド時に指定したタグ" }
# @raycast.argument2 { "type": "text", "placeholder": "AppEngineのバージョン名" }
# @raycast.argument3 { "type": "text", "placeholder": "デプロイ対象ブランチ" }

# Documentation:
# @raycast.author tgc282278
# @raycast.authorURL https://raycast.com/tgc282278

gcloud builds submit --no-source --region=asia-northeast1 \
  --config=deploy/jbc-id-stage/cloudbuild.development.deployer.yaml \
  --substitutions=_TAG=$1,_VERSION=$2,_TARGET_BRANCH=$3,_IMAGE=one_time_http,_WORKER_IMAGE=one_time_worker
