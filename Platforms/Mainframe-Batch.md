# Mainframe and Batch for Operators

Banks still run core processing (accounts, payments, statements) on IBM Z mainframes, and much of it as overnight **batch**. An operations centre watches that the batch finishes on time and that online systems stay available.

## Terms

| Term | Meaning |
|------|---------|
| z/OS | Main IBM mainframe operating system |
| Batch job | Program that runs without user interaction, often overnight, processing large volumes |
| JCL | Job Control Language: defines the job's steps, programs and data sets |
| Step | One program execution within a job |
| Return code (RC) | Result of a step: 0 OK, 4 warning, 8 error, 12/16 severe |
| ABEND | Abnormal end, with a system (Sxxx) or user (Uxxxx) code |
| Spool / JES | Where job output and logs are kept (SDSF to view them) |
| Data set | A mainframe file |
| CICS | Online transaction system (real-time customer transactions) |
| DB2 | IBM relational database on z/OS |
| MQ | Messaging between mainframe and distributed systems |
| Scheduler | Runs jobs in order with dependencies and time windows (e.g. Control-M, IBM Workload Scheduler) |

## Common ABEND codes

| Code | Usual meaning |
|------|---------------|
| S0C7 | Data exception: bad (non-numeric) data in a numeric field, often a bad input file |
| S0C4 | Protection exception: program addressed storage it shouldn't |
| S322 | Job or step exceeded its CPU time limit |
| S806 | Program module not found |
| S913 | Not authorised to a data set (security) |
| SB37 / SD37 / SE37 | Out of space on a data set |

## What an operator watches

- Critical-path jobs finishing before their **deadline**
- Failed or abended jobs, and jobs **waiting** too long on a dependency or an input file
- Message queue depth between the mainframe and other systems (a growing queue means something downstream isn't consuming)
- Online availability: CICS regions up, transactions responding

## When something fails

See [RB-03 Batch job failure](../Runbooks/RB-03-Batch-Job-Failure.md): read the job log, find the step and RC/ABEND, check what's waiting and the deadline, follow the rerun rules exactly, escalate early when a deadline is at risk.
