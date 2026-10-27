# Change Management

**Goal:** make changes safely: assessed, approved, scheduled, reversible and recorded. In a bank, every production change must be traceable.

## Change types

| Type | Description | Approval |
|------|-------------|----------|
| Standard | Low-risk, repeatable, pre-approved (e.g. adding a user to a group via a template) | Pre-approved model |
| Normal | Assessed individually (e.g. firmware upgrade, schema change) | Change Manager / CAB |
| Emergency | Urgent fix to restore service or prevent major impact | Emergency CAB (fast track), documented afterwards |

## A good change record contains

- Description and business reason
- Affected CIs and services (use the CMDB to find dependencies)
- Risk and impact assessment
- **Implementation plan**, step by step
- **Test / verification plan**: how we know it worked
- **Backout (rollback) plan**, with the decision point and time needed
- Schedule and change window; communication to affected teams

## The operations centre's role

1. **Before**: check monitoring is green, note baseline values, know which alerts are expected during the window.
2. **During**: watch dashboards; separate expected alerts from unexpected ones; tell the implementer immediately about anything unexpected.
3. **After**: confirm services are healthy, close expected alerts, make sure nothing new is firing.
4. **If it goes wrong**: raise it with the change owner early. The rollback plan exists to be used; invoking it before the window ends is better than hoping it fixes itself.

## Why so many incidents follow changes

Every change adds risk. That's why the first question in any incident is **"what changed recently?"**, and why the change calendar is open on the operations centre screen.
