#!/bin/sh
set -e
mkdir ~/.n8n 2>/dev/null || true
echo '{ "encryptionKey": "'$ENCRYPTION_KEY'" }' > ~/.n8n/config

cd /n8n

export DOCKER_BUILD=true

echo installing dependencies
#rm -rf node_modules
rm -rf **/node_modules **/dist **/.turbo
echo | pnpm clean || echo "skipping clean"
# doing the echo to make the command skip asking questions...
echo | pnpm install

echo building n8n
pnpm build

# Follows the set-up steps from Notion.
echo preparing test data
cp assets/* /tmp
cp node_modules/pdf-parse/test/data/04-valid.pdf /tmp
cp node_modules/pdf-parse/test/data/05-versions-space.pdf /tmp

packages/cli/bin/n8n import:workflow --separate --input=/test-workflows/workflows
packages/cli/bin/n8n import:credentials --input=/test-workflows/credentials.json

# Check the command argument
case "$1" in
  "snapshot")
    echo "Creating snapshots"
    mkdir -p /output/snapshots
    if [ -z "$2" ]; then
      echo "No IDs specified. Using default ID 252."
      SNAPSHOT_IDS_ARG=""
    else
      SNAPSHOT_IDS_ARG="--ids=$2"
    fi
    packages/cli/bin/n8n executeBatch --shallow --retries=0 --snapshot=/output/snapshots --debug $SNAPSHOT_IDS_ARGz
    ;;
  "dev")
    echo "Starting development server"
    pnpm run dev
    ;;
  "test"|*)
    echo "Running tests"
    packages/cli/bin/n8n executeBatch --concurrency=16 --shortOutput --debug --compare=../test-workflows/snapshots --output=/output/test-results.json --shallow --skipList=../test-workflows/skipList.txt
    ;;
esac
