# Pipeline queue files (`next_queue_message_path`)

The Slack bridge [`scripts/sprint_slack_pipeline_bridge.py`](../../../../../scripts/sprint_slack_pipeline_bridge.py) reads **`next_queue_message_path`** relative to env **`SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR`** (point this directory at `…/feat-f007-walkthrough-polish/evidence/pipeline_queue`).

Each file is **raw Slack text** for the **next** top-level `#sprint-queue` post — it must already match **`sprint-queue-v1`** (`@CursorPA`, `Task Id:`, …).

Example filenames: `next_t00_sl2.txt`, `next_t01_sl1.txt`

1. Write the next slice message **before** the executor emits `READY_FOR_REVIEW` for the current slice (or update the file path in that JSON).
2. Keep one slice per file; rotate or delete after successful post if you want to avoid accidental reuse.
