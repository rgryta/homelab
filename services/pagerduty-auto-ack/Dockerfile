FROM python:3.12-slim

RUN pip install --no-cache-dir pagerduty-auto-ack==1.0.0 \
    && useradd --create-home --shell /usr/sbin/nologin pdack

USER pdack

ENV ACK_INTERVAL=600

ENTRYPOINT ["/bin/sh", "-c", "exec pagerduty-auto-ack --pagerduty-api-key \"$PAGERDUTY_API_KEY\" --interval \"$ACK_INTERVAL\""]
