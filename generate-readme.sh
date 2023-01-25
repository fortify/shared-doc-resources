#!/bin/bash

expandVarMultiLine() {
    # Variable to keep track of whether lines should be written to the output (1) or not (0)
	outputLines=0
	# Read the value file line by line, clearing IFS to keep leading whitespace
	while IFS= read valueLine; do
	  # If line starts with '# <var>`, start outputting subsequent lines by setting outputLines=1
	  if [[ ${valueLine} = "# ${varMultiLine}"* ]]; then
	    outputLines=1
	  # If line starts with '# ', we have reached another variable so stop outputting lines 
	  elif [[ ${valueLine} = "# "* ]]; then
	    outputLines=0
	  # Output current line if outputLines is equal to 1
	  elif [[ ${outputLines} = 1 ]]; then
	    echo "${valueLine}"
	  fi
	done < README.values.md
}

expandVar() {
    # Read variable value by taking all text between '# <var>' and the next occurance of '# '
    val=$(sed -n "/^# ${var}\s*/,/^# /{//!p;}" README.values.md)
    # Use bash variable expansion to replace the variable reference with the variable value
    echo "${templateLine/\{${var}\}/$val}"
}

# Read the template file line by line, clearing IFS to keep leading whitespace
while IFS= read templateLine; do  
    # var wil match a single variable {project_*} anywhere on the current line  
    var=$(echo $templateLine | sed -n 's:.*{\(project_[a-z_]*\)}.*:\1:p')
    # varMultiLine will match a variable that's on a line by itself, allowing for expanding multiple lines
    varMultiLine=$(echo $templateLine | sed -n 's:^{\(project_[a-z_]*\)}\s*$:\1:p')
    if [ -n "$varMultiLine" ]; then
      # Expand (potential multi-line) variable
      expandVarMultiLine
    elif [ -n "$var" ]; then
      # Expand in-place variable
      expandVar
    else
      # Line doesn't contain variable, so output as-is
      echo "$templateLine"
    fi 
done < README.template.md
