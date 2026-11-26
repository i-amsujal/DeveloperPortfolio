# Screenshots Checklist

Add visual proof of your environment setup, script executions, API responses, and online developer profiles in this directory.

## Required Screenshots

| # | Suggested Filename | What to Capture | Command / Location |
| :--- | :--- | :--- | :--- |
| 1 | `01_linux_commands.png` | Terminal session showing system profile and common Linux commands (`uname -a`, `ls -la`, `df -h`, `ps aux`) | Linux / WSL / Git Bash terminal |
| 2 | `02_system_info_script.png` | Execution output of `system_info.sh` showing formatted system diagnostics | `bash ShellScripts/system_info.sh` |
| 3 | `03_backup_and_organizer.png` | Terminal output running `backup_script.sh` and `file_organizer.sh` on sample test data | `bash ShellScripts/backup_script.sh ...` |
| 4 | `04_api_execution.png` | Running `fetch_api.py` and inspecting the generated `API/response.json` output | `python API/fetch_api.py` |
| 5 | `05_github_profile.png` | Browser screenshot of your GitHub profile and pinned `cs-fundamental` repository | `https://github.com/<your-username>` |

## Checklist Before Submitting / Publishing

- [ ] `01_linux_commands.png` — Terminal outputs clearly readable (good contrast, no cropped text)
- [ ] `02_system_info_script.png` — `system_info.sh` ran cleanly with exit code `0`
- [ ] `03_backup_and_organizer.png` — Both automation scripts demonstrated safely
- [ ] `04_api_execution.png` — Python REST API execution and JSON output captured
- [ ] `05_github_profile.png` — GitHub profile & repository visible (redact any private tokens or sensitive info)
