# Windows Server and Active Directory for Operators

## Active Directory basics

| Term | Meaning |
|------|---------|
| Domain controller (DC) | Server that holds AD and authenticates users and computers (Kerberos) |
| OU | Organisational unit: a folder for users/computers, used to apply Group Policy and delegate admin |
| Security group | Grants permissions; add users to groups, groups to resources |
| GPO | Group Policy Object: settings pushed to users/computers |
| FSMO roles | Special single-master roles held by specific DCs (e.g. PDC emulator, the time source) |

## "User can't log in"

1. Account state: locked, disabled, expired, password expired?
   ```powershell
   Get-ADUser jdoe -Properties LockedOut, Enabled, PasswordExpired, PasswordLastSet, LastLogonDate, BadLogonCount
   Unlock-ADAccount jdoe          # only if the procedure allows
   ```
2. Can the machine reach a DC? `nltest /dsgetdc:corp.local`, `Test-ComputerSecureChannel`
3. **Time**: Kerberos fails if clocks differ by more than 5 minutes. `w32tm /query /status`
4. DNS: clients must use AD DNS servers to find DCs (`nslookup -type=SRV _ldap._tcp.dc._msdcs.corp.local`).
5. DC security log: event **4625** (failed logon, with a failure reason), **4740** (account locked out, shows the source computer).

## Group Policy

```powershell
gpupdate /force
gpresult /r                     # which GPOs applied to user and computer
gpresult /h report.html         # detailed HTML report
```

## Health checks

```powershell
dcdiag /q                        # DC health, only errors
repadmin /replsummary            # replication status between DCs
Get-Service NTDS, DNS, Netlogon, W32Time, KDC
```

## Useful event IDs

| ID | Log | Meaning |
|----|-----|---------|
| 4624 / 4625 | Security | Successful / failed logon |
| 4740 | Security | Account locked out |
| 4720 / 4726 | Security | Account created / deleted |
| 7031 / 7034 | System | Service crashed |
| 1074 / 6008 | System | Planned restart (who and why) / unexpected shutdown |
| 41 | System (Kernel-Power) | Rebooted without clean shutdown |
