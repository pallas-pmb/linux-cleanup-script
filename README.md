# 🧹 Multi-Distro Linux Cleanup Scripts

A collection of safe and effective Linux cleanup scripts tailored for different distributions and setups — designed to free up disk space, remove unnecessary files, and keep your system lean.

## 🚀 Supported Distributions (and growing!)

- **EndeavourOS / Arch Linux**
- _(More distros coming soon!)_

## 📂 Repository Structure

/
├── endeavouros-cleanup.sh # Cleanup script for EndeavourOS / Arch
├── ubuntu-cleanup.sh # (Planned) Cleanup for Ubuntu/Debian
├── fedora-cleanup.sh # (Planned) Cleanup for Fedora/RHEL
├── scripts/ # Helper scripts and shared utilities
└── README.md # This file

## 🎯 Goals

- Provide easy-to-use, safe cleanup scripts optimized per distro
- Encourage contribution of new distros and cleanup ideas
- Support advanced options like dry-run, verbose output, and scheduled cleanup

---

## 🧼 How to Use

### 1. Choose your distro’s script

Each distro has its own cleanup script tailored to package managers, log locations, and common caches.

Example: For EndeavourOS / Arch, use:

```bash
chmod +x endeavouros-cleanup.sh
./endeavouros-cleanup.sh
```

2. Review the script

Always review the script before running it — these scripts delete files and remove packages.

3. Automate (optional)

Use systemd timers (user or system-wide) to run cleanup automatically. See the example systemd service and timer files included in the endeavouros-cleanup.sh script or the documentation section.

🕒 Automate Cleanup with systemd Timer (Example)

You can schedule your cleanup script to run automatically using a systemd user timer.
Steps:

    Move the script to a fixed location:

```bash
mkdir -p ~/.local/bin
mv endeavouros-cleanup.sh ~/.local/bin/
chmod +x ~/.local/bin/endeavouros-cleanup.sh
```

Create a systemd service file at ~/.config/systemd/user/endeavour-cleanup.service:

```ini
[Unit]
Description=EndeavourOS Cleanup Script

[Service]
Type=oneshot
ExecStart=%h/.local/bin/endeavouros-cleanup.sh
```

Create a systemd timer file at ~/.config/systemd/user/endeavour-cleanup.timer:

```ini
[Unit]
Description=Weekly EndeavourOS Cleanup

[Timer]
OnCalendar=Sun *-*-* 03:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

Enable and start the timer:

```bash
systemctl --user daemon-reload
systemctl --user enable --now endeavour-cleanup.timer
```

Check timer status and next run:

```bash
systemctl --user status endeavour-cleanup.timer
systemctl --user list-timers
```

---

## 🛠 Contributing

Want to add a cleanup script for your distro or improve existing ones?

    Fork the repository.

    Add your script following the naming convention <distro>-cleanup.sh.

    Update this README to include your distro.

    Open a Pull Request — your contribution is welcome!

## 📋 Roadmap

    Add Ubuntu/Debian cleanup script.

    Add Fedora/CentOS/RHEL cleanup script.

    Support container runtimes like Podman and containerd.

    Add CLI argument parsing (--dry-run, --verbose, --force).

    Add logging to files and email reports.

    Set up GitHub Actions for automated script testing.

---

## ⚠️ Disclaimer

Use these scripts at your own risk. Always backup important data before running any cleanup tool. Test scripts carefully, especially on production machines.

## 📜 License

MIT © Your Name

---

## 🧹 About the Cleanup Scripts

All cleanup scripts in this repository are designed to be:

- **Safe by default:** Scripts avoid deleting critical system files and use package manager commands for safe removal of unnecessary packages and caches.
- **Distro-aware:** Each script is tailored to the package manager, log locations, and cache directories of its target distribution.
- **Transparent:** Actions are printed to the terminal before execution, and most scripts support a dry-run mode to preview changes.
- **Modular:** Shared logic and helpers are placed in the `scripts/` directory for easy reuse and extension.

### What the scripts do

- Clean package manager caches (e.g., pacman, apt, dnf)
- Remove old log files and journal entries
- Delete orphaned packages and unused dependencies
- Clear thumbnail and user cache directories
- Optionally remove old kernels (where safe)
- Print a summary of freed disk space

### What the scripts do **not** do

- Do not remove user data, home directory files, or personal documents
- Do not touch system configuration files outside of safe cleanup areas
- Do not run dangerous commands without explicit user confirmation

Each script includes comments and usage instructions. Please review and test scripts before running them, especially on production systems.
