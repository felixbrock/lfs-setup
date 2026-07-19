#!/bin/bash
# PostgreSQL (BLFS server/postgresql.html) — runs inside chroot.
# Service installed but NOT enabled; initdb done so `systemctl start
# postgresql` works out of the box in the VM.
set -euo pipefail
cd /sources/blfs
rm -rf postgresql-18.4
tar -xf postgresql-18.4.tar.bz2
cd postgresql-18.4

sed -e '/DEFAULT_PGSOCKET_DIR/s@/tmp@/run/postgresql@' \
    -i src/include/pg_config_manual.h

./configure --prefix=/usr \
            --docdir=/usr/share/doc/postgresql-18.4
make

getent group postgres > /dev/null || groupadd -g 41 postgres
getent passwd postgres > /dev/null || \
useradd -c "PostgreSQL Server" -g postgres -d /srv/pgsql/data \
        -u 41 postgres

make install

install -v -dm700 /srv/pgsql/data
install -v -dm755 /run/postgresql
chown -Rv postgres:postgres /srv/pgsql /run/postgresql

[ -f /srv/pgsql/data/PG_VERSION ] || \
su - postgres -c '/usr/bin/initdb -D /srv/pgsql/data'

# unit from blfs-systemd-units (install-postgresql target), not enabled
cd /sources/blfs
rm -rf blfs-systemd-units-20251204
tar -xf blfs-systemd-units-20251204.tar.xz
cd blfs-systemd-units-20251204
make install-postgresql
cd /sources/blfs
rm -rf blfs-systemd-units-20251204

rm -rf postgresql-18.4
echo "### 248-postgresql: complete"
