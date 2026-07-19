#!/bin/bash
# Redis 8.8.0 (upstream; dropped from BLFS after relicensing — 8.x is AGPL
# again). Matches the Arch host's version. Service installed, NOT enabled.
set -euo pipefail
cd /sources/blfs
rm -rf redis-8.8.0
tar -xf redis-8.8.0.tar.gz
cd redis-8.8.0

make

make PREFIX=/usr install

getent group redis > /dev/null || groupadd -g 60 redis
getent passwd redis > /dev/null || \
useradd -c "Redis Server" -g redis -d /var/lib/redis -s /bin/false \
        -u 60 redis

install -v -dm750 -o redis -g redis /var/lib/redis /var/log/redis
install -v -dm755 /etc/redis
[ -f /etc/redis/redis.conf ] || {
  sed -e 's@^dir \./@dir /var/lib/redis@' \
      -e 's@^logfile ""@logfile /var/log/redis/redis.log@' \
      redis.conf > /etc/redis/redis.conf
}

cat > /etc/systemd/system/redis.service << "EOF"
[Unit]
Description=Redis in-memory data store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/bin/redis-server /etc/redis/redis.conf --daemonize no
ExecStop=/usr/bin/redis-cli shutdown
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

cd /sources/blfs
rm -rf redis-8.8.0
echo "### 249-redis: complete"
