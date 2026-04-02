// TotalRecall WebSocket Server — C25
// Port 3001 — Live SHA256 anchor stream to all agents
const WebSocket = require('ws');
const { execSync } = require('child_process');
const crypto = require('crypto');
const fs = require('fs');

const DB = '/data/data/com.termux/files/home/constellation-25/memoria.db';
const PORT = 3001;
const LOG = '/data/data/com.termux/files/home/constellation-25/artie/logs/totalrecall_ws.log';

const wss = new WebSocket.Server({ port: PORT });
const clients = new Set();

function sha256(data) {
  return crypto.createHash('sha256').update(data).digest('hex');
}

function memLog(agent, event, detail) {
  try {
    execSync(`sqlite3 ${DB} "INSERT INTO logs (agent,event,detail) VALUES ('${agent}','${event}','${detail}');"`);
  } catch(e) {}
}

function broadcast(msg) {
  const str = JSON.stringify(msg);
  clients.forEach(c => { if (c.readyState === WebSocket.OPEN) c.send(str); });
}

function anchor(agent, event, detail) {
  const ts = new Date().toISOString();
  const hash = sha256(`${ts}|${agent}|${event}|${detail}`);
  const entry = { ts, agent, event, detail, hash };
  
  // Log to file
  fs.appendFileSync(LOG, `[${ts}] ${agent} | ${event} | ${hash}\n`);
  
  // Log to Memoria
  memLog(agent, event, `${detail}|hash=${hash}`);
  
  // Broadcast to all connected agents
  broadcast({ type: 'ANCHOR', ...entry });
  
  return hash;
}

wss.on('connection', (ws, req) => {
  clients.add(ws);
  const agentId = req.headers['x-agent-id'] || 'Unknown';
  
  console.log(`[TotalRecall] Agent connected: ${agentId}`);
  const hash = anchor('TotalRecall', 'AGENT_CONNECT', agentId);
  
  ws.send(JSON.stringify({
    type: 'WELCOME',
    agent: agentId,
    hash,
    ts: new Date().toISOString(),
    message: 'TotalRecall WebSocket Online · C25 Sovereign Stack'
  }));

  ws.on('message', (data) => {
    try {
      const msg = JSON.parse(data);
      const hash = anchor(msg.agent || agentId, msg.event || 'MESSAGE', msg.detail || data.toString());
      ws.send(JSON.stringify({ type: 'ACK', hash, original: msg }));
    } catch(e) {
      anchor('TotalRecall', 'RAW_MESSAGE', data.toString().slice(0, 100));
    }
  });

  ws.on('close', () => {
    clients.delete(ws);
    anchor('TotalRecall', 'AGENT_DISCONNECT', agentId);
  });
});

// Periodic heartbeat every 30s
setInterval(() => {
  const hash = anchor('TotalRecall', 'HEARTBEAT', `clients=${clients.size}`);
  broadcast({ type: 'HEARTBEAT', hash, ts: new Date().toISOString(), clients: clients.size });
}, 30000);

// Watch Memoria for new entries and broadcast
setInterval(() => {
  try {
    const rows = execSync(`sqlite3 ${DB} "SELECT id,agent,event,detail FROM logs ORDER BY id DESC LIMIT 5;"`).toString();
    if (rows.trim()) broadcast({ type: 'MEMORIA_UPDATE', rows: rows.trim().split('\n') });
  } catch(e) {}
}, 5000);

console.log(`TotalRecall WebSocket running on ws://0.0.0.0:${PORT}`);
memLog('TotalRecall', 'WS_START', `port=${PORT}`);
