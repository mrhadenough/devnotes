# Remote LUKS Decryption via Tailscale + Dropbear

Complete guide for setting up remote disk unlock on Ubuntu Server with LUKS encryption, using Tailscale VPN and Dropbear SSH in initramfs.

## Overview

When an Ubuntu server with LUKS full-disk encryption reboots, it waits at a passphrase prompt before the OS can start. This setup lets you SSH into the pre-boot environment over Tailscale to enter the passphrase remotely.

**Components:**

- **LUKS** — full-disk encryption (set up during Ubuntu install)
- **dropbear-initramfs** — lightweight SSH server that runs before the OS boots
- **tailscale-initramfs** — Tailscale VPN client in initramfs (so you can reach dropbear over your tailnet)

---

## Prerequisites

- Ubuntu Server installed with LUKS encryption
- Tailscale already installed on the server (`https://pkgs.tailscale.com/stable/`)
- Tailscale installed on your client device (laptop/phone)
- Server connected via Ethernet (wired connection recommended for reliability)

---

## 1. Tailscale Dashboard Setup

### 1.1 Create ACL Tag

Go to **admin.tailscale.com → Access Controls** and add:

```json
{
  "tagOwners": {
    "tag:initramfs": ["autogroup:admin"]
  },
  "acls": [
    {"action": "accept", "src": ["autogroup:member"], "dst": ["*:*"]}
  ]
}
```

This allows your personal devices to connect to the initramfs node, while the initramfs node itself cannot initiate connections to anything else on your tailnet.

### 1.2 Generate Auth Key

Go to **admin.tailscale.com → Settings → Keys → Generate auth key**:

- **Reusable**: ✅ Yes (initramfs re-authenticates every boot)
- **Ephemeral**: ✅ Yes (stale nodes auto-remove when offline)
- **Tags**: `tag:initramfs`
- **Expiry**: 90 days (maximum)

Save the key — you'll need it in step 3.

> ⚠️ **IMPORTANT**: Auth keys expire after max 90 days. Set a calendar reminder to rotate the key before it expires, or you will lose remote unlock access.

---

## 2. Install Packages on Server

### 2.1 Install dropbear-initramfs

```bash
sudo apt update
sudo apt install dropbear-initramfs
```

### 2.2 Install tailscale-initramfs

```bash
# Add the repository
sudo mkdir -p --mode=0755 /usr/local/share/keyrings
curl -fsSL https://darkrain42.github.io/tailscale-initramfs/keyring.asc | sudo tee /usr/local/share/keyrings/tailscale-initramfs-keyring.asc >/dev/null
echo 'deb [signed-by=/usr/local/share/keyrings/tailscale-initramfs-keyring.asc] https://darkrain42.github.io/tailscale-initramfs/repo stable main' | sudo tee /etc/apt/sources.list.d/tailscale-initramfs.list >/dev/null

# Install
sudo apt update
sudo apt install tailscale-initramfs
```

### 2.3 Verify installation

```bash
dpkg -l | grep -E "tailscale-initramfs|dropbear-initramfs|tailscale "
```

You should see all three packages: `tailscale`, `dropbear-initramfs`, `tailscale-initramfs`.

---

## 3. Configure tailscale-initramfs

Edit `/etc/tailscale/initramfs/config`:

```bash
sudo vim /etc/tailscale/initramfs/config
```

Set your auth key `TAILSCALE_AUTHKEY` and required options `TAILSCALED_OPTIONS` `TAILSCALE_LOGOUT` :

```
TAILSCALE_AUTHKEY=tskey-auth-XXXXXXXXXXXX

# Store state in memory so the node deregisters on shutdown.
# Without this, stale nodes accumulate in the Tailscale dashboard
# and new registrations get suffixed names (-1, -2, etc.)
TAILSCALED_OPTIONS="--state=mem:"

# Log out of Tailscale cleanly before exiting initramfs.
# Requires IFDOWN=none in dropbear config (see step 4) so that
# network interfaces stay up long enough for logout to complete.
TAILSCALE_LOGOUT=1

# Fallback DNS if DHCP doesn't provide DNS
FALLBACK_DNS_SERVERS="1.1.1.1 8.8.8.8"
```

Optional settings (add to the same file):

```
# Custom hostname (default: <hostname>-initramfs)
# TAILSCALE_HOSTNAME=myserver-initramfs

# Disable Tailscale SSH (enabled by default)
# TAILSCALE_DISABLE_SSH=1
```

---

## 4. Configure Dropbear

### 4.1 Dropbear options

Edit `/etc/dropbear/initramfs/dropbear.conf`:

```bash
sudo vim /etc/dropbear/initramfs/dropbear.conf
```

Set `DROPBEAR_OPTIONS` and `IFDOWN`:

```
DROPBEAR_OPTIONS="-I 180 -j -k -p 2222 -s -c cryptroot-unlock"

# Keep network interfaces up when exiting initramfs.
# Required for TAILSCALE_LOGOUT=1 to work — without this,
# dropbear brings down all interfaces before tailscale can
# perform a clean logout, leaving stale nodes in the dashboard.
IFDOWN=none
```

**Flags explained:**

| Flag | Meaning |
|------|---------|
| `-I 180` | Disconnect idle sessions after 180 seconds |
| `-j` | Disable local port forwarding |
| `-k` | Disable remote port forwarding |
| `-p 2222` | Listen on port 2222 |
| `-s` | Disable password auth (key-only) |
| `-c cryptroot-unlock` | Force run `cryptroot-unlock` on connect (auto-prompts for LUKS passphrase) |

### 4.2 Add your SSH public keys

```bash
sudo vim /etc/dropbear/initramfs/authorized_keys
```

Paste your public key(s), one per line:

```
ssh-ed25519 AAAAC3Nza... user@device
```

Set permissions:

```bash
sudo chmod 600 /etc/dropbear/initramfs/authorized_keys
```

---

## 5. Configure Networking in Initramfs

This is the most critical step. Without proper network config, dropbear won't be reachable.

### 5.1 Set kernel boot parameter

Edit `/etc/default/grub`:

```bash
sudo vim /etc/default/grub
```

Add `ip=dhcp` to the `GRUB_CMDLINE_LINUX` line:

```
GRUB_CMDLINE_LINUX="ip=dhcp"
```

Then update GRUB:

```bash
sudo update-grub
```

### 5.2 Set network device in initramfs config

Find your wired interface name:

```bash
ip link show | grep -E "^[0-9]"
# Look for something like enp1s0, eth0, eno1
```

Edit `/etc/initramfs-tools/initramfs.conf`:

```bash
sudo vim /etc/initramfs-tools/initramfs.conf
```

Set:

```
DEVICE=enp1s0
```

(Replace `enp1s0` with your actual interface name.)

### 5.3 Ensure NIC driver is included

Check that your network driver is in the initramfs:

```bash
# Find your NIC driver
ethtool -i enp1s0 | grep driver

# Verify it's in initramfs
lsinitramfs /boot/initrd.img-$(uname -r) | grep <driver_name>
```

If the driver is missing, add it:

```bash
echo "<driver_name>" | sudo tee -a /etc/initramfs-tools/modules
```

---

## 6. Build Initramfs and Reboot

```bash
# Rebuild initramfs for all kernels
sudo update-initramfs -u -k all

# Verify everything is included
lsinitramfs /boot/initrd.img-$(uname -r) | grep tailscale
lsinitramfs /boot/initrd.img-$(uname -r) | grep dropbear

# Reboot
sudo reboot
```

---

## 7. Connect and Unlock

From your client device (laptop/phone on the same tailnet):

```bash
ssh -p 2222 root@<server-hostname>-initramfs
```

You should see:

```
Please unlock disk dm_crypt-0:
```

Type your LUKS passphrase. The server will continue booting normally.

### If hostname doesn't resolve

Use the Tailscale IP instead (check **admin.tailscale.com → Machines**):

```bash
ssh -p 2222 root@100.x.x.x
```

Or use the full domain name:

```bash
ssh -p 2222 root@<server-hostname>-initramfs.<tailnet-name>.ts.net
```

Find your tailnet name: `tailscale status` (first line) or **admin.tailscale.com → DNS**.

### Alternative: Tailscale SSH (no dropbear)

The tailscale-initramfs package enables Tailscale SSH by default (port 22). You can also connect via:

```bash
ssh root@<server-hostname>-initramfs
```

This bypasses dropbear entirely but does NOT auto-run `cryptroot-unlock` — you'll need to run it manually after connecting.

---

## 8. Client SSH Config (Optional)

Add to `~/.ssh/config` on your client for convenience:

```
Host luks-unlock
    HostName <server-hostname>-initramfs.<tailnet-name>.ts.net
    Port 2222
    User root
    # Use a specific key if needed:
    # IdentityFile ~/.ssh/id_ed25519
```

Then just:

```bash
ssh luks-unlock
```

---

## Troubleshooting

### Tailscale node doesn't appear in admin after reboot

- Auth key is expired or invalid — generate a new one
- No network in initramfs — verify `ip=dhcp` is in GRUB_CMDLINE_LINUX
- NIC driver missing from initramfs — add it to `/etc/initramfs-tools/modules`
- DNS issue — add `FALLBACK_DNS_SERVERS="1.1.1.1 8.8.8.8"` to tailscale initramfs config

### Node appears in admin but SSH hangs

- Dropbear started before network was ready — ensure `ip=dhcp` and `DEVICE=` are set
- Wrong IP/hostname — check `tailscale status` from client for the correct address
- Multiple stale initramfs nodes — delete old ones in admin dashboard

### Multiple nodes with suffixed names (-1, -2, etc.)

The initramfs node didn't cleanly deregister from the previous boot. Ensure all three settings are in place:

1. `TAILSCALED_OPTIONS="--state=mem:"` in `/etc/tailscale/initramfs/config` — uses memory-only state so the node registers as ephemeral
2. `TAILSCALE_LOGOUT=1` in `/etc/tailscale/initramfs/config` — runs `tailscale logout` before exiting initramfs
3. `IFDOWN=none` in `/etc/dropbear/initramfs/dropbear.conf` — keeps interfaces up so logout can complete

If stale nodes exist, delete them manually in **admin.tailscale.com → Machines**, rebuild initramfs, and reboot.

### Connection refused on port 2222

- Dropbear not in initramfs — run `lsinitramfs /boot/initrd.img-$(uname -r) | grep dropbear`
- Rebuild: `sudo update-initramfs -u -k all`

### "Host key verification failed"

The initramfs dropbear generates different host keys than the full OS SSH. Add to your `~/.ssh/config`:

```
Host luks-unlock
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
```

Or accept the new key when prompted.

### Works after clean reboot but not after power outage

Known issue with tailscale-initramfs. The `--state=mem:` and `TAILSCALE_LOGOUT=1` settings help because they ensure clean deregistration on normal shutdown. After an unexpected power loss, the old node may linger — it will eventually expire on its own (ephemeral nodes), but you may need to delete it manually from the dashboard if the new node gets a suffixed name.

---

## Maintenance

### Rotate auth key (every 90 days)

1. Generate new auth key in **admin.tailscale.com → Settings → Keys**
2. Update `/etc/tailscale/initramfs/config` with new key
3. Rebuild: `sudo update-initramfs -u -k all`
4. Set a reminder for the next rotation

### After kernel update

Initramfs is usually rebuilt automatically. Verify:

```bash
lsinitramfs /boot/initrd.img-$(uname -r) | grep -c tailscale
```

If zero, rebuild manually:

```bash
sudo update-initramfs -u -k all
```

### Verify setup after changes

```bash
# All packages installed
dpkg -l | grep -E "tailscale-initramfs|dropbear-initramfs"

# Config files present
cat /etc/tailscale/initramfs/config
cat /etc/dropbear/initramfs/dropbear.conf
cat /etc/dropbear/initramfs/authorized_keys

# Kernel params
grep CMDLINE /etc/default/grub

# Initramfs contents
lsinitramfs /boot/initrd.img-$(uname -r) | grep -E "tailscale|dropbear"
```

---

## Security Notes

- The auth key is stored **in plaintext** in the initramfs (which is unencrypted on the boot partition). Anyone with physical access to the disk can extract it.
- Use ACL tags (`tag:initramfs`) to ensure the initramfs node can only accept incoming connections and cannot reach other devices on your tailnet.
- Use SSH key authentication only (`-s` flag in dropbear) — never password auth.
- The `-c cryptroot-unlock` flag in dropbear restricts the SSH session to only the unlock command.

---

## Quick Reference: File Locations

| File | Purpose |
|------|---------|
| `/etc/tailscale/initramfs/config` | Tailscale auth key and options |
| `/etc/dropbear/initramfs/dropbear.conf` | Dropbear SSH server options |
| `/etc/dropbear/initramfs/authorized_keys` | SSH public keys for unlock access |
| `/etc/default/grub` | Kernel boot parameters (`ip=dhcp`) |
| `/etc/initramfs-tools/initramfs.conf` | Initramfs network device config |
| `/etc/initramfs-tools/modules` | Extra kernel modules to include |

## Quick Reference: Commands

```bash
# Rebuild initramfs
sudo update-initramfs -u -k all

# Update GRUB
sudo update-grub

# Inspect initramfs contents
lsinitramfs /boot/initrd.img-$(uname -r) | grep <search>

# Check tailscale status from client
tailscale status

# Connect to unlock
ssh -p 2222 root@<server>-initramfs
```
