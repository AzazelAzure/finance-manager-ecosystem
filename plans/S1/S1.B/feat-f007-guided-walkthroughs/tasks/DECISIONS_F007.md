# F-007 UX Decisions (T00.SL3)

Date: 2026-05-04

1. **Single entry (Help mode vs direct Joyride vs hybrid)**: 
   - **Decision:** Hybrid approach.
   - **Details:** Re-use Joyride code where possible. Being able to bring up a specific Joyride note for each widget is best.

2. **Auto-start tours**:
   - **Decision:** On by default for new users.
   - **Details:** Allow users to bypass it. Add an option in the profile settings to retake the Joyride tours.

3. **Repeatable form tours**:
   - **Decision:** Always repeatable.
   - **Details:** Use `force: true` for form-based tours so they can always be re-triggered by the user.
