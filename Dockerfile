FROM python:3.8-slim-buster
LABEL maintainer="Team QLUSTOR <team@qlustor.com>" \
    description="Original by Aiden Gilmartin. Speedtest to InfluxDB data bridge"

ENV DEBIAN_FRONTEND=noninteractive

RUN true &&\
    \
    # Install dependencies
    apt-get update && \
    apt-get -q -y install --no-install-recommends apt-utils gnupg1 apt-transport-https dirmngr curl && \
    \
    # Install Python packages
    pip3 install pythonping influxdb-client && \
    \
    # Clean up
    apt-get -q -y autoremove && apt-get -q -y clean && \
    rm -rf /var/lib/apt/lists/*

# Install speedtest-cli
RUN curl -L "https://packagecloud.io/ookla/speedtest-cli/gpgkey" 2> /dev/null | apt-key add - && \
    echo "deb https://packagecloud.io/ookla/speedtest-cli/debian/ buster main" | tee  /etc/apt/sources.list.d/ookla_speedtest-cli.list && \
    apt-get update && apt-get -q -y install speedtest && \
    apt-get -q -y autoremove && apt-get -q -y clean && \
    rm -rf /var/lib/apt/lists/*

# Final setup & execution
ADD . /app
WORKDIR /app
ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]
CMD ["main.py"]
