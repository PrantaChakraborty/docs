# Python scripts to monitor mosquito mqtt with cronjob and send message to Slack via [Slack Webhook API](https://api.slack.com/messaging/webhooks)
## Create a directory for the Python file and create mosquittor_monitor.py
```bash
mkdir cron_tasks && cd cron_taks
touch mosquittor_monitor.log  # for log 
nano mosquittor_monitor.py
```
### Copy the code into mosquittor_monitor.py

```python
import requests
import subprocess

# for backend channel
SLACK_WEBHOOK_URL = ""

def notify_slack(message, title="Mqtt status"):
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

def restart_mosquitto():
    subprocess.run(['systemctl', 'restart', 'mosquitto.service'])

def check_mosquitto_status():
    try:
        # Run the 'systemctl status mosquitto.service' command
        result = subprocess.run(['systemctl', 'status', 'mosquitto.service'],
                                stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE,
                                text=True)

        # Check if the command was successful
        if result.returncode == 0:
            pass
            # notify_slack(message="Mosquitto is up and running.")
        else:
            notify_slack(message=result.stdout)
            restart_mosquitto()
    except Exception as e:
        notify_slack(message="Exception occurred")
        restart_mosquitto()

if __name__ == '__main__':
    check_mosquitto_status()
```

## Run crontab by using this command
### Open the crontab editor
```bash
crontab -e
```
### Write the following line to run the scripts every 10 minutes
```bash
*/10 * * * * /usr/bin/python3 /home/ubuntu/cron_tasks/mosquittor_monitor.py >> /home/ubuntu/cron_tasks/mosquittor_monitor.log
```

### Reload the corn
```bash
sudo service cron reload
```
