---
description: Deep technical investigation. Creates a research issue, uses multiple investigation methods, documents findings with evidence, and saves as a spike document.
---

The /prompts:research command is for structured investigation when understanding is needed before decisions can be made. Prioritize depth over speed.

## Argument

Accept an optional argument via $ARGUMENTS: the research question. If not provided, ask the user. The question must be specific and answerable.

## Phases

### Phase 1: Define the Question

Load `$tracking-issues` to create a GitHub issue with the label `research`.

If the research question is ambiguous, clarify:
- What decision depends on this research?
- What are the candidate options?
- What is the time constraint?
- What is already known?

### Phase 2: Investigation

Use all available tools systematically:

**Level 1: Local codebase (always first)**
- Search the codebase to understand existing structure and patterns
- Use Grep to find specific implementations and references
- Use Read to inspect actual code

**Level 2: Package registries**
- Check version history, dependencies, maintenance signals

**Level 3: Code repositories**
- Search GitHub for the project's repository, README, issues

**Level 4: Official documentation**
- Fetch official docs and API references

**Level 5: Community sources**
- Search for community knowledge; verify claims against primary sources

**Level 6: Testing and experimentation**
- Create minimal test cases if documentation is unavailable or contradictory

Every factual claim must have a source (file:line, URL, or command output).

### Phase 3: Document Findings

Structure the document as follows:

**Research Question** — State the exact question being answered.

**Methods Used** — List each investigation method attempted and what it produced.

**Findings** — Present each finding with its source (file:line or URL). Quote relevant code or documentation directly.

**Options Evaluated** — For each candidate option:
- Description
- Evidence supporting it
- Trade-offs (pros and cons with evidence)
- Effort estimate if applicable

**Unknowns** — For each item that could not be determined:
- What is unknown
- Why it is unknowable with the methods attempted
- What would be needed to resolve it

**Confidence Level** — State High (80-100%), Medium (50-80%), or Low (<50%) with justification.

**Recommendation** — State a concrete recommendation. The recommendation must be actionable, not "investigate more". Each next step must have an effort estimate.

### Phase 4: Save to Knowledge Base

Save findings as a spike document. If no knowledge base is configured, save to `docs/spikes/[name].md`.

Confirm the document was saved and provide the path so the user can retrieve it later.

### Phase 5: Close Issue

Close the GitHub issue with a summary comment.
