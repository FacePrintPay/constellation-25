FROM node:20-slim
RUN apt-get update && apt-get install -y python3 python3-pip git curl bash jupyter-notebook && rm -rf /var/lib/apt/lists/*
WORKDIR /c25
COPY package.json server.js index.html docker-start.sh C25_Empire.ipynb ./
RUN npm install && mkdir -p agent_logs
EXPOSE 3100 8888
CMD ["bash", "docker-start.sh"]
