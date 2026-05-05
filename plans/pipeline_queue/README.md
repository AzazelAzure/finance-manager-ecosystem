# Shared pipeline queue (`next_queue_message_path`)

Cross-plan directory for [`scripts/sprint_slack_pipeline_bridge.py`](../../scripts/sprint_slack_pipeline_bridge.py): each file here is **raw Slack text** for the **next** top-level `#sprint-queue` post. Content must match **`sprint-queue-v1`** (`@CursorPA`, `Task Id:`, …). Spec: [`governance/sprint_queue_message_spec_v1.md`](../../governance/sprint_queue_message_spec_v1.md) §Machine-readable pipeline.

## Bridge host

Point **`SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR`** at this directory (tilde-expanded absolute path is fine):

```bash
export SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR="$HOME/Documents/python/finance_manager/plans/pipeline_queue"
```

`next_queue_message_path` in `SPRINT_PIPELINE_JSON` is a **filename only** (or path segments) resolved **under** that base — never absolute paths outside the base.

## Naming

When several plans use the same host, prefix queue files so names do not collide (e.g. `f007_next_t00_sl2.txt`, `f011_next_t01_sl1.txt`). Same-plan slices can keep short names like `next_t00_sl2.txt` if only one active sprint uses the queue.

## Workflow

1. Write the next slice message **before** the executor emits `READY_FOR_REVIEW` for the current slice (or update the path in that JSON).
2. One slice per file; delete or archive after a successful post if you want to avoid accidental reuse.

Emit **`READY_FOR_REVIEW`** without a Slack thread paste: **`SPRINT_PIPELINE_LOCAL_INBOX`** + [`scripts/sprint_pipeline_emit_ready.py`](../../scripts/sprint_pipeline_emit_ready.py).
