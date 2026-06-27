# T01 — Email FROM Address Routing

## End State
`notify_operator` sends FROM the correct domain alias based on event type. Bug reports arrive FROM `bugreport@thehivemanager.com`, feature requests FROM `featurerequest@thehivemanager.com`, all system events FROM `noreply@thehivemanager.com`. Verified in Proton inbox headers.

## Acceptance Criteria
1. [V1] Send test BUG_REPORT event → inbox shows `From: bugreport@thehivemanager.com`
2. [V1] Send test FEATURE_REQUEST event → inbox shows `From: featurerequest@thehivemanager.com`
3. [V1] Send test DAU_THRESHOLD_CROSSED event → inbox shows `From: noreply@thehivemanager.com`
4. [V1] If any FROM swap is rejected by Proton Bridge SMTP: **STOP, do not proceed, report to HitM**

## Slice Decomposition

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T01.SL1 | FROM routing + smoke test | V1 | Add FROM mapping to `notify_operator`; send three test emails; verify headers |

## Scope Lock

### FROM address map (add to `notify.py`)
```python
FROM_ADDRESS_MAP = {
    "BUG_REPORT": "bugreport@thehivemanager.com",
    "FEATURE_REQUEST": "featurerequest@thehivemanager.com",
}
DEFAULT_FROM = "noreply@thehivemanager.com"

def get_from_address(event_type: str) -> str:
    return FROM_ADDRESS_MAP.get(event_type, DEFAULT_FROM)
```

### Updated `notify_operator` send call
```python
mail.send_mail(
    subject=subject,
    message=body,
    from_email=get_from_address(event_type),   # was: settings.DEFAULT_FROM_EMAIL
    recipient_list=[settings.OPERATOR_EMAIL],
    fail_silently=False,
)
```

### Proton Bridge verification
Proton Bridge SMTP token is expected to authorize sending FROM any alias on the `thehivemanager.com` domain. Before marking T01.SL1 PASS, send a live test email FROM each address and verify the `From:` header in Proton inbox. If Bridge rejects any address with an auth error, stop immediately.

**Do not** add `support@thehivemanager.com` to the FROM map — reserved for future customer-facing outbound.

## Evidence
- `evidence/T01.SL1_bugreport_inbox.png` — [V1] Proton inbox header showing `From: bugreport@`
- `evidence/T01.SL1_featurerequest_inbox.png` — [V1] Proton inbox header showing `From: featurerequest@`
- `evidence/T01.SL1_noreply_inbox.png` — [V1] Proton inbox header showing `From: noreply@`
