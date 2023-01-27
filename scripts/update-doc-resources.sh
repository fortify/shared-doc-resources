#!/bin/bash

DOC_RESOURCES_DIR=${SCRIPT_DIR}
DOC_TARGET_DIR=${DOC_RESOURCES_DIR}/..
VALUES_FILE=${DOC_RESOURCES_DIR}/template-values.md
# Define template locations:
# - Local templates dir in doc-resources parent directory,
#   to allow for local testing of this script in the shared-doc-resources repo
# - Local templates dir in doc-resources directory, 
#   allowing repo's to override shared templates (not recommended) or to add templates once we add support for specifying extra templates
# - Remote templates dir in shared-doc-resources repo,
#   which will be the default behavior for most repo's     
TEMPLATE_LOCATIONS=("file://${DOC_RESOURCES_DIR}/../templates" "file://${DOC_RESOURCES_DIR}/templates" "https://raw.githubusercontent.com/fortify/shared-doc-resources/main/templates")
# Define include locations:
# - Local includes dir in doc-resources parent directory 
# - Local doc-resources dir
# - Remote includes dir in shared-doc-resources repo
INCLUDE_LOCATIONS=("file://${DOC_RESOURCES_DIR}/../includes" "file://${DOC_RESOURCES_DIR}" "https://raw.githubusercontent.com/fortify/shared-doc-resources/main/includes")

declare -A TEMPLATE_TO_TARGET_MAP=( 
  ["CODE_OF_CONDUCT.template.md"]="CODE_OF_CONDUCT.md" 
  ["CONTRIBUTING.template.md"]="CONTRIBUTING.md"
  ["LICENSE.MIT.template.txt"]="LICENSE.txt"
  ["README.template.md"]="README.md"
)

declare -A BUILT_IN_VARS=( 
  ["year"]="$(date +"%Y")" 
)

ERRORS=0

logError() {
	echo "ERROR: $@" >&2
	ERRORS=1
}

logInfo() {
	echo "INFO: $@" >&2
}

expandVar() {
	local var="$1"
	local templateLine="$2"
	local val=${BUILT_IN_VARS[$var]}
	if [ -z "$val" ]; then
      # Read variable value by taking all text between '# <var>' and the next occurance of '# '
      IFS= val=$(sed -n "/^# ${var}\s*/,/^# /{//!p;}" ${VALUES_FILE})
    fi
    if [ -z "$val" ]; then
      logError "Value for variable '${var}' not found in ${VALUES_FILE}"
    else 
      # Use bash variable expansion to replace the variable reference with the variable value
      echo "${templateLine/\{\{var:${var}\}\}/$val}"
    fi
}

expandTemplateLine() {
	local templateLine="$1"
	local var=$(echo $templateLine | sed -n 's/.*{{var:\([a-z_]*\)}}.*/\1/p')
    local include=$(echo $templateLine | sed -n 's/.*{{include:\([^}]*\)}}.*/\1/p')
    if [ -n "$var" ]; then
      expandVar "$var" "$templateLine"
    elif [ -n "$include" ]; then
      expandIncludeResource "$include"
    else
      # Line doesn't contain variable or include, so output as-is
      echo "$templateLine"
    fi 
}

expandLines() {
	# Read the template file line by line, clearing IFS to keep leading whitespace
	while IFS= read -r templateLine; do  
	    expandTemplateLine "$templateLine"
	done
}

getResource() {
    # Get contents and add newline at end to allow for proper reading with 'read'
	curl -sfL "$1" && echo;
}

getFirstResource() {
	local file="$1"; shift;
	local locations=("$@")
	for location in "${locations[@]}"; do
      if getResource "$location/$file"; then
        logInfo "Processing $location/$file"
        return 0;
      fi
    done
    logError "File $file not found in any of the following locations: ${locations[@]}"
    return 1;
}

getTemplateResource() {
	getFirstResource "$1" "${TEMPLATE_LOCATIONS[@]}"
}

expandTemplateResource() {
	local output
	if ! IFS= output=$(getTemplateResource "$1"); then
    	ERRORS=1
    else
    	expandLines <<< "${output}"
    fi
}

getIncludeResource() {
	getFirstResource "$1" "${INCLUDE_LOCATIONS[@]}"
}

expandIncludeResource() {
	local output
	if ! IFS= output=$(getIncludeResource "$1"); then
    	ERRORS=1
    else
    	expandLines <<< "${output}"
    fi
}

expandTemplates() {
	for TEMPLATE_FILE in ${!TEMPLATE_TO_TARGET_MAP[@]}; do
		if [ "$dryRun" = "1" ]; then
			expandTemplateResource "$TEMPLATE_FILE" > /dev/null
		else
			local target="${DOC_TARGET_DIR}/${TEMPLATE_TO_TARGET_MAP[$TEMPLATE_FILE]}"
			expandTemplateResource "$TEMPLATE_FILE" > $target
			logInfo "Generated $target"	
		fi
	done	
}

checkErrors() {
	if [ "$ERRORS" = "1" ]; then
	    echo "Errors encountered; document resources will not be updated" >&2
		return 1
	fi
}

logInfo "=== Performing dry-run to check for errors ==="
dryRun=1 expandTemplates
checkErrors && logInfo "=== Generating documentation resources ===" && expandTemplates && logInfo "=== Done ==="



