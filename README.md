# Log Archive Tool

A Bash command-line tool that compresses a log directory into a timestamped `.tar.gz` archive and records each run in a log file.

Servers generate logs constantly. Archiving them keeps disks clean while preserving the history for debugging and audits.

## Features

- Takes any log directory as an argument
- Validates input: shows a usage message if no directory is given, and an error if it doesn't exist
- Compresses the directory into a `.tar.gz` file named with the date and time, e.g. `logs_archive_20261015_105945.tar.gz`
- Stores archives in a separate `archives/` folder (created automatically)
- Appends a line for every archive to `archives/archive.log`
- Exits with an error, and logs nothing, if compression fails

## Usage

```bash
chmod +x log-archive.sh
./log-archive.sh <log-directory>
```

Examples:

```bash
./log-archive.sh test-logs
sudo ./log-archive.sh /var/log     # system logs need root to read
```

## Sample Output

```
$ ./log-archive.sh test-logs
Archiving: test-logs
Timestamp: 20261015_105945
Archive name: logs_archive_20261015_105945.tar.gz
Created: archives/logs_archive_20261015_105945.tar.gz
```

`archives/archive.log` after a few runs:

```
2026-10-15 10:59:16 - Archived test-logs to logs_archive_20261015_105916.tar.gz
2026-10-15 10:59:18 - Archived test-logs to logs_archive_20261015_105918.tar.gz
2026-10-15 10:59:45 - Archived test-logs to logs_archive_20261015_105945.tar.gz
```

Error cases:

```
$ ./log-archive.sh
Usage: ./log-archive.sh <log-directory>

$ ./log-archive.sh fake-folder
Error: directory 'fake-folder' does not exist
```

To see what's inside an archive without extracting it:

```bash
tar -tzf archives/logs_archive_20261015_105945.tar.gz
```

## How It Works / Notes

- **Two date formats, on purpose.** Filenames use `20261015_105945`: no spaces (which break shell commands unless quoted), no colons (not allowed in Windows filenames), and alphabetical order equals chronological order, so `ls` lists archives oldest to newest. The log uses `2026-10-15 10:59:45` because people read it.
- **`>>` instead of `>`.** The log line is appended with `>>`, so every run is kept. `>` would overwrite the file and keep only the last entry.
- **Failure check on `tar`.** `tar` runs inside an `if`, so a failure (permission denied, full disk) stops the script with an error instead of reporting success. A log that records failures as successes is worse than no log.
- **Input validation first.** Both checks (`-z` for a missing argument, `! -d` for a missing directory) run before any work is done, and exit with code `1` so other scripts or cron can detect the failure.
- **`mkdir -p`** creates the archive folder only if it doesn't already exist, so the script can run repeatedly.

## Possible Improvements

- Delete archives older than N days (`find archives/ -name '*.tar.gz' -mtime +7 -delete`)
- Run automatically every day with `cron`
- Upload archives to remote storage (e.g. AWS S3)

## Project Source

Built as part of the roadmap.sh DevOps projects: https://roadmap.sh/projects/log-archive-tool

Project URL: https://github.com/SabeehAnsari/log-archive-tool
