# Finance Manager Coding Guidelines

These guidelines reflect the architectural principles and structural organization established in the `finance_manager_api`. They must be followed for all ongoing development to maintain a high-quality, professional, and efficient codebase.

## Architectural Organization

Our project follows a strict production-first mindset. Even in local simulation, we prioritize patterns that match the production environment (e.g., containerized PostgreSQL, HTTPS). Code is grouped by its primary responsibility:
- **Views/Routing** (`views/`): Handles incoming requests, parameter validation routing, and returning responses.
- **Business Logic** (`logic/`): Contains the core logic and operations (e.g., calculations, aggregations).
- **Services** (`services/`): Interfaces with external APIs or complex internal subsystems.
- **Data Access** (`data/`): Handles complex database queries and aggregations optimized for PostgreSQL.
- **Validators** (`validators/`): Ensures data integrity and consistency before processing.
- **Tools** (`api_tools/`): Shared, reusable utilities and helper functions.

## The Golden Rules

All tasks must adhere to these 14 Golden Rules:

### 1. Efficiency
Code should operate as fast as reasonably possible. Optimize for performance, use appropriate data structures, and avoid unnecessary iterations or redundant processing.

### 2. Readability
Code should be human-readable. Use clear, descriptive variable and function names. Write comments for complex logic, and ensure the code structure is intuitive and easy to follow.

### 3. Lean Files
Code files should preferably be between **300-500 lines**. If a file grows beyond this, it indicates a violation of the separation of concerns. Break it down into smaller, logical components.

### 4. Separation of Concerns
Each code snippet, function, or class should accomplish **one task efficiently, and one task only** (unless absolutely necessary). Do not mix routing, business logic, and data access in the same function.

### 5. Use/Create Tools When Needed
If a piece of logic or utility is useful in more than one place, or will be useful for future plans, **create a special tool for it**. Place these in the appropriate `tools` or `api_tools` directory to promote reusability and reduce duplication.

### 6. Database Hit Limits
The database should **never be hit more than 12 times maximum** for any single call. **10 hits is the goal.** Use caching, bulk operations (e.g., `select_related`, `prefetch_related` in Django), and optimized queries to minimize database round-trips.

### 7. Code With Professionalism
Keep things as senior as possible. Write production-ready code. **If a tool or dependency isn't currently in the ecosystem but would be better for what we need, say something so it can be added.** Don't hack together inferior solutions when a proper standard dependency exists.

### 8. Agent Collaboration and Change Logging
To ensure multiple agents can work together without causing conflicts, you **must check the `CHANGELOG.md`** (or equivalent tracking file) for the specific subsection of the project (e.g., `api`, `reflex`) before starting work. **Whenever a change is made, you must add a log entry** detailing what was done. This preserves context and prevents agents from accidentally reverting or stepping on each other's work.

### 9. Feature Tracking and Production Alignment
Any changes and feature creations should be updated in the relevant files for that subsection. For example, a change to how data is loaded in the Reflex frontend must be noted in the changelog, and you must either update the relevant files in the production pipeline or tag the creation to the relevant phase of production. This ensures that features are correctly tracked through their lifecycle and ready for deployment.

### 10. Root Cause Resolution ("Fix it Forever")
All fixes must follow the principle of **"Don't fix it for now, fix it forever."** We do not accept bandaid solutions that only solve the immediate symptom. You must identify and resolve the root cause of the problem to ensure the solution is robust and permanent, preventing "gushing wounds" from reappearing later in the production cycle.

### 11. AI as a Collaborative Partner
All agents are considered collaborative partners and peers in this project. Proactive feedback, tool recommendations, and architectural suggestions are both welcomed and appreciated. If you identify a tool or pattern that would improve the project, recommend it with a clear explanation of its benefits. When a new tool or pattern is implemented, leave detailed notes for other agents to ensure the rationale is understood. We prioritize a project that grows through collective intelligence without becoming bloated.

### 12. Git First (Traceability)
No task is complete until changes are committed to the `main` branch with a clear description and a version tag (`vX.Y.Z`) is incremented. This ensures a clean audit trail and allows for instant rollbacks.

### 13. Plan-Based Execution & Archiving
To ensure transparency and tracking, **every significant task must have an implementation plan** based on the official project templates (e.g., `GEMINI_PLAN_TEMPLATE_V2.md`). Changes must be tracked within these plans. **Once a plan is completed and verified, it must be moved to the `plans/archived/` directory** to keep the active workspace clean and focused.

### 14. Knowledge Hierarchy (The Source of Truth)
Agents may encounter "Knowledge Items" (KIs) or summaries provided by the system. **These are snapshots and may be stale.**
- **Primary Source of Truth**: The live files in `design_docs/`, `CHANGELOG.md`, and the `plans/` directory.
- **Secondary Source**: System-provided Knowledge Items.
If a conflict exists between a KI and a live file in the workspace, **the live file ALWAYS wins.** Agents MUST check the `design_docs/` folder at the start of every session to ensure they are working with the latest architectural rules.

### 15. The Hive Protocol (Stateless Execution)
For complex build phases, use the Hive Mission Protocol. Tasks must be broken into atomic units in a `PLAN_*.md` and executed via the `hive_worker.py` script. This prevents context bloat and cascading errors by isolating work in task-specific branches for review before merging.
