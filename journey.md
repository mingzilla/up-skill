## Skill System Levels

### **L1: Make Skills**

- **Purpose:** Create individual skills from scratch
- **Activities:**
    - Writing SKILL.md with proper frontmatter
    - Creating script implementations
    - Testing skills locally
    - Validating skill structure and metadata
- **Output:** Raw skill files ready for distribution
- **User Persona:** Skill creator / developer

---

### **L2: Share Skills** ⬅️ **We are building this now**

- **Purpose:** Distribute and consume skills across a team
- **Activities:**
    - Push skills to personal sharing repos (GitHub)
    - Pull skills from teammates' repos
    - List available skills across the team
    - Address book management (who has what)
    - Team workspace setup
- **Output:** Shared skill ecosystem with team visibility
- **User Persona:** Team member consuming/sharing skills
- **What we're building:**
    - `up-skill__provide-skills` (share)
    - `up-skill__receive-skills` (add)
    - `up-skill__list-skills` (discover)
    - Address book + git repo management

---

### **L3: Manage Skills**

- **Purpose:** Organise and govern skills at scale
- **Activities:**
    - Skill classification (domain, difficulty, role)
    - Dependency management between skills
    - Ensuring skills are:
        - **Unit skills** (no external dependencies)
        - **Flow skills** (composable multi-step workflows)
    - Versioning and compatibility tracking
    - Skill registry/catalogue
    - Quality gates and approvals
    - Conflict resolution between skill versions
- **Output:** Curated, dependency-aware skill library
- **User Persona:** Skill librarian / team lead
- **Note:** L2 and L3 will have completely different setups (one_off and other skills). L3 still uses L2 to share, but operates at a higher abstraction level.

---

### **L4: Skill Pipelines**

- **Purpose:** Chain skills into automated workflows
- **Activities:**
    - Assign skills into execution pipelines
    - Define skill sequences (like a WIP board)
    - Orchestrate multi-skill flows
    - Pipeline state management
    - Conditional branching between skills
    - Parallel execution where possible
- **Output:** Automated, repeatable processes composed of skills
- **User Persona:** Process automator / workflow designer

---

### **L5: Optimise Skills**

- **Purpose:** Continuously improve skill effectiveness
- **Activities:**
    - Performance analytics (execution time, success rate)
    - Feedback collection and iteration
    - A/B testing skill variants
    - Skill pruning (deprecate unused skills)
    - Automated refinement based on usage patterns
    - Suggest improvements to skill creators
- **Output:** Self-improving skill ecosystem
- **User Persona:** System optimizer / analyst

---

## User Journey

> **Non-technical person's path to up-skilling:**
>
> L1 (Make) → L2 (Share) → L3 (Manage) → L4 (Pipeline) → L5 (Optimise)
>
> _Start by creating skills, share with the team, manage quality and dependencies, automate workflows, then continuously improve._
