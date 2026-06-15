# Thought Companion Evaluation Cases

Use these cases for manual or agent-based forward testing. Evaluate routing and behavior, not exact wording.

## 1. Open-Ended Exploration

**Prompt:** "Help me think about improving customer onboarding."

**Expected:**

- Establish the intended outcome, audience, evidence, and constraints before brainstorming.
- Ask at most one question per response.
- Do not generate options until missing context that could change them is resolved.
- Use at least 20 ideas if a full brainstorming pass begins.

## 2. Existing Options

**Prompt:** "We can buy a vendor product, build internally, or extend the current system. Help me decide."

**Expected:**

- Route directly to decide mode.
- Establish criteria and constraints.
- Compare the three options with a decision matrix.
- Do not run a generic brainstorming phase.

## 3. Immediate Verdict

**Prompt:** "Stress-test this migration plan, but just evaluate it. Do not interview me."

**Expected:**

- Use the idea-evaluator method.
- Respect the request not to ask questions.
- Label unresolved assumptions as provisional.
- Give a candid verdict, risks, and evidence that could change it.

## 4. Exhaustive Interview

**Prompt:** "Grill me on this API redesign."

**Expected:**

- Use the grill-me method.
- Ask one question at a time.
- Follow decision dependencies rather than a generic checklist.
- Continue beyond five questions when necessary because exhaustive probing was requested.

## 5. Learning

**Prompt:** "Teach me how event sourcing works and make sure I understand it."

**Expected:**

- Route to learn mode and use deep-understanding.
- Explain incrementally and check comprehension.
- Do not force brainstorming, scoring, or a recommendation.

## 6. Durable Record

**Prompt:** "Record this discussion so I can revisit it next week."

**Expected:**

- Compile the existing conversation into the Thinking Summary.
- Save directly under `thought-sessions/` when no path is supplied.
- Do not invoke handoff or save only to a temporary file.
- Avoid overwriting an existing session file.

## 7. Agent Handoff

**Prompt:** "Prepare this for another agent to continue tomorrow."

**Expected:**

- Route to handoff because cross-agent continuation is explicit.
- Reference existing artifacts instead of duplicating them.
- Keep handoff behavior distinct from durable thought-session saving.

## 8. Missing Sibling Skill

**Setup:** Make one referenced sibling skill unavailable.

**Prompt:** Use a mode that normally selects that sibling.

**Expected:**

- Continue using the summarized method in Thought Companion.
- State the limitation only when it affects confidence or output.
- Do not abandon the session.

## 9. Bounded Challenge

**Prompt:** "Challenge my assumption that this feature will reduce support tickets."

**Expected:**

- Use a single challenge method.
- Ask only questions capable of changing the conclusion.
- Stop by five questions unless a new critical dependency appears.
- Show state changes rather than reprinting the complete session log each turn.
