# 6-Month Beginner Developer Learning Roadmap

A structured, milestone-driven 24-week curriculum designed to build strong foundations across **Linux**, **Git & GitHub**, **Python**, **Web Development**, and **Real-World Projects**.

---

## Overview Timeline

| Month | Focus Area | Primary Outcome |
| :--- | :--- | :--- |
| **Month 1** | Linux & Command-Line Fundamentals | Confidently navigate the shell, manage permissions, processes, and Bash scripts |
| **Month 2** | Git, GitHub & Developer Workflow | Master version control, branching, pull requests, and collaborative workflows |
| **Month 3** | Python Programming & Automation | Write clean Python scripts, work with files, APIs, JSON, and error handling |
| **Month 4** | Web Development Foundations (Frontend) | Build responsive, accessible web pages using HTML5, CSS3, and modern JavaScript |
| **Month 5** | Backend Web Development & Databases | Build REST APIs, connect SQL/SQLite databases, and understand client-server architecture |
| **Month 6** | Capstone Projects & Career Portfolio | Ship 2–3 end-to-end projects, polish documentation, resume, and GitHub/LinkedIn |

---

## Month 1: Linux & Command-Line Fundamentals

**Goal:** Become comfortable working inside a terminal environment and automating routine OS tasks.

- **Weeks 1–2: Shell Navigation & Filesystem**
  - Understand directory hierarchy (`/home`, `/etc`, `/var`, `/tmp`), relative vs. absolute paths.
  - Practice `pwd`, `ls`, `cd`, `mkdir`, `cp`, `mv`, `rm`, `find`, `grep`, `cat`, `less`.
  - Learn input/output redirection (`>`, `>>`, `<`, `|`) and standard streams (`stdin`, `stdout`, `stderr`).
- **Week 3: Permissions, Processes & Networking**
  - Master `chmod` (symbolic & octal), `chown`, `ps`, `top`, `kill`, `df -h`, `du -sh`, `ip a`, `ss`, `curl`.
  - Inspect environment variables (`env`, `export`, `$PATH`).
- **Week 4: Bash Scripting Basics**
  - Write scripts using `#!/bin/bash`, variables, conditionals, loops, functions, and exit codes.
  - **Mini-Project:** Build system monitoring, backup archiving, and file organizer scripts (see `../ShellScripts/`).

**Checkpoint:** Can set up a directory structure, inspect logs, fix file permissions, and automate a backup via Bash without a GUI.

---

## Month 2: Git, GitHub & Developer Environment

**Goal:** Track every change cleanly and collaborate using standard Git workflows.

- **Weeks 5–6: Core Git Mechanics**
  - Configure identity and SSH keys (`git config`, `ssh-keygen`).
  - Practice `git init`, `git status`, `git add`, `git commit`, `git diff`, `git log --oneline --graph`.
  - Learn `.gitignore` best practices and writing clear, atomic commit messages.
- **Weeks 7–8: Branching, Merging & GitHub**
  - Create feature branches (`git switch -c`), resolve merge conflicts, and understand `rebase` vs. `merge`.
  - Fork repositories, open Pull Requests, review diffs, and document repositories with Markdown.
  - **Mini-Project:** Publish this CS Fundamentals portfolio repository to GitHub with clean commit history and documentation.

**Checkpoint:** Can create a feature branch, recover from common mistakes (`git restore`, `git reset`), resolve a merge conflict, and open a clean PR.

---

## Month 3: Python Programming & APIs

**Goal:** Write modular, readable Python programs that process data and interact with external services.

- **Weeks 9–10: Core Python Syntax & Data Structures**
  - Variables, data types, loops, functions, list comprehensions, dictionaries, and sets.
  - Virtual environments (`python -m venv`), package management (`pip`), and code style (`PEP 8`).
- **Weeks 11–12: Files, Exceptions, Testing & REST APIs**
  - Work with `pathlib`, CSV, JSON (`json.load` / `json.dumps`), and structured exception handling (`try/except`).
  - Understand HTTP methods (`GET`, `POST`), status codes (`200`, `404`, `500`), headers, and JSON payloads.
  - Write basic unit tests using `pytest` or `unittest`.
  - **Mini-Project:** Build a CLI API consumer that fetches, parses, and exports REST API responses (see `../API/fetch_api.py`).

**Checkpoint:** Can write a standalone CLI Python tool that consumes a public API, handles network errors gracefully, and outputs structured JSON/CSV.

---

## Month 4: Frontend Web Development (HTML, CSS, JavaScript)

**Goal:** Build responsive, interactive browser interfaces from scratch.

- **Weeks 13–14: Semantic HTML5 & Modern CSS3**
  - Semantic tags (`header`, `nav`, `main`, `section`, `article`, `footer`), forms, and accessibility basics (ARIA, labels, contrast).
  - CSS Box Model, Flexbox, CSS Grid, responsive media queries, and CSS custom properties.
- **Weeks 15–16: JavaScript & DOM Manipulation**
  - Variables (`const`/`let`), arrow functions, arrays (`map`, `filter`, `reduce`), async/await, and `fetch()`.
  - Event listeners, form validation, and dynamically rendering API data in the DOM.
  - **Mini-Project:** Build a responsive Developer Dashboard or Weather/GitHub Profile Viewer using HTML, CSS, and `fetch()`.

**Checkpoint:** Can turn a static wireframe into a mobile-friendly webpage that fetches and displays live JSON data.

---

## Month 5: Backend Development, Databases & Full-Stack Integration

**Goal:** Understand how servers, APIs, and databases work together behind the scenes.

- **Weeks 17–18: Relational Databases & SQL**
  - Tables, primary/foreign keys, relationships (1:1, 1:N, M:N).
  - Queries (`SELECT`, `WHERE`, `JOIN`, `GROUP BY`), inserts/updates, and SQLite/PostgreSQL basics.
- **Weeks 19–20: Building REST APIs with Python (FastAPI or Flask)**
  - Routing, query/path parameters, request validation, JSON responses, and HTTP error codes.
  - Connect backend endpoints to a SQLite database and test endpoints with `curl` or Postman.
  - **Mini-Project:** Build a Task Tracker / Bookmark Manager REST API with CRUD endpoints and persistent storage.

**Checkpoint:** Can design a normalized 2–3 table schema and expose CRUD endpoints backed by a database.

---

## Month 6: Capstone Projects, Deployment & Portfolio Polish

**Goal:** Synthesize all skills into deployable projects and prepare for internships or junior roles.

- **Weeks 21–22: Capstone Project Build & Deployment**
  - Combine Frontend + Backend API + Database + Automated Testing into one cohesive application.
  - Containerize or deploy to a cloud platform (e.g., Render, Railway, Fly.io, or GitHub Pages for static frontends).
  - Add CI checks (GitHub Actions for linting and running tests on push).
- **Weeks 23–24: Portfolio, Resume & Interview Prep**
  - Write strong project READMEs with architecture diagrams, setup commands, and screenshots.
  - Finalize `Resume.pdf`, optimize GitHub pinned repositories, and align LinkedIn profile.
  - Practice foundational Data Structures & Algorithms (arrays, hash maps, strings, recursion, basic time/space complexity).

**Checkpoint:** Ready to share a public GitHub portfolio with live projects, clean documentation, and an up-to-date resume.

---

## Personal Progress Tracker

- [ ] **Month 1:** Completed Linux command practice and all `ShellScripts/` automations
- [ ] **Month 2:** Pushed repository cleanly to GitHub with descriptive commits
- [ ] **Month 3:** Executed `API/fetch_api.py` and added unit tests
- [ ] **Month 4:** Built and deployed first responsive HTML/CSS/JS frontend app
- [ ] **Month 5:** Built a CRUD REST API connected to SQLite/PostgreSQL
- [ ] **Month 6:** Completed Capstone project, updated `Resume.pdf`, and linked GitHub & LinkedIn
