#!/bin/bash
set -eo pipefail

SHARED_GITHUB_REF="${SHARED_GITHUB_REF:-main}"
SHARED_DOC_RESOURCES_REF="${SHARED_DOC_RESOURCES_REF:-$(curl -fsSL "https://raw.githubusercontent.com/fortify/shared-github/${SHARED_GITHUB_REF}/pins/shared-doc-resources.sha")}"
export SHARED_DOC_RESOURCES_REF

source <(curl -fsSL "https://raw.githubusercontent.com/fortify/shared-doc-resources/${SHARED_DOC_RESOURCES_REF}/scripts/update-doc-resources.sh")
