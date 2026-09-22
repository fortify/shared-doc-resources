#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
if [[ -d "${SCRIPT_DIR}/doc-resources" ]]; then
	BASE_URL="file://${SCRIPT_DIR}"
else
	BASE_URL=https://raw.githubusercontent.com/fortify/shared-doc-resources/main/setup
fi

RESOURCES=( 
  "doc-resources/repo-devinfo.md" 
  "doc-resources/repo-intro.md" 
  "doc-resources/repo-resources.md"  
  "doc-resources/repo-usage.md" 
  "doc-resources/template-values.md" 
  "doc-resources/update-repo-docs.sh" 
)

if declare -p EXTRA_RESOURCES >/dev/null 2>&1; then
	RESOURCES+=("${EXTRA_RESOURCES[@]}")
fi

for resource in "${RESOURCES[@]}"; do
	if [ ! -f "${resource}" ]; then
		echo "INFO: Creating ${resource}"
		mkdir -p "$(dirname "${resource}")"
		url="${BASE_URL}/${resource}"
		curl -fsSL "${url}" -o "${resource}"
	fi
done

chmod a+x doc-resources/update-repo-docs.sh
