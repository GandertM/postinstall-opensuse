#!/usr/bin/env bash
set -euo pipefail # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a system snapshot
create_snapshot "pre"
