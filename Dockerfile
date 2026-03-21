# C25 SOVEREIGN AI EMPIRE — DOCKER IMAGE
# Cygel White | FacePrintPay Inc | Kre8tive Konceptz Ltd
FROM node:20-slim

# Install Python and tools
RUN apt-get update && apt-get install -y \
    python3 python3-pip git curl bash \
    jupyter-notebook \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /c25

# Copy C25 core
COPY pathos/ ./pathos/
COPY constellation-25/ ./constellation-25/
COPY agent_logs/ ./agent_logs/

# Install dependencies
RUN cd pathos && npm install 2>/dev/null || true
RUN pip3 install jupyter requests flask 2>/dev/null || true

# Create agent log dirs
RUN mkdir -p agent_logs

# Copy MCP manifest
COPY C25_MCP_MANIFEST.json ./

# Expose ports
# Pathos orchestrator
EXPOSE 3100
# All 17 agents
EXPOSE 8001 8002 8003 8004 8005 8006 8007 8008 8009
EXPOSE 8010 8011 8012 8013 8014 8015 8016 8017
# Jupyter
EXPOSE 8888

# Start script
COPY docker-start.sh ./
RUN chmod +x docker-start.sh

CMD ["./docker-start.sh"]
