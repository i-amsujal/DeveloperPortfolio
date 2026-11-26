# Beginner Developer Ecosystem Portfolio (`cs-fundamental`)

A foundational Computer Science and Software Engineering portfolio covering core Linux operations, Bash shell automation, Python REST API integration, and a structured 6-month developer learning roadmap.

---

## Repository Structure

```text
cs-fundamental/
├── Linux/
│   └── system_profile_and_commands.md   # Q1: System profile & Linux CLI reference
├── ShellScripts/
│   ├── system_info.sh                   # Q2: System diagnostics & resource report script
│   ├── backup_script.sh                 # Q2: Automated compressed backup utility (.tar.gz)
│   └── file_organizer.sh                # Q2: Extension-based directory file organizer
├── API/
│   ├── fetch_api.py                     # Q3: Standard-library Python REST API client
│   └── response.json                    # Q3: Parsed JSON payload saved from the API
├── Portfolio/
│   ├── learning_roadmap.md              # Q4: 6-month beginner developer learning plan
│   └── README.txt                       # Q4: Reminder for Resume.pdf & linkedin_profile.png
├── Screenshots/
│   └── README.md                        # Checklist of terminal & profile screenshots to add
└── README.md                            # Project overview, usage instructions & links
```

---

## Module Overview (Q1–Q4 & Screenshots)

| Module | Folder | Description |
| :--- | :--- | :--- |
| **Q1** | [`Linux/`](Linux/system_profile_and_commands.md) | Documents a sample Linux workstation profile and essential commands across file navigation, permissions (`chmod`, `chown`), process management (`ps`, `top`, `kill`), networking (`ip`, `ss`, `ping`, `curl`), and disk usage (`df`, `du`, `free`) with example outputs. |
| **Q2** | [`ShellScripts/`](ShellScripts/) | Contains three executable, well-commented Bash automation scripts (`system_info.sh`, `backup_script.sh`, `file_organizer.sh`) featuring proper `#!/bin/bash` shebangs, argument validation, help flags, and safe error handling. |
| **Q3** | [`API/`](API/) | Contains [`fetch_api.py`](API/fetch_api.py), a zero-dependency Python 3 script that queries a public REST API, parses and summarizes the JSON response, and writes formatted output to [`response.json`](API/response.json). |
| **Q4** | [`Portfolio/`](Portfolio/) | Contains [`learning_roadmap.md`](Portfolio/learning_roadmap.md) outlining a 24-week roadmap across Linux, Git, Python, Web Development, and Capstone projects, alongside [`README.txt`](Portfolio/README.txt) tracking `Resume.pdf` and `linkedin_profile.png`. |
| **Docs** | [`Screenshots/`](Screenshots/README.md) | Lists the required terminal, script execution, API output, and GitHub profile screenshots to capture and place in this directory. |

---

## Prerequisites

- **Linux / macOS / WSL / Git Bash (Windows):** Bash 4+ with standard core utilities (`tar`, `df`, `uname`, `date`).
- **Python 3.8+:** Uses only the Python standard library (`urllib.request`, `json`, `argparse`, `pathlib`) — no third-party `pip` packages required.

---

## How to Run the Scripts

### 1. Running the Bash Scripts (`ShellScripts/`)

First, make the scripts executable (Linux / macOS / WSL / Git Bash):

```bash
chmod +x ShellScripts/*.sh
```

#### System Info Report (`system_info.sh`)
Displays OS, kernel, user/host, uptime, CPU, memory, and disk usage summary. Optionally pass `-o <file>` to save the report:

```bash
./ShellScripts/system_info.sh
# Or save the output to a text file:
./ShellScripts/system_info.sh -o /tmp/system_report.txt
```

#### Automated Backup (`backup_script.sh`)
Archives a target directory into a timestamped `.tar.gz` bundle inside a destination folder:

```bash
# Usage: ./ShellScripts/backup_script.sh <source_dir> [backup_dest_dir]
./ShellScripts/backup_script.sh ./Linux /tmp/backups
```

#### File Organizer (`file_organizer.sh`)
Sorts files inside a target directory into categorized folders (`Documents`, `Images`, `Code`, `Archives`, `Media`, `Logs`, `Others`). Supports `--dry-run` to preview changes safely before moving files:

```bash
# Preview changes without moving files:
./ShellScripts/file_organizer.sh --dry-run /path/to/messy_folder

# Organize files in place:
./ShellScripts/file_organizer.sh /path/to/messy_folder
```

> **Windows Note:** Run `.sh` scripts inside **WSL** or **Git Bash** (`"C:\Program Files\Git\bin\bash.exe" ShellScripts/system_info.sh`).

---

### 2. Running the Python API Script (`API/`)

Run `fetch_api.py` from the repository root or directly inside `API/`:

```bash
python3 API/fetch_api.py
```

Optional flags:

```bash
# Query a custom public REST API endpoint or save to a custom file
python3 API/fetch_api.py --url https://jsonplaceholder.typicode.com/users --limit 5 --output API/response.json

# View all CLI options
python3 API/fetch_api.py --help
```

On Windows, replace `python3` with `python` if `python3` is not aliased.

---

## Connect & Profiles

- **GitHub:** [https://github.com/&lt;your-github-username&gt;](https://github.com/your-github-username) *(replace with your GitHub profile URL)*
- **LinkedIn:** [https://www.linkedin.com/in/&lt;your-linkedin-handle&gt;](https://www.linkedin.com/in/your-linkedin-handle) *(replace with your LinkedIn profile URL)*
- **Resume & Profile Snapshot:** Place `Resume.pdf` and `linkedin_profile.png` inside [`Portfolio/`](Portfolio/README.txt).
