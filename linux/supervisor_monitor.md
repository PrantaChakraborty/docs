# Python scripts to monitor supervisor with cronjob and send messages to Slack via [Slack Webhook API](https://api.slack.com/messaging/webhooks)
## Create a directory for the Python file and create supervisor_monitor.py
```bash
mkdir cron_tasks && cd cron_taks
touch supervisor_monitor.log  # for log 
nano supervisor_monitor.py
```
### Copy the code into supervisor_monitor.py

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

## Run crontab by using this command
### Open the crontab editor
```bash
crontab -e
```
### Write the following line to run the scripts every 10 minutes
```bash
*/10 * * * * /usr/bin/python3 /home/ubuntu/cron_tasks/supervisor_monitor.py >> /home/ubuntu/cron_tasks/supervisor_monitor.log
```

### Reload the corn
```bash
sudo service cron reload
```
