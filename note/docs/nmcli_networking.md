To see the Ethernet connection in Arch Linux, you can use the following commands:

### 1. **Using `ip` Command**:
The `ip` command is part of the `iproute2` package, installed by default in most Arch Linux setups.

- **Check all network interfaces:**
  ```bash
  ip addr
  ```
  Look for interfaces like `eth0` or `enpXsY` (common names for Ethernet connections). Check if they have an `inet` address, indicating an active connection.

### 2. **Using `nmcli` (for NetworkManager):**
If you use NetworkManager, the `nmcli` command can display connection details.

- **List all active connections:**
  ```bash
  nmcli connection show
  ```
- **Check specific device status:**
  ```bash
  nmcli device status
  ```

### 3. **Using `ethtool` (for detailed Ethernet info):**
Install `ethtool` if not already installed:
```bash
sudo pacman -S ethtool
```

- **Check interface details:**
  ```bash
  sudo ethtool <interface_name>
  ```
  Replace `<interface_name>` with your Ethernet interface, e.g., `enp0s3`.

### 4. **Using `ifconfig` (deprecated but still available):**
If you have `net-tools` installed:
```bash
sudo pacman -S net-tools
```

- **View network interfaces:**
  ```bash
  ifconfig
  ```

### 5. **Using `systemctl` to Check Network Service:**
If you're unsure if your Ethernet connection is active, check the service managing it:
```bash
sudo systemctl status NetworkManager
```
or, for systemd-networkd:
```bash
sudo systemctl status systemd-networkd
```

