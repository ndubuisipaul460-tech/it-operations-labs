# RB-03: Overnight batch job failed or running late

| Field | Value |
|-------|-------|
| Trigger | Scheduler shows job ABENDED / failed, non-zero return code, or job not finished by its expected time |
| Default priority | Depends on the job's **deadline** and what depends on it. Critical-path job at risk of missing a business deadline: P1/P2 |

## Key ideas

- Batch jobs run in **chains**: a failed job blocks every job after it.
- Each critical chain has a **deadline** (e.g. statements before the bank opens). Time to deadline drives urgency.
- Mainframe steps return a **return code (RC)**: RC 0 OK, RC 4 warning, RC 8+ error; an **ABEND** code (e.g. S0C7 data exception, S322 time limit exceeded, S806 module not found) means the step ended abnormally.

## 1. Assess

- Which job, which chain, which step failed? Return code or ABEND code?
- What is waiting on it, and what is the deadline? How long does the rest of the chain need?

## 2. Investigate

- Read the job log / spool output for the failing step (error messages, RC, ABEND).
- Did it fail at the same step before? Check the known error database and previous incidents.
- Any change last night (new code, new input file, schedule change)?
- Was the input file missing or late (upstream dependency)?

## 3. Act within procedure

- The runbook for that job says if a **rerun / restart from step** is allowed. Follow it exactly.
- Never edit JCL, data sets or schedules yourself; that's the owner team's change.

## 4. Escalate

If no rerun is allowed, the rerun fails, or the deadline is at risk: escalate **immediately** to the batch on-call team, and to the Incident Manager if a business deadline will be missed. Include job name, step, RC/ABEND, time, downstream impact and time to deadline.

## 5. Close

Confirm the chain completed and downstream jobs ran. Note the cause; a repeat failure becomes a problem record.
