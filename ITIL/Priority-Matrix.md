# Priority Matrix

Priority = **Impact** × **Urgency**.

|                     | Urgency: High (business stopped now) | Urgency: Medium (degraded, workaround) | Urgency: Low (can wait) |
|---------------------|------|------|------|
| **Impact: High** (many customers, critical service) | **P1** | **P2** | **P3** |
| **Impact: Medium** (one department, one site) | **P2** | **P3** | **P4** |
| **Impact: Low** (one user) | **P3** | **P4** | **P4** |

## Examples (banking context)

| Situation | Impact | Urgency | Priority |
|-----------|--------|---------|----------|
| Card payments failing for all customers | High | High | P1 |
| Mobile banking login slow for everyone, still works | High | Medium | P2 |
| Overnight statement batch late, deadline 06:00, now 05:15 | High | High | P1 (deadline risk) |
| One branch's network down, other branches fine | Medium | High | P2 |
| Monitoring server disk at 85%, growing slowly | Low | Low | P4 |
| One user can't print | Low | Low | P4 |

## Rules of thumb

- Priority can **change**: re-assess when impact grows (a P3 that spreads to many users becomes P2/P1).
- When unsure between two levels, choose the higher one and let the Incident Manager lower it.
- When several incidents arrive together, handle the highest priority first, but **every** incident still gets an owner and a status.
