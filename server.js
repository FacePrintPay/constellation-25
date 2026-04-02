const express = require('express');
const path = require('path');
const { execSync } = require('child_process');
const fs = require('fs');

const app = express();
const PORT = 3000;
const HOME = '/data/data/com.termux/files/home/constellation-25';

app.use(express.json());
app.use(express.static(path.join(HOME, 'artie/deployments')));

// ARTie deploy route
app.use('/dep', express.static(path.join(HOME, 'artie/deployments')));
app.get('/dep/:slug', (req, res) => {
  const f = path.join(HOME, 'artie/deployments', req.params.slug, 'index.html');
  if (fs.existsSync(f)) res.sendFile(f);
  else res.status(404).json({ error: 'Not deployed yet', slug: req.params.slug });
});

// Memoria query route
app.get('/memoria', (req, res) => {
  try {
    const rows = execSync(`sqlite3 ${HOME}/memoria.db "SELECT * FROM logs ORDER BY id DESC LIMIT 50;"`).toString();
    res.json({ ok: true, rows: rows.trim().split('\n') });
  } catch(e) { res.json({ ok: false, error: e.message }); }
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'C25 Online', port: PORT, agents: 25, memoria: 'active' });
});

// List deployments
app.get('/artie/list', (req, res) => {
  const dir = path.join(HOME, 'artie/deployments');
  if (!fs.existsSync(dir)) return res.json({ deployments: [] });
  const deps = fs.readdirSync(dir).filter(f => fs.statSync(path.join(dir,f)).isDirectory());
  res.json({ deployments: deps, count: deps.length });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`C25 Server running on http://0.0.0.0:${PORT}`);
  console.log(`Memoria: ${HOME}/memoria.db`);
  console.log(`ARTie deployments: ${HOME}/artie/deployments`);
  execSync(`sqlite3 ${HOME}/memoria.db "INSERT INTO logs (agent,event,detail) VALUES ('Earth','SERVER_START','port=${PORT}');"`)
});

// Inventory route
const fs_inv = require('fs');
app.get('/inventory/:ts', (req, res) => {
  const f = `/data/data/com.termux/files/home/C25-MASTER/inventory/inventory_${req.params.ts}.html`;
  if (fs_inv.existsSync(f)) res.sendFile(f);
  else res.json({ error: 'Run c25_inventory first', cmd: 'bash ~/constellation-25/c25_inventory.sh' });
});
app.get('/inventory', (req, res) => {
  const dir = '/data/data/com.termux/files/home/C25-MASTER/inventory';
  if (!fs_inv.existsSync(dir)) return res.json({ reports: [] });
  const files = fs_inv.readdirSync(dir).filter(f => f.endsWith('.html'));
  res.json({ reports: files, latest: files[files.length-1] });
});
