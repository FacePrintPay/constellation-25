#!/bin/bash
cd /c25/pathos && node server.js &
sleep 2
jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' &
echo "PATHOS: http://localhost:3100"
echo "JUPYTER: http://localhost:8888"
wait
