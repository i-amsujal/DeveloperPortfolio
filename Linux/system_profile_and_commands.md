# Linux System Profile & Command Reference

This document provides a sample Linux system profile along with essential command-line references and example outputs across file navigation, permissions, process management, networking, and disk usage.

---

## Sample System Profile

> **Note:** The values below represent a sample Linux workstation profile generated for reference purposes.

| Property | Sample Value |
| :--- | :--- |
| **Hostname** | `dev-workstation` |
| **Operating System** | Ubuntu 24.04.1 LTS (Noble Numbat) |
| **Kernel** | `Linux 6.8.0-45-generic x86_64` |
| **Architecture** | `x86_64` (64-bit) |
| **CPU** | 8 vCPUs — Intel(R) Core(TM) i7-12700H @ 2.30GHz |
| **Memory (RAM)** | 16 GiB total (6.4 GiB used, 9.6 GiB available) |
| **Root Filesystem** | 256G ext4 (48G used, 195G available, 20% usage) |
| **Shell** | `/bin/bash` (GNU bash, version 5.2.21) |
| **Default User** | `developer` (UID `1000`, GID `1000`) |

### Sample Profile Command Outputs

```bash
$ uname -a
Linux dev-workstation 6.8.0-45-generic #45-Ubuntu SMP PREEMPT_DYNAMIC x86_64 x86_64 x86_64 GNU/Linux

$ cat /etc/os-release
PRETTY_NAME="Ubuntu 24.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.1 LTS (Noble Numbat)"
ID=ubuntu
ID_LIKE=debian

$ lscpu | grep -E "Model name|CPU\(s\)|Architecture"
Architecture:                         x86_64
CPU(s):                               8
Model name:                           Intel(R) Core(TM) i7-12700H

$ uptime
 18:15:42 up 4 days,  3:27,  1 user,  load average: 0.42, 0.38, 0.31
```

---

## 1. File Navigation & Inspection

Commands for moving through directories, listing files, searching paths, and inspecting text files.

### `pwd` — Print Working Directory
Displays the absolute path of the current directory.

```bash
$ pwd
/home/developer/projects/cs-fundamental
```

### `ls -la` — List Directory Contents
Lists all files (including hidden dotfiles starting with `.`) in long format with permissions, owner, size, and timestamps.

```bash
$ ls -la
total 24
drwxr-xr-x 7 developer developer 4096 Nov 26 18:00 .
drwxr-xr-x 4 developer developer 4096 Nov 25 10:12 ..
drwxr-xr-x 8 developer developer 4096 Nov 26 18:00 .git
drwxr-xr-x 2 developer developer 4096 Nov 26 17:45 API
drwxr-xr-x 2 developer developer 4096 Nov 26 17:40 Linux
-rw-r--r-- 1 developer developer 2450 Nov 26 18:00 README.md
drwxr-xr-x 2 developer developer 4096 Nov 26 17:50 ShellScripts
```

### `cd` — Change Directory
Navigates between directories (`..` moves up one level; `~` returns to `$HOME`; `-` toggles to the previous directory).

```bash
$ cd ShellScripts/
$ pwd
/home/developer/projects/cs-fundamental/ShellScripts

$ cd -
/home/developer/projects/cs-fundamental
```

### `find` — Search Files and Directories
Recursively locates files matching a name pattern, file type, or modification time.

```bash
$ find . -maxdepth 2 -type f -name "*.sh"
./ShellScripts/backup_script.sh
./ShellScripts/file_organizer.sh
./ShellScripts/system_info.sh
```

### `mkdir -p`, `cp`, `mv`, and `head` / `tail` / `grep`
Common operations for creating nested folders, copying/moving files, and filtering file contents.

```bash
$ mkdir -p /tmp/demo_workspace/logs
$ cp README.md /tmp/demo_workspace/README.bak.md
$ grep -n "ShellScripts" README.md
14:| `Q2` | `ShellScripts/` | Bash automation scripts (`system_info.sh`, `backup_script.sh`, `file_organizer.sh`) |
```

---

## 2. File Permissions & Ownership

Linux access control uses three permission classes (**User/Owner**, **Group**, **Others**) and three permission bits (**Read `r=4`**, **Write `w=2`**, **Execute `x=1`**).

### Understanding `ls -l` Permission Strings

```text
-rwxr-xr--  1  developer  developers  1842  Nov 26 17:50  system_info.sh
│├─┘├─┘├─┘
│ │  │  └── Others: r-- (4) = read-only
│ │  └───── Group:  r-x (5) = read + execute
│ └──────── Owner:  rwx (7) = read + write + execute
└────────── File type ('-' regular file, 'd' directory, 'l' symlink)
```

### `chmod` — Change File Permissions
Modifies access permissions using either symbolic notation (`u+x`, `go-w`) or numeric octal mode (`755`, `644`, `600`).

```bash
$ ls -l ShellScripts/system_info.sh
-rw-r--r-- 1 developer developer 2140 Nov 26 17:50 ShellScripts/system_info.sh

$ chmod +x ShellScripts/system_info.sh
$ ls -l ShellScripts/system_info.sh
-rwxr-xr-x 1 developer developer 2140 Nov 26 17:50 ShellScripts/system_info.sh

$ chmod 600 ~/.ssh/id_ed25519
$ ls -l ~/.ssh/id_ed25519
-rw------- 1 developer developer 419 Nov 12 09:10 /home/developer/.ssh/id_ed25519
```

### `chown` — Change File Owner and Group
Updates the owning user and/or group of a file or directory (typically requires `sudo`).

```bash
$ sudo chown developer:developers /var/www/app_logs
$ ls -ld /var/www/app_logs
drwxr-xr-x 2 developer developers 4096 Nov 26 14:20 /var/www/app_logs
```

### `umask` — Default Permission Mask
Shows or sets the permission bits masked out when new files (`666 - umask`) and directories (`777 - umask`) are created.

```bash
$ umask
0022
```

---

## 3. Process Management

Commands for inspecting running processes, monitoring resource usage, and managing background or unresponsive jobs.

### `ps aux` — Snapshot of Running Processes
Lists all active processes with user, PID, CPU%, MEM%, start time, and command.

```bash
$ ps aux | head -n 6
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.1 169440 13280 ?        Ss   Nov22   0:04 /sbin/init
developer   1842  0.2  0.8 712480 65432 ?        Sl   10:00   0:14 /usr/bin/python3 API/fetch_api.py
developer   2105  0.0  0.0  10420  5240 pts/0    Ss   18:10   0:00 /bin/bash
developer   2290  0.0  0.0  11640  3892 pts/0    R+   18:16   0:00 ps aux
```

### `top` (Batch Mode) — Live CPU & Memory Monitor
Displays real-time process utilization; `-b -n 1` captures a single non-interactive snapshot.

```bash
$ top -b -n 1 | head -n 10
top - 18:16:04 up 4 days,  3:27,  1 user,  load average: 0.42, 0.38, 0.31
Tasks: 184 total,   1 running, 183 sleeping,   0 stopped,   0 zombie
%Cpu(s):  3.1 us,  1.2 sy,  0.0 ni, 95.4 id,  0.2 wa,  0.0 hi,  0.1 si,  0.0 st
MiB Mem :  16000.0 total,   6210.4 free,   6412.2 used,   3377.4 buff/cache
MiB Swap:   2048.0 total,   2048.0 free,      0.0 used.   9180.5 avail Mem
```

### `pgrep` & `kill` — Find and Signal Processes
Locates process IDs by name and sends termination signals (`SIGTERM` / `-15` gracefully, `SIGKILL` / `-9` forcefully).

```bash
$ pgrep -a python3
1842 /usr/bin/python3 -m http.server 8000

$ kill -15 1842
$ pgrep -a python3
```

### `jobs`, `bg`, `fg` — Shell Job Control
Manages background tasks started inside the current terminal session.

```bash
$ sleep 120 &
[1] 2410

$ jobs
[1]+  Running                 sleep 120 &

$ kill %1
[1]+  Terminated              sleep 120
```

---

## 4. Networking & Connectivity

Commands for checking network interfaces, open ports, DNS resolution, reachability, and HTTP endpoints.

### `ip addr` (or `ip a`) — Network Interfaces & IP Addresses
Displays network adapters, MAC addresses, and assigned IPv4/IPv6 addresses.

```bash
$ ip -brief addr
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             192.168.1.42/24 fe80::215:5dff:fe01:2345/64
```

### `ss -tulnp` — Active Listening Sockets & Ports
Lists listening TCP (`-t`) and UDP (`-u`) ports numerically (`-n`) along with the owning process (`-p`).

```bash
$ ss -tulnp
Netid  State   Recv-Q  Send-Q   Local Address:Port   Peer Address:Port  Process
tcp    LISTEN  0       128      127.0.0.1:8000       0.0.0.0:*          users:(("python3",pid=2501,fd=3))
tcp    LISTEN  0       128      0.0.0.0:22           0.0.0.0:*
```

### `ping` — ICMP Connectivity Test
Checks packet round-trip latency and packet loss to a remote host (`-c 3` limits to 3 packets).

```bash
$ ping -c 3 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=57 time=11.4 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=57 time=10.9 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=57 time=11.2 ms

--- 1.1.1.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 10.912/11.174/11.408/0.203 ms
```

### `curl -I` — Inspect HTTP Response Headers
Fetches HTTP headers without downloading the full response body—useful for debugging APIs and web servers.

```bash
$ curl -sI https://api.github.com | head -n 6
HTTP/2 200
server: github.com
date: Thu, 26 Nov 2026 12:48:10 GMT
content-type: application/json; charset=utf-8
cache-control: public, max-age=60, s-maxage=60
x-ratelimit-limit: 60
```

### `dig` / `nslookup` — DNS Lookup
Resolves domain names to IP addresses and inspects DNS records.

```bash
$ dig +short api.github.com
140.82.113.5
```

---

## 5. Disk Usage, Memory & Storage

Commands for monitoring filesystem capacity, folder sizes, block devices, and RAM/swap usage.

### `df -h` — Filesystem Disk Space Usage
Shows mounted filesystems, total capacity, used/available space, and mount points in human-readable units (`-h`).

```bash
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/nvme0n1p2  256G   48G  195G  20% /
tmpfs           7.8G  2.1M  7.8G   1% /dev/shm
/dev/nvme0n1p1  511M  6.1M  505M   2% /boot/efi
```

### `du -sh` — Directory Disk Usage Summary
Calculates total disk space consumed by files or subdirectories (`-s` summary, `-h` human-readable).

```bash
$ du -sh *
16K     API
12K     Linux
16K     Portfolio
8.0K    README.md
8.0K    Screenshots
20K     ShellScripts
```

### `free -h` — System Memory and Swap
Reports physical RAM and swap allocation, including cached/buffered memory and truly available memory.

```bash
$ free -h
               total        used        free      shared  buff/cache   available
Mem:            15Gi       6.2Gi       6.1Gi       312Mi       3.3Gi       9.0Gi
Swap:          2.0Gi          0B       2.0Gi
```

### `lsblk` — List Block Devices
Displays disks and partitions in a tree view with sizes, types, and mount points.

```bash
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme0n1     259:0    0   256G  0 disk
├─nvme0n1p1 259:1    0   512M  0 part /boot/efi
└─nvme0n1p2 259:2    0 255.5G  0 part /
```
