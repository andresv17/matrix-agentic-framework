# Privacy, Data Rights & Lifecycle — Playbook of Rama-Kandra

> Custody criteria for sensitive data, atomic account deletion, and deterministic data portability.

## 1. Data Minimization & Lifecycle (Zero Data Hoarding)
- **Purging Temporary Footprints:** Revoked and expired sessions (`sessions`), stale failed login attempts (`login_attempts`), and temporary deletion-intent tokens must be purged periodically; never accumulate dead authentication data without expiry.
- **Strict Redaction in Logging & Auditing:** Never persist passwords, cryptographic hashes, opaque session tokens, session cookies, or personal emails into application logs or RFC 9457 error traces.

## 2. Right to Be Forgotten — Account Deletion (`DELETE /users/me`)
- **Mandatory Preconditions Before Deletion:**
  1. Verify the user is not the sole owner of a shared workspace or account with other active members (explicitly block until ownership is transferred via `TRANSFER_OWNERSHIP` or the shared entity is emptied/dissolved).
  2. Require/offer prior full data export (`deletion-intent`) + re-authentication + explicit confirmation text (`"DELETE MY ACCOUNT"`).
- **Atomic Cascade & Anonymized Audit Trail:** Deletion of an account, its sessions, owned resources, and records must execute within a single transaction; any failure midway restores everything byte for byte. If the system retains operational audit records post-deletion, it must record **solely the irreversible canonical hash of the identifier** (with no names, emails, or usernames preserved).

## 3. Portability & Multi-Version Backups
- When exporting per assigned role (`RBAC`), the backup envelope contains only entities visible to the user within permitted boundaries and **never** includes personal data or credentials of third parties.
- When importing (`Idempotent Merge` or `Destructive Replace`), the pre-validation step must report record counts and key collisions before mutating storage, guaranteeing byte-by-byte rollback upon any validation failure.
