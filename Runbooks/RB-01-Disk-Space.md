# RB-01: Disk space alert on a server

| Field | Value |
|-------|-------|
| Trigger | Disk usage ≥ 85% (WARNING) or ≥ 95% (CRITICAL) |
| Default priority | P4 at WARNING, P3 at CRITICAL, P2 if the service is already failing |
| Owner team | Server team for the CI (see CMDB) |

## 1. Acknowledge and assess

- Acknowledge the alert so the team knows it's owned.
- Which server, which volume, what does the server run? Is the service still working?
- **How fast is it growing?** Compare with the last 24 hours. "95% and flat" is very different from "95% and +2% per hour".

## 2. Investigate (read-only)

Windows:
```powershell
.\Get-DiskAlert.ps1 -ComputerName SRV01
Get-ChildItem D:\ -Directory | ForEach-Object {
  [pscustomobject]@{ Folder = $_.FullName; GB = [math]::Round((Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum / 1GB, 2) }
} | Sort-Object GB -Descending | Select-Object -First 10
```

Linux:
```bash
df -h            # which filesystem
df -i            # inodes (full inodes also give "No space left on device")
du -xh /var --max-depth=2 2>/dev/null | sort -rh | head -15
lsof +L1         # deleted files still held open by a process (space not freed)
```

## 3. Act within procedure

- **Allowed**: run the documented clean-up for that server (e.g. rotate/compress logs older than N days, clear the application's temp folder).
- **Not allowed**: deleting data you don't own, database files, or anything not in the procedure.
- Deleted files still held open (`lsof +L1`): the owning service must be restarted by the owner team to free the space.

## 4. Escalate

If there's no procedure, or it's growing fast: escalate to the owner team with server, volume, %, growth rate, top folders, and the estimated time until full.

## 5. Close

Confirm usage is below threshold in monitoring. Record the cause (e.g. log rotation failed). Raise a problem if it recurs.
