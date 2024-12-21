To set up WiFi using `iwctl`, follow these steps:

### 1. **Start iwctl**
   Open a terminal and start the `iwctl` interactive command-line interface by typing:
   ```bash
   iwctl
   ```

### 2. **List Available Devices**
   To see your WiFi interface name (e.g., `wlan0` or `wlp3s0`), run:
   ```bash
   device list
   ```

### 3. **Enable the WiFi Interface**
   If your WiFi device is not enabled, you can enable it with:
   ```bash
   device <interface_name> set-property Powered on
   ```
   Replace `<interface_name>` with your device name.

### 4. **Scan for Networks**
   To search for available WiFi networks:
   ```bash
   station <interface_name> scan
   ```
   Then list the scanned networks:
   ```bash
   station <interface_name> get-networks
   ```

### 5. **Connect to a WiFi Network**
   Use the following command to connect to a WiFi network:
   ```bash
   station <interface_name> connect <SSID>
   ```
   - Replace `<SSID>` with the name of the WiFi network.
   - If the network is password-protected, you’ll be prompted to enter the passphrase.

### 6. **Verify Connection**
   After connecting, you can check the connection status:
   ```bash
   station <interface_name> show
   ```
   You should see `connected` under `State`.

### 7. **Optional: Set the Connection as Persistent**
   If you want the connection to persist after reboot, make sure you have a DHCP client configured (e.g., `systemd-networkd` or `NetworkManager`).

### 8. **Exit iwctl**
   Exit the interactive mode by typing:
   ```bash
   exit
   ```

---

#### Notes:
- Ensure your WiFi adapter (e.g., TL-WN722N) is recognized and powered on.
- If you encounter issues, check for missing firmware by running:
  ```bash
  dmesg | grep firmware
  ```
- If you’re using `iwd` (iNet wireless daemon), make sure it’s running:
  ```bash
  systemctl start iwd
  ```
