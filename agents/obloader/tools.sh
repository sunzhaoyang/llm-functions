#!/usr/bin/env bash
set -e

# @env LLM_OUTPUT=/dev/stdout The output path

# @cmd Run shell command
# @option --command! The command to execute
execute_command() {
    local command="$argc_command"
    
    # Extract the first part of the command (executable file path)
    local executable=$(echo "$command" | awk '{print $1}')
    
    # Check if the executable contains obloader
    # if [[ ! "$executable" =~ obloader$ ]]; then
    #     echo "Error: Command must use obloader executable (e.g.: obloader, ./bin/obloader, /path/to/obloader)" >> "$LLM_OUTPUT"
    # fi
    
    echo "Executing command: $command" >> "$LLM_OUTPUT"
    eval "$command" >> "$LLM_OUTPUT"
}

# @cmd Check Java environment, requires version 1.8.0_3xx
check_java_environment() {
    # Check if java command exists
    if ! command -v java &> /dev/null; then
        echo "Error: Java environment not found" >> "$LLM_OUTPUT"
    fi
    
    # Get Java version information
    local java_version=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')
    echo "Current Java version: $java_version" >> "$LLM_OUTPUT"
    
    # Check if version is 1.8.0_3xx
    if [[ "$java_version" =~ ^1\.8\.0_3[0-9]{2}$ ]]; then
        echo "✓ Java environment check passed: Version $java_version meets requirements (1.8.0_3xx)" >> "$LLM_OUTPUT"
    else
        echo "✗ Java environment check failed: Version $java_version does not meet requirements, need 1.8.0_3xx version" >> "$LLM_OUTPUT"
    fi
}

# See more details at https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
