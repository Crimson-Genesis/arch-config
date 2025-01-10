In Arch Linux's installation script, logs are often handled using standard tools like `tee`, `logger`, or manual redirection. Here's an example approach to creating your own installation script that logs everything:

1. **Redirect Output to a Log File**:  
   You can redirect both standard output (`stdout`) and standard error (`stderr`) to a log file.

   ```bash
   #!/bin/bash

   LOG_FILE="/var/log/my_install_script.log"

   # Redirect stdout and stderr to log file
   exec &> >(tee -a "$LOG_FILE")

   echo "Starting installation..."

   # Example command
   pacman -Syu --noconfirm

   echo "Installation completed."
   ```

   In this script:
   - `exec &> >(tee -a "$LOG_FILE")` redirects both `stdout` and `stderr` to the log file while still showing output in the terminal.
   - The log file is appended (`-a`) so you don’t overwrite existing logs.

2. **Use `logger` for System Logs**:  
   If you want to log information to the system log, you can use the `logger` command.

   ```bash
   logger "My installation script started."
   ```

   This will send the message to the system log (usually viewable with `journalctl`).

3. **Timestamps**:  
   To make the log more useful, you can add timestamps.

   ```bash
   # Example with timestamps
   exec &> >(tee -a "$LOG_FILE" | while read line; do echo "$(date +'%Y-%m-%d %H:%M:%S') $line"; done)
   ```

4. **Logging Commands**:  
   In your script, log the success or failure of commands as follows:

   ```bash
   command_output=$(pacman -Syu --noconfirm 2>&1)
   echo "$(date +'%Y-%m-%d %H:%M:%S') Command output: $command_output" >> "$LOG_FILE"
   ```

This will give you a comprehensive log of everything happening during the installation process, making it easier to debug or review later.

---

The command `tee -a "$LOG_FILE"` is used to simultaneously output the data to both the terminal and a log file. Here's what each part does:

- **`tee`**: This command reads from standard input and writes to both standard output (the terminal) and a file. It is often used to capture the output of commands while still displaying it on the screen.

- **`-a`**: The `-a` option stands for "append." This means the output will be added to the end of the specified file (`$LOG_FILE`) rather than overwriting its contents.

- **`"$LOG_FILE"`**: This is the variable that holds the path to the log file. It refers to where you want to save the log output.

### Example:

If you have the following line in a script:

```bash
echo "This is a log message" | tee -a "$LOG_FILE"
```

- The message `"This is a log message"` will be written to the terminal.
- It will also be appended to the log file stored in the variable `$LOG_FILE`.

This is useful for logging everything during the installation process, while still being able to monitor it in real-time.
