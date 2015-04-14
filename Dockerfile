FROM alpine

# Add base depenendencies
RUN apk -U add openjdk7-jre-base git make bash
# Get latest Docker binary
RUN curl -sSL -o /usr/local/bin/docker https://get.docker.com/builds/Linux/x86_64/docker-latest && \
    chmod +x /usr/local/bin/docker
# Agent boostrapper
COPY agent-bootstrapper.jar /usr/share/go-agent/agent-bootstrapper.jar
# Startup script
COPY start /start
# Add go user & work dir
RUN addgroup -g 75 -S go && \
    adduser -u 75 -S -G go -h /var/go -s /bin/bash -D -g 'Go CD' go && \
    mkdir -p /var/lib/go-agent && \
    chown -R go:go /var/lib/go-agent
ENV AGENT_STARTUP_ARGS "-Dcruise.console.publish.interval=10 -Xms128m -Xmx256m"
WORKDIR /var/lib/go-agent
USER go
CMD ["/start"]
