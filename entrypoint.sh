#!/bin/bash
set -e

# Use environment variable or default to empty string
JUPYTER_TOKEN=${JUPYTER_TOKEN:-''}

exec jupyter lab --ip 0.0.0.0 --allow-root --NotebookApp.token="${JUPYTER_TOKEN}"