#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "# QA Automation Started"
echo ""
echo "Deployment completed successfully."
echo "Sending QA notification..."

bash "$SCRIPT_DIR/qa_notification.sh"

if [ $? -eq 0 ]; then
    echo "Email notification sent successfully."
else
    echo "Failed to send email notification."
    exit 1
fi