# Mail Sender – QA Deployment Notification

## Overview

`qa_notification.sh` is a shell script used by the QA automation framework to send an HTML email notification to the Infrastructure and Development teams after deployment to the QA server.

The notification informs the team that:

- Deployment to the QA server is complete.
- The QA server should be available and stable.
- QA automation/testing is about to commence.
- Developers should be ready to review and fix defects found during testing.

---

## 1. Script Location

Recommended Bitbucket repository structure:

```text
automation-framework/
│
├── automation/
│   ├── scripts/
│
├── qa_notification.sh
├── qa_execution.sh
├── .gitignore
└── README.md
```

The mail script is located at:

```text
automation-framework/qa_notification.sh
```

---

## 2. Prerequisites

The script requires:

1. Linux/Unix shell
2. `swaks`
3. A Gmail account
4. Gmail 2-Step Verification
5. A Gmail App Password

### Install `swaks`

On Debian/Kali/Ubuntu:

```bash
sudo apt update
sudo apt install -y swaks
```

Verify the installation:

```bash
swaks --version
```

---

## 3. Gmail SMTP Configuration

The script uses Gmail SMTP:

```bash
SMTP_SERVER="smtp.gmail.com"
SMTP_PORT=587
```

Port `587` is used with TLS/STARTTLS.

The sender and recipient are configured using:

```bash
EMAIL_FROM="your-email-id@gmail.com"
EMAIL_PASSWORD="your-16-character-app-password"
EMAIL_TO="recipient-mail-id@gmail.com"
```

> **Important:** `EMAIL_PASSWORD` should be a Gmail **App Password**, not your normal Gmail account password.

---

## 4. Create Gmail App Password

### Step 1 – Enable 2-Step Verification

Sign in to the Gmail/Google account that will send the email.

Open:

https://myaccount.google.com/security

Enable **2-Step Verification**.

### Step 2 – Create an App Password

After enabling 2-Step Verification, open:

https://myaccount.google.com/apppasswords

Create a new App Password.

For example, use:

```text
Automation Framework
```

Google will generate a 16-character password similar to:

```text
abcd efgh ijkl mnop
```

Use the generated password in the script without spaces:

```bash
EMAIL_PASSWORD="abcdefghijklmnop"
```

---

## 5. Email Configuration

The current script uses:

```bash
EMAIL_SUBJECT="🚨 QA Testing Commencing – Developers, Prepare Yourselves! 😈"
```

The email body is HTML:

```bash
EMAIL_BODY=$(cat <<EOF

<p>The deployment to the QA server is complete. 🚀</p>

<p>Infra team, please make sure the server is alive and well.</p>

<p>Developers, QA testing is now commencing. Please keep your bug-fixing helmets ready! 🪖🐛😂</p>

<p>Let the testing begin! May the automation be green. 💚</p>

<p>Best regards,<br>
QA Automation Team</p>

EOF
)
```

Because the email is HTML, the script sends:

```text
Content-Type: text/html; charset=utf-8
```

This allows HTML tags such as `<p>` and `<br>` to be rendered correctly in the email client.

---

## 6. How the Email Is Sent

The script uses `swaks` to communicate with Gmail's SMTP server.

The main command is:

```bash
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
```

### Explanation

| Option | Purpose |
|---|---|
| `--to` | Email recipient |
| `--from` | Sender email address |
| `--server` | Gmail SMTP server |
| `--port` | SMTP port |
| `--auth LOGIN` | SMTP authentication method |
| `--auth-user` | Gmail account used for authentication |
| `--auth-password` | Gmail App Password |
| `--tls` | Enables TLS encryption |
| `--timeout 60` | SMTP operation timeout |
| `--header "Subject:..."` | Sets email subject |
| `--header "Content-Type:..."` | Tells the client the body is HTML |
| `--body` | Email content |
| `--silent` | Reduces command output |

---

## 7. Complete `qa_notification.sh`

Example:

```bash
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
<p>The deployment to the QA server is complete. 🚀</p>

<p>Infra team, please make sure the server is alive and well.</p>

<p>Developers, QA testing is now commencing. Please keep your bug-fixing helmets ready! 🪖🐛😂</p>

<p>Let the testing begin! May the automation be green. 💚</p>

<p>Best regards,<br>
QA Automation Team</p>
EOF
)

# Send the email using swaks with HTML Content-Type

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
```

---

## 8. Run the Script

Give the script execute permission:

```bash
chmod +x qa_notification.sh
```

Run it:

```bash
./qa_notification.sh
```

Or:

```bash
bash qa_notification.sh
```

---

## 9. Security – Do Not Commit the Password

**Do not commit the Gmail App Password to Bitbucket.**

Avoid committing this:

```bash
EMAIL_PASSWORD="abcdefghijklmnop"
```

For local execution, an environment variable can be used instead:

```bash
export EMAIL_PASSWORD="your-16-character-app-password"
```

Then modify the script:

```bash
EMAIL_PASSWORD="${EMAIL_PASSWORD}"
```

For Bitbucket Pipelines, the recommended approach is to store the password as a **secured repository/workspace variable** and inject it during pipeline execution.

Example:

```bash
EMAIL_PASSWORD="${EMAIL_PASSWORD}"
```

Do not put the real password directly into:

```text
qa_notification.sh
qa_execution.sh
README.md
```

Also add secret/config files to `.gitignore` where appropriate.

Example:

```gitignore
.env
*.secret
credentials.sh
```

### If a password has already been committed

If a real App Password has been pushed to Bitbucket:

1. Revoke/delete the App Password in Google.
2. Generate a new App Password.
3. Remove the exposed credential from the repository/history as appropriate.
4. Store the new credential as a secured CI/CD variable.

---

## 10. QA Deployment Notification Flow

The script can be used as part of the QA deployment process:

```text
Developer Code
      |
      v
Bitbucket Repository
      |
      v
CI/CD Pipeline
      |
      v
QA Server Deployment
      |
      v
Deployment Completed
      |
      v
qa_notification.sh
      |
      v
Gmail SMTP
      |
      v
Infrastructure + Development Team
      |
      v
QA Automation Testing Starts
```

---

## 11. Example Notification

### Subject

```text
🚨 QA Testing Commencing – Developers, Prepare Yourselves! 😈
```

### Message

> The deployment to the QA server is complete. 🚀
>
> Infra team, please make sure the server is alive and well.
>
> Developers, QA testing is now commencing. Please keep your bug-fixing helmets ready! 🪖🐛😂
>
> Let the testing begin! May the automation be green. 💚

---

## 12. Recommended Bitbucket Structure

```text
automation-framework/
│
├── automation/
│   ├── scripts/
│   │
│   └── ...
│
├── qa_notification.sh
├── qa_execution.sh
├── .gitignore
└── README.md
```

If `qa_notification.sh` is specifically intended to be a reusable utility, it can also be placed under:

```text
automation/scripts/qa_notification.sh
```

---

## 13. Troubleshooting

### `swaks: command not found`

Install it:

```bash
sudo apt update
sudo apt install -y swaks
```

### Gmail authentication failure

Check:

- 2-Step Verification is enabled.
- The App Password belongs to the correct Gmail account.
- The App Password is entered correctly.
- You are not using the normal Gmail password.
- The sender address matches the authenticated Gmail account.

### SMTP connection failure

Check:

- SMTP server is `smtp.gmail.com`.
- SMTP port is `587`.
- TLS is enabled.
- The machine/network allows outbound SMTP connections.

---

## 14. Quick Reference

| Configuration | Value |
|---|---|
| SMTP Server | `smtp.gmail.com` |
| SMTP Port | `587` |
| TLS | Enabled |
| Authentication | `LOGIN` |
| Authentication Password | Gmail App Password |
| Email Format | HTML |
| SMTP Tool | `swaks` |
| Script | `qa_notification.sh` |
| Purpose | QA deployment/testing notification |

---

## Security Reminder

Never commit real Gmail credentials, App Passwords, API tokens, or other secrets to Bitbucket.

Use **Bitbucket secured variables** for CI/CD credentials.
