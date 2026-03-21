FROM node:20-slim
RUN apt-get update && apt-get install -y python3 python3-pip git curl bash && rm -rf /var/lib/apt/lists/*
RUN pip3 install jupyter requests flask --break-system-packages 2>/dev/null || true
WORKDIR /c25
COPY package.json ./
COPY server.js ./
COPY index.html ./
COPY docker-start.sh ./
COPY C25_Empire.ipynb ./
RUN npm install
RUN mkdir -p agent_logs
EXPOSE 3100 8888
CMD ["bash", "docker-start.sh"]
