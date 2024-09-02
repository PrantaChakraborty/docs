# Python scripts to monitor supervisor, if status is off then send message to slack and restart supervisor

```python
import requests
import subprocess

# for backend channel
SLACK_WEBHOOK_URL = ""


def notify_slack(message, title="Supervisor status"):
    data = {
        "blocks": [
            {
                "type": "header",
                "text": {
                    "type": "plain_text",
                    "text": title
                }
            },
            {
                "type": "section",
                "text": {
                    "type": "plain_text",
                    "text": message,
                }
            }
        ]
    }
    requests.post(SLACK_WEBHOOK_URL, json=data)


def check_supervisor_status():
    try:
        # Check if Supervisor is running
        subprocess.check_output(["sudo", "supervisorctl", "status"],
                                stderr=subprocess.STDOUT)

    except subprocess.CalledProcessError as e:
        notify_slack(
            f"Supervisor or one of its scripts has stopped working: {e.output.decode('utf-8')}")
        subprocess.run(["sudo", "supervisorctl", "restart", "all"])
        notify_slack(title="Supervisor Restart", message="Supervisor restarted")
        return False
    return True

if __name__ == '__main__':
    check_supervisor_status()


```
