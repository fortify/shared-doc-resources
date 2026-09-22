#!/bin/bash
set -euo pipefail

WORKFLOW_FILE=".github/workflows/update-repo-docs.yml"
SHARED_GITHUB_REPO_URL="${SHARED_GITHUB_REPO_URL:-https://github.com/fortify/shared-github.git}"
SHARED_GITHUB_REF="${SHARED_GITHUB_REF:-refs/heads/main}"

EXTRA_RESOURCES=("${WORKFLOW_FILE}")
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
if [[ -f "${SCRIPT_DIR}/setup.sh" ]]; then
	source "${SCRIPT_DIR}/setup.sh"
else
	source <(curl -fsSL https://raw.githubusercontent.com/fortify/shared-doc-resources/main/setup/setup.sh)
fi

resolveSharedGithubSha() {
	git ls-remote "${SHARED_GITHUB_REPO_URL}" "${SHARED_GITHUB_REF}" | awk 'NR == 1 { print $1 }'
}

sharedGithubSha="$(resolveSharedGithubSha)"
if [[ ! "${sharedGithubSha}" =~ ^[0-9a-f]{40}$ ]]; then
	echo "ERROR: Failed to resolve ${SHARED_GITHUB_REF} from ${SHARED_GITHUB_REPO_URL}" >&2
	exit 1
fi

if grep -q "<shared-github-sha>" "${WORKFLOW_FILE}"; then
	sed -i.bak "s/<shared-github-sha>/${sharedGithubSha}/g" "${WORKFLOW_FILE}"
	rm -f "${WORKFLOW_FILE}.bak"
	echo "INFO: Pinned ${WORKFLOW_FILE} to fortify/shared-github@${sharedGithubSha}"
else
	echo "INFO: ${WORKFLOW_FILE} already has a shared-github pin"
fi

