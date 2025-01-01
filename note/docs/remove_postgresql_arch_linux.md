It looks like you’re encountering a serious issue with PostgreSQL crashing, and you want to remove all PostgreSQL-related files from your system to start fresh. I'll guide you through the process of completely uninstalling and reinstalling PostgreSQL.

### Step 1: **Stop the PostgreSQL Service**
First, stop the PostgreSQL service if it's running:
```bash
sudo systemctl stop postgresql
```

---

### Step 2: **Remove PostgreSQL Packages**
Now, we will uninstall PostgreSQL and related packages. Use the `-Rns` option to remove both the PostgreSQL package and its dependencies:
```bash
sudo pacman -Rns postgresql
```

This will remove PostgreSQL and any unnecessary dependencies that were installed with it.

---

### Step 3: **Delete PostgreSQL Data Directory**
You will need to manually remove the PostgreSQL data directory, which stores the database files. Run:
```bash
sudo rm -rf /var/lib/postgres/
```

This will delete all PostgreSQL-related data. Be **careful** with this step, as it will remove any existing databases on your system.

---

### Step 4: **Remove Configuration Files**
Some configuration files may remain after uninstalling PostgreSQL. To remove them, you can manually delete the PostgreSQL-related configuration files in `/etc`:
```bash
sudo rm -rf /etc/postgresql/
sudo rm -rf /etc/postgresql.conf.sample
```

---

### Step 5: **Remove PostgreSQL Logs and Other Files**
Check for any leftover PostgreSQL log files or directories:
```bash
sudo rm -rf /var/log/postgresql/
sudo rm -rf /var/lib/postgresql/
```

---

### Step 6: **Reinstall PostgreSQL**
Now that PostgreSQL has been completely removed, you can reinstall it fresh:
```bash
sudo pacman -S postgresql
```

---

### Step 7: **Initialize the Database Cluster**
After reinstalling PostgreSQL, you will need to initialize the database system:
```bash
sudo -u postgres initdb -D /var/lib/postgres/data
```

---

### Step 8: **Start PostgreSQL Service**
Once the initialization is complete, start the PostgreSQL service again:
```bash
sudo systemctl start postgresql
```

You can also enable it to start on boot:
```bash
sudo systemctl enable postgresql
```

---

### Step 9: **Verify PostgreSQL Installation**
Check if the PostgreSQL service is running:
```bash
sudo systemctl status postgresql
```
