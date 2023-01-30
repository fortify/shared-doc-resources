#! /bin/bash

BASE_URL=https://raw.githubusercontent.com/fortify/shared-doc-resources/main/setup

RESOURCES=( 
  "doc-resources/repo-devinfo.md" 
  "doc-resources/repo-intro.md" 
  "doc-resources/repo-resources.md"  
  "doc-resources/repo-usage.md" 
  "doc-resources/template-values.md" 
  "doc-resources/update-repo-docs.sh" 
)

if [ -n "${EXTRA_RESOURCES}" ]; then
	RESOURCES+=(${EXTRA_RESOURCES[@]})
fi

for r in "${RESOURCES[@]}"; do
	if [ ! -f "$r" ]; then
		echo "INFO: Creating $r"
		mkdir -p "$(dirname $r)"
		url="${BASE_URL}/$r" 
		curl -fsL "$url" -o "$r" || echo "ERROR: Failed to download $url"
	fi
done

chmod a+x doc-resources/update-repo-docs.sh
