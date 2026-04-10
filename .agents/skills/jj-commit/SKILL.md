---
name: jj-commit
description: Write or improve a Jujutsu change description for an explicitly provided revision. Use when the user wants to describe, finalize, rewrite, polish, or commit a JJ change with `jj describe`, including requests to write a title and body that explain what changed and why.
---

# Jujutsu Commit Description

Use this skill when the user explicitly wants to finalize or improve the
description of a Jujutsu change.

This skill always targets an explicit revision argument. Do not assume `@`.
Do not run `jj new` as part of this workflow.

## Required input

Expect one revision argument:

- `/jj-commit <revset>`

If no revision is provided, stop and ask for the revision to describe.

## Workflow

1. Resolve and inspect the target revision before writing anything.
2. Review enough context to describe the change accurately.
3. Draft a multi-line description with:
   - a short first-line title
   - a blank line
   - a body that explains both what changed and why
4. Apply the description with `jj describe -r <revset> --stdin`.
5. Report which revision was updated and restate the final title line.

## Inspection commands

Start with commands like these:

```bash
jj log -r "<revset>" --no-graph -T 'change_id.short() ++ " " ++ commit_id.short(12) ++ " " ++ description.first_line() ++ "\n"'
jj show -r "<revset>" --summary
jj diff -r "<revset>" --stat
```

Use more detail only when needed to understand the change.

## Message standard

The description must be specific and reviewable.

- The title should summarize the main outcome, not the process.
- The body should explain what changed and why it was needed.
- Prefer concrete nouns and verbs over vague wording.
- Avoid titles like `update files`, `misc fixes`, or `fix stuff`.
- Do not mention files unless they clarify the behavior change.

## Apply the description

Write the final description as multi-line input and pass it through stdin:

```bash
jj describe -r "<revset>" --stdin
```

Do not fall back to a one-line message unless the user explicitly asks for it.

## Completion

After `jj describe` succeeds, report:

- the resolved revision identifier
- the final title line

If the revision cannot be resolved or the description would be inaccurate from
the available context, stop and explain the blocker instead of guessing.
