#!/usr/bin/env python3
"""Generate chapter 8 build scripts from the LFS 13.0-systemd book pages.

Each page's <pre class="userinput"> blocks are extracted verbatim; the map
below picks which blocks to include (None = all) and which get a tolerance
wrapper because the book expects nonzero exits (test suites with known
failures). Every skip is deliberate and listed here for review.
"""
import html, re, os, sys

SRC = '/mnt/lfs/sources'

# page -> (tarball_prefix|None, include_indexes|None, tolerant_indexes)
# Skips, by category:
#   tests not marked critical by the book; upgrade-only blocks (glibc 9-11);
#   interactive blocks (tzselect, passwd root, bash exec --login);
#   optional docs; optional LSB/compat rebuilds (libxcrypt 5, ncurses 6);
#   optional NINJAJOBS support (ninja 0); sqlite doc unpack/install (0, 4).
PLAN = [
    ('man-pages',  'man-pages',  None,                              []),
    ('iana-etc',   'iana-etc',   None,                              []),
    ('glibc',      'glibc',      [0,1,2,3,4,5,7,8,12,13,14,15,17,18,20,21,22], [5]),
    ('zlib',       'zlib',       [0,1,3,4],                         []),
    ('bzip2',      'bzip2',      None,                              []),
    ('xz',         'xz',         [0,1,3],                           []),
    ('lz4',        'lz4',        [0,2],                             []),
    ('zstd',       'zstd',       [0,2,3],                           []),
    ('file',       'file',       [0,1,3],                           []),
    ('readline',   'readline',   [0,1,2,3,4,5],                     []),
    ('pcre2',      'pcre2',      [0,1,3],                           []),
    ('m4',         'm4',         [0,1,3],                           []),
    ('bc',         'bc',         [0,1,3],                           []),
    ('flex',       'flex',       [0,1,3,4],                         []),
    ('tcl',        'tcl',        [0,1,3,4,5,6,7],                   []),
    ('expect',     'expect',     [0,1,2,3,5],                       []),
    ('dejagnu',    'dejagnu',    [0,1,3],                           []),
    ('pkgconf',    'pkgconf',    None,                              []),
    ('binutils',   'binutils',   [0,1,2,3,4,5,6],                   [3,4]),
    ('gmp',        'gmp',        [1,2,3,4,5,6],                     [4]),
    ('mpfr',       'mpfr',       None,                              []),   # tests strict: all 198 must pass
    ('mpc',        'mpc',        [0,1,3],                           []),
    ('attr',       'attr',       [0,1,3],                           []),
    ('acl',        'acl',        [0,1,3],                           []),
    ('libcap',     'libcap',     [0,1,3],                           []),
    ('libxcrypt',  'libxcrypt',  [0,1,2,4],                         []),
    ('shadow',     'shadow',     [0,1,2,3,4,5,6,7,8],               []),   # skip 9: passwd root (interactive)
    ('gcc',        'gcc',        None,                              [7,8]),
    ('ncurses',    'ncurses',    [0,1,2,3,4],                       []),
    ('sed',        'sed',        [0,1,3],                           []),
    ('psmisc',     'psmisc',     [0,1,3],                           []),
    ('gettext',    'gettext',    [0,1,3],                           []),
    ('bison',      'bison',      [0,1,3],                           []),
    ('grep',       'grep',       [0,1,2,4],                         []),
    ('bash',       'bash',       [0,1,4],                           []),   # skip 2,3 tests; skip 5 exec --login
    ('libtool',    'libtool',    [0,1,3,4],                         []),
    ('gdbm',       'gdbm',       [0,1,3],                           []),
    ('gperf',      'gperf',      [0,1,3],                           []),
    ('expat',      'expat',      [0,1,3],                           []),
    ('inetutils',  'inetutils',  [0,1,2,4,5],                       []),
    ('less',       'less',       [0,1,3],                           []),
    ('perl',       'perl',       [0,1,2,4],                         []),
    ('xml-parser', 'XML-Parser', [0,1,3],                           []),
    ('intltool',   'intltool',   [0,1,2,4],                         []),
    ('autoconf',   'autoconf',   [0,1,3],                           []),
    ('automake',   'automake',   [0,1,3],                           []),
    ('openssl',    'openssl',    [0,1,3,4],                         []),
    ('libelf',     'elfutils',   None,                              []),
    ('libffi',     'libffi',     [0,1,3],                           []),
    ('sqlite',     'sqlite-autoconf', [1,2,3],                      []),
    ('Python',     'Python',     [0,1,3,4],                         []),
    ('flit-core',  'flit_core',  None,                              []),
    ('packaging',  'packaging',  None,                              []),
    ('wheel',      'wheel',      None,                              []),
    ('setuptools', 'setuptools', None,                              []),
    ('ninja',      'ninja',      [1,2],                             []),
    ('meson',      'meson',      None,                              []),
    ('kmod',       'kmod',       None,                              []),
    ('coreutils',  'coreutils',  [0,1,2,8,9],                       []),
    ('diffutils',  'diffutils',  [0,1,3],                           []),
    ('gawk',       'gawk',       [0,1,2,4,5],                       []),
    ('findutils',  'findutils',  [0,1,3],                           []),
    ('groff',      'groff',      [0,1,3],                           []),
    ('grub',       'grub',       [0,1,2,3,4],                       []),
    ('gzip',       'gzip',       [0,1,3],                           []),
    ('iproute2',   'iproute2',   [0,1,2],                           []),
    ('kbd',        'kbd',        [0,1,2,3,5],                       []),
    ('libpipeline','libpipeline',[0,1,2],                           []),
    ('make',       'make',       [0,1,3],                           []),
    ('patch',      'patch',      [0,1,3],                           []),
    ('tar',        'tar',        [0,1,3],                           []),
    ('texinfo',    'texinfo',    [0,1,2,4],                         []),
    ('vim',        'vim',        [0,1,2,5,6,7,8],                   []),
    ('markupsafe', 'markupsafe', None,                              []),
    ('jinja2',     'jinja2',     None,                              []),
    ('systemd',    'systemd',    [0,1,2,4,5,6,7],                   []),
    ('dbus',       'dbus',       [0,1,3,4],                         []),
    ('man-db',     'man-db',     [0,1,3],                           []),
    ('procps-ng',  'procps-ng',  [0,1,3],                           []),
    ('util-linux', 'util-linux', [0,1,4],                           []),
    ('e2fsprogs',  'e2fsprogs',  [0,1,2,4,5,6],                     []),
]

# Substitutions for book placeholders / host-mirroring choices.
SUBS = [
    ('PAGE=<paper_size> ', 'PAGE=A4 '),                                # groff: UK paper
    ('ln -sfv /usr/share/zoneinfo/<xxx>', 'ln -sfv /usr/share/zoneinfo/Europe/London'),  # host tz
]

sources = os.listdir(SRC)
def tarball(prefix):
    pat = re.escape(prefix) + r'[0-9.-]*[0-9](-src)?\.tar\.(xz|gz|bz2|lz)'
    c = [s for s in sources if re.fullmatch(pat, s, re.I)]
    assert len(c) == 1, (prefix, c)
    return c[0]

def srcdir_of(tb):
    d = re.sub(r'\.tar\..*$', '', tb)
    return re.sub(r'-src$', '', d)   # tcl9.0.3-src -> tcl9.0.3

def blocks(page):
    src = open(f'{page}.html').read()
    return [html.unescape(re.sub(r'<[^>]+>', '', b)).strip()
            for b in re.findall(r'<pre class="userinput">(.*?)</pre>', src, re.S)]

for n, (page, prefix, include, tolerant) in enumerate(PLAN, 1):
    bs = blocks(page)
    idxs = include if include is not None else list(range(len(bs)))
    parts = []
    for i in idxs:
        b = bs[i]
        for old, new in SUBS:
            b = b.replace(old, new)
        if i in tolerant:
            b = '(\n' + b + '\n) || true   # book: nonzero exit / known failures tolerated, log reviewed'
        parts.append(b)
    tb = tarball(prefix)
    srcdir = srcdir_of(tb)
    name = f'{n*10:03d}-{page}'
    script = f"""#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 ({page}) — runs inside chroot
# Included book blocks: {idxs} of {len(bs)}; tolerant: {tolerant}
set -euo pipefail
cd /sources
rm -rf {srcdir}
tar -xf {tb}
cd {srcdir}

""" + '\n\n'.join(parts) + f"""

cd /sources
rm -rf {srcdir}
echo "### {name}: complete"
"""
    open(f'{name}.sh', 'w').write(script)
    print(f'{name}.sh <- {tb} ({len(idxs)}/{len(bs)} blocks)')

# Post-package steps
open('895-root-password.sh','w').write("""#!/bin/bash
# NOT from the book (book uses interactive 'passwd root'): temporary root
# password for the QEMU phase. MUST be changed before hardware migration
# (tracked in config repo VERIFICATION.md, Gate D).
set -euo pipefail
echo 'root:lfs' | chpasswd
echo "### 895-root-password: complete"
""")

strip_blocks = blocks('stripping')
open('910-stripping.sh','w').write(
    "#!/bin/bash\n# LFS 13.0-systemd 8.85 stripping (book-verbatim)\nset -euo pipefail\n\n"
    + strip_blocks[0] + '\n\necho "### 910-stripping: complete"\n')

cl = blocks('cleanup')
cl[0] = '(\n' + cl[0] + '\n) || true   # rm -rf /tmp/.* always complains about . and ..'
open('920-cleanup.sh','w').write(
    "#!/bin/bash\n# LFS 13.0-systemd 8.86 cleanup\nset -euo pipefail\n\n"
    + '\n\n'.join(cl) + '\n\necho "### 920-cleanup: complete"\n')
print('895-root-password.sh, 910-stripping.sh, 920-cleanup.sh written')
