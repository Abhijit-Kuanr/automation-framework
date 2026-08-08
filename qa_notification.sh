
#!/bin/bash
# Email credentials
SMTP_SERVER="smtp.gmail.com"
SMTP_PORT=587
EMAIL_FROM="your-email-id@gmail.com"
EMAIL_PASSWORD="your-16-character-app-password"
EMAIL_TO="recipient-mail-id@gmail.com"

# Subject and body
EMAIL_SUBJECT="🚨 QA Testing Commencing – Developers, Prepare Yourselves! 😈"
EMAIL_BODY=$(cat <<EOF
<html>
  <body style="color: black;">
    <p>Hi Team,</p>

    <p>The deployment to the QA server is complete. 🚀</p>

    <p>Infra team, please make sure the server is alive and well.</p>

    <p>Developers, QA testing is now commencing. Please keep your bug-fixing helmets ready! 🪖🐛😂</p>

    <p>Let the testing begin! May the automation be green. 💚</p>

    <p>Best regards,<br>
    QA Automation Team</p>
  </body>
</html>
EOF
)

# Send the email using swaks with Content-Type for HTML
swaks --to "$EMAIL_TO" \
      --from "$EMAIL_FROM" \
      --server "$SMTP_SERVER" \
      --port "$SMTP_PORT" \
      --auth LOGIN \
      --auth-user "$EMAIL_FROM" \
      --auth-password "$EMAIL_PASSWORD" \
      --tls \
      --timeout 60 \
      --header "Subject: $EMAIL_SUBJECT" \
      --header "Content-Type: text/html; charset=utf-8" \
      --body "$EMAIL_BODY" \
      --silent