# MagTapp Pro — Full-Stack Flutter + Spring Boot Prototype

A full-stack prototype for introducing a paid **MagTapp Pro subscription**.

The project demonstrates:

- Flutter mobile application architecture
- Spring Boot REST API
- JWT authentication
- PostgreSQL persistence
- User accounts
- Subscription management
- Order and payment flow
- Backend-controlled Pro entitlement
- Payment state handling
- Database auditing
- Basic production-oriented architecture

---

# 1. Project Overview

The goal of this prototype is to introduce a paid subscription for MagTapp Pro.

Pro plans:

| Plan | Price |
|------|-------|
| Free | ₹0 |
| Pro Monthly | ₹99/month |
| Pro Monthly | ₹299/month |

The prototype focuses primarily on the backend subscription/payment flow and the architectural decisions required to safely manage Pro entitlements.

The client does not decide whether a user is Pro.

The backend is the source of truth for:

- Payment status
- Order status
- Subscription status
- Subscription expiry
- Pro entitlement

---

# 2. Architecture

The overall architecture is:

```text
┌──────────────────────┐
│      Flutter App     │
│                      │
│ Auth / Subscription  │
│      / Payment       │
└──────────┬───────────┘
           │ HTTPS + JWT
           ▼
┌──────────────────────┐
│    Spring Boot API   │
│                      │
│ Authentication       │
│ User                 │
│ Order                │
│ Payment              │
│ Subscription         │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│      PostgreSQL      │
│                      │
│ users                │
│ orders               │
│ payments             │
│ subscriptions        │
└──────────────────────┘
```

## 3. AWS Cost & Production Approach

Since I don't have access to MagTapp's production AWS account, I would first understand the existing infrastructure before making any changes.

My first steps would be:

- Check the AWS services currently being used and their monthly costs.
- Review CloudWatch logs and metrics for API errors, latency and resource utilization.
- Check EC2/ECS/RDS usage and identify any clearly underutilized resources.
- Review storage, snapshots and log retention for unnecessary usage.
- Check database performance, connections and slow queries.
- Add basic CloudWatch alarms for high error rates, latency and infrastructure issues.
- Test any infrastructure changes in staging first and monitor production after deployment.
- Avoid removing or resizing anything without confirming its usage and impact.

The goal would be to reduce unnecessary AWS cost while keeping the application stable and reliable.