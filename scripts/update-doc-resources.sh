#!/bin/bash

#SHARED_TEMPLATES_DIR=https://github.com/fortify/repo-resources/raw/main/templates
SHARED_TEMPLATES_DIR=file://${SCRIPT_DIR}/../templates
DOC_RESOURCES_DIR=${SCRIPT_DIR}
DOC_TARGET_DIR=${DOC_RESOURCES_DIR}/..
VALUES_FILE=${DOC_RESOURCES_DIR}/template-values.md

declare -A TEMPLATE_TO_TARGET_MAP=( 
  ["CODE_OF_CONDUCT.template.md"]="CODE_OF_CONDUCT.md" 
  ["CONTRIBUTING.template.md"]="CONTRIBUTING.md"
  ["LICENSE.MIT.template.txt"]="LICENSE.txt"
  ["README.template.md"]="README.md"
)

declare -A BUILT_IN_VARS=( 
  ["year"]="$(date +"%Y")" 
)

ERRORS=()

addError() {
  ERRORS[${#ERRORS[@]}]="$@"
}

expandVar() {
	val=${BUILT_IN_VARS[$var]}
	if [ -z "$val" ]; then
      # Read variable value by taking all text between '# <var>' and the next occurance of '# '
      IFS= val=$(sed -n "/^# ${var}\s*/,/^# /{//!p;}" ${VALUES_FILE})
    fi
    if [ -z "$val" ]; then
      addError "ERROR: Value for variable '${var}' not found in ${VALUES_FILE}"
    else 
      # Use bash variable expansion to replace the variable reference with the variable value
      echo "${templateLine/\{\{var:${var}\}\}/$val}"
    fi
}

expandInclude() {
    local resolvedInclude=${DOC_RESOURCES_DIR}/${include}
	if [[ ! -f "$resolvedInclude" ]]; then
	  addError "ERROR: Include file $resolvedInclude (referenced as $include in ${TEMPLATE_FILE}) not found"
	else
	  cat "${resolvedInclude}"
	fi
}

expandTemplateLine() {
	var=$(echo $templateLine | sed -n 's/.*{{var:\([a-z_]*\)}}.*/\1/p')
    include=$(echo $templateLine | sed -n 's/.*{{include:\([^}]*\)}}.*/\1/p')
    if [ -n "$var" ]; then
      expandVar
    elif [ -n "$include" ]; then
      expandInclude
    else
      # Line doesn't contain variable or include, so output as-is
      echo "$templateLine"
    fi 
}

expandVars() {
	# Read the template file line by line, clearing IFS to keep leading whitespace
	while IFS= read -r templateLine; do  
	    expandTemplateLine
	done
	# If last line in template didn't end with a newline, we need to call expandTemplateLine one last time 
	if [ -n "$templateLine" ]; then
		expandTemplateLine
	fi
}

for TEMPLATE_FILE in ${!TEMPLATE_TO_TARGET_MAP[@]}; do
    # TODO Generate error if template file cannot be found or is empty
	expandVars < <(curl -s "${SHARED_TEMPLATES_DIR}/$TEMPLATE_FILE"; echo;) > /dev/null
done

if [ -n "$ERRORS" ]; then
    echo "Errors encountered; document resources will not be updated" >&2
	for err in "${ERRORS[@]}"; do
      echo "$err"
	done
	exit 1
fi

for TEMPLATE_FILE in ${!TEMPLATE_TO_TARGET_MAP[@]}; do
	expandVars < <(curl -s "${SHARED_TEMPLATES_DIR}/$TEMPLATE_FILE") > "${DOC_TARGET_DIR}/${TEMPLATE_TO_TARGET_MAP[$TEMPLATE_FILE]}"
done
