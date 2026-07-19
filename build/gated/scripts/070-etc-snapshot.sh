#!/bin/bash
# /etc drift auto-commit. 990-etc-git put /etc under a local git repo;
# this makes the LIVE system snapshot it automatically (boot + daily),
# so config changes made outside repo scripts (nmcli, hand-edits,
# package postinstalls) are always captured in history, never silently
# lost. The history is local-only by design: /etc/.git holds shadow and
# network credentials, so it must never gain a remote.
set -euo pipefail

cat > /usr/local/sbin/etc-snapshot << "EOF"
#!/bin/bash
# commit any /etc drift; noise is filtered by /etc/.gitignore
set -euo pipefail
cd /etc
git add -A
if ! git diff --cached --quiet; then
  git commit -q -m "etc snapshot $(date -u +%Y-%m-%dT%H:%M:%SZ) [auto]"
fi
EOF
chmod 755 /usr/local/sbin/etc-snapshot

cat > /etc/systemd/system/etc-snapshot.service << "EOF"
[Unit]
Description=Commit /etc configuration drift to the local git history

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/etc-snapshot
EOF

cat > /etc/systemd/system/etc-snapshot.timer << "EOF"
[Unit]
Description=/etc drift snapshot (boot + daily)

[Timer]
OnBootSec=2min
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl enable etc-snapshot.timer

if [ -d /run/systemd/system ]; then
  systemctl daemon-reload
  systemctl start etc-snapshot.timer
  systemctl start etc-snapshot.service
fi

echo "### 070-etc-snapshot: complete"
