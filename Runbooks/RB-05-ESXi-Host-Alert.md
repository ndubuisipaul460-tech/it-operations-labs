# RB-05: VMware ESXi host or datastore alert

| Field | Value |
|-------|-------|
| Trigger | Host not responding, host CPU/memory > 90%, datastore > 90%, HA event |
| Default priority | Host down: P2 (HA should restart VMs; check they did). Datastore full: P2 (VMs can freeze) |

## 1. Assess (vCenter)

- **Host not responding**: which VMs were on it? Did **HA** restart them on other hosts? Are they up?
- **Host CPU/memory high**: which VMs are using it? Did a change or new workload start?
- **Datastore space**: % used, growth rate, and **old snapshots** (a common cause: snapshots grow until the datastore fills).

## 2. Investigate

- vCenter → host → Monitor → Performance (CPU ready %, memory ballooning/swapping).
- vCenter → datastore → VMs → look for VMs with snapshots and their age.
- Events and tasks around the alert time (vMotion, snapshot, patch, change).

## 3. Act within procedure

- Allowed actions depend on the runbook: e.g. **vMotion** a busy VM to a less loaded host, or ask the VM owner to delete an old snapshot.
- If it follows a change: contact the change owner; the rollback plan may revert VMs from snapshots.

## 4. Escalate

To the VMware/virtualisation team with host, cluster, affected VMs, metrics and timeline.

## 5. Close

Host and VMs healthy in vCenter and monitoring; snapshots cleaned up by their owners; cause recorded.

## Terms

| Term | Meaning |
|------|---------|
| ESXi | Hypervisor installed on each physical host |
| vCenter | Central management for hosts, clusters and VMs |
| HA | Restarts VMs on surviving hosts if a host fails |
| DRS | Balances VMs across hosts automatically |
| vMotion | Moves a running VM to another host with no downtime |
| Snapshot | Point-in-time state of a VM; **not a backup**, and it grows over time |
