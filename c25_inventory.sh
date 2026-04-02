#!/data/data/com.termux/files/usr/bin/bash
# C25 Full Ecosystem Inventory
H="/data/data/com.termux/files/home"
DB="$H/constellation-25/memoria.db"
OUT="$H/C25-MASTER/inventory"
TS=$(date +"%Y%m%d_%H%M%S")
mkdir -p "$OUT"

echo -e "\033[0;36m[Inventory]\033[0m Scanning C25 ecosystem..."

# Count everything
TOTAL_FILES=$(find "$H" -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/llama.cpp/*" -type f 2>/dev/null | wc -l)
TOTAL_SH=$(find "$H" -name "*.sh" -not -path "*/node_modules/*" 2>/dev/null | wc -l)
TOTAL_PY=$(find "$H" -name "*.py" -not -path "*/node_modules/*" 2>/dev/null | wc -l)
TOTAL_JS=$(find "$H" -name "*.js" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | wc -l)
TOTAL_DB=$(find "$H" -name "*.db" 2>/dev/null | wc -l)
TOTAL_TAR=$(find "$H" -name "*.tar.gz" -o -name "*.zip" 2>/dev/null | wc -l)
TOTAL_AGENTS=$(find "$H" -name "*agent*" -not -path "*/node_modules/*" 2>/dev/null | wc -l)

# List all backups/archives
ARCHIVES=$(find "$H" -name "*.tar.gz" -o -name "*.zip" -o -name "*.tar" 2>/dev/null | grep -v node_modules)

# List all C25 dirs
C25_DIRS=$(find "$H" -maxdepth 2 -type d -name "*c25*" -o -name "*constellation*" -o -name "*sovereign*" 2>/dev/null | grep -v node_modules | grep -v llama)

# Write JSON inventory
cat > "$OUT/inventory_$TS.json" << JSONEOF
{
  "timestamp": "$TS",
  "totals": {
    "files": $TOTAL_FILES,
    "shell_scripts": $TOTAL_SH,
    "python_files": $TOTAL_PY,
    "javascript_files": $TOTAL_JS,
    "databases": $TOTAL_DB,
    "archives": $TOTAL_TAR,
    "agent_files": $TOTAL_AGENTS
  },
  "archives": $(echo "$ARCHIVES" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read().strip().split('\n')))"),
  "c25_dirs": $(echo "$C25_DIRS" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read().strip().split('\n')))")
}
JSONEOF

# Write HTML report
cat > "$OUT/inventory_$TS.html" << HTMLEOF
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>C25 Ecosystem Inventory $TS</title>
<style>
  body{background:#070712;color:#fff;font-family:'Courier New',monospace;padding:24px;margin:0}
  h1{color:#00FFD1;font-size:24px}
  h2{color:#FF6BFF;font-size:16px;margin-top:24px}
  .stat{display:inline-block;background:#ffffff0d;border:1px solid #00FFD133;
        border-radius:8px;padding:12px 20px;margin:6px;text-align:center}
  .stat .n{color:#00FFD1;font-size:28px;font-weight:bold}
  .stat .l{color:#ffffff55;font-size:11px}
  pre{background:#000;border:1px solid #ffffff12;padding:12px;border-radius:8px;
      font-size:11px;overflow-x:auto;white-space:pre-wrap;color:#4DFFB4}
  .ts{color:#ffffff33;font-size:11px}
</style>
</head>
<body>
<h1>🌌 C25 Ecosystem Inventory</h1>
<p class="ts">Generated: $TS · Device: u0_a510 · Sovereign Stack</p>
<div>
  <div class="stat"><div class="n">$TOTAL_FILES</div><div class="l">Total Files</div></div>
  <div class="stat"><div class="n">$TOTAL_SH</div><div class="l">Shell Scripts</div></div>
  <div class="stat"><div class="n">$TOTAL_PY</div><div class="l">Python Files</div></div>
  <div class="stat"><div class="n">$TOTAL_JS</div><div class="l">JS Files</div></div>
  <div class="stat"><div class="n">$TOTAL_DB</div><div class="l">Databases</div></div>
  <div class="stat"><div class="n">$TOTAL_TAR</div><div class="l">Archives</div></div>
  <div class="stat"><div class="n">$TOTAL_AGENTS</div><div class="l">Agent Files</div></div>
</div>
<h2>📦 Archives & Backups</h2>
<pre>$ARCHIVES</pre>
<h2>🌌 C25 Directories</h2>
<pre>$C25_DIRS</pre>
<h2>🗄️ Memoria Log (Last 20)</h2>
<pre>$(sqlite3 "$DB" "SELECT timestamp,agent,event,detail FROM logs ORDER BY id DESC LIMIT 20;" 2>/dev/null)</pre>
</body>
</html>
HTMLEOF

# Log to Memoria
sqlite3 "$DB" "INSERT INTO logs (agent,event,detail) VALUES ('Inventory','SCAN_COMPLETE','files=$TOTAL_FILES|sh=$TOTAL_SH|py=$TOTAL_PY|agents=$TOTAL_AGENTS');" 2>/dev/null

echo -e "\033[0;32m[Inventory]\033[0m Complete!"
echo "  Files:   $TOTAL_FILES"
echo "  Scripts: $TOTAL_SH bash | $TOTAL_PY python | $TOTAL_JS js"
echo "  Agents:  $TOTAL_AGENTS"
echo "  Archives:$TOTAL_TAR"
echo ""
echo "  JSON: $OUT/inventory_$TS.json"
echo "  HTML: $OUT/inventory_$TS.html"
echo ""
echo "  View: http://75.191.121.179:3000/inventory/$TS"
