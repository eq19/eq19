#!/bin/bash

# Max retries
max_retries=10
# Interval between checks (60s / 10 = 6s each)
interval=6

for ((i=1; i<=max_retries; i++)); do
    echo "Check $i of $max_retries..."

    # Replace this with your condition
    if some_command_or_condition; then
        echo "Condition fulfilled ✅"
        exit 0
    fi

    # If not fulfilled and not the last try, wait
    if [ $i -lt $max_retries ]; then
        sleep $interval
    fi
done

# If condition never fulfilled after retries, run fallback command
echo "Condition not fulfilled after $max_retries checks ❌"
your_command_here
