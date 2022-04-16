#!/usr/bin/env bash
#
# Script to manipulate chezmoi scriptState to forcibly record
# that a script was run without running the script.
#

set -e

if [ $# -ne 2 ]; then
  cat >&2 <<EOF
Usage: $0 RUN_SCRIPT SCRIPT_NAME

Add Chezmoi run script to scriptState.
  RUN_SCRIPT is the Chezmoi tmpl file.
  SCRIPT_NAME is the name of the file after executing template.

For example:

$0 run_once_linux.sh.tmp linux.sh

EOF
  exit 1
fi
RUN_SCRIPT=$1
SCRIPT_NAME=$2

if [ ! -f "$RUN_SCRIPT" ]; then
  echo "Cannot read file, $RUN_SCRIPT"
  exit 1
fi

SHA256=$(chezmoi execute-template < "$RUN_SCRIPT" | sha256sum | cut -d ' ' -f 1)
RUNAT=$(date +"%Y-%m-%dT%H:%M:%S%z")
VALUE="{
    \"name\": \"$SCRIPT_NAME\",
    \"runAt\": \"$RUNAT\"
}"
echo "$VALUE"

echo chezmoi state set --bucket=scriptState --key="$SHA256" --value=\'"$VALUE"\'
