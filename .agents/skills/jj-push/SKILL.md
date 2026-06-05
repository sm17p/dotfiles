---
name: jj-push
description: Push a Jujutsu revision to `origin` using an explicit bookmark name. Use when the user wants to publish, push, ship, or send a JJ change by creating or updating a bookmark for a chosen revision and pushing it safely with `jj git push`.
---

# Jujutsu Bookmark Push

Use this skill when the user explicitly wants to push a Jujutsu revision through
an explicit bookmark.

This workflow requires a bookmark name. The revision argument is optional and
defaults to `@`. The remote is fixed to `origin` in v1.

## Required input

Supported invocation shape:

- `/jj-push <bookmark> [revset]`

Interpret the first argument as the bookmark name and the optional second
argument as the target revision. If no revision is supplied, use `@`.

## Workflow

1. Resolve the target revision.
2. Advance the closest bookmark with `jj tug` if the target is `@` (safe no-op otherwise).
3. Check whether the bookmark already exists and its current location.
4. If the bookmark already points at the target revision, skip to push.
5. Otherwise create or move the bookmark so it points at the target revision.
6. Show bookmark state before pushing.
7. Push the bookmark to `origin`.
8. Report what was pushed.

## Validation

Before mutating bookmark state, inspect the revision and bookmark status with
commands like:

```bash
jj log -r "<revset>" --no-graph -T 'change_id.short() ++ " " ++ commit_id.short(12) ++ " " ++ description.first_line() ++ "\n"'
jj bookmark list "<bookmark>" --all-remotes
```

If the revision does not resolve, stop and report the error.

## Bookmark update rules

Treat a bookmark as existing only if there is a local bookmark with that exact
name. Do not treat a remote-only bookmark such as `<bookmark>@origin` as a local
bookmark.

Inspect the output of `jj bookmark list "<bookmark>" --all-remotes` carefully:

- If you see only remote entries such as `<bookmark>@origin`, create the local
  bookmark.
- If you see a local `<bookmark>` entry, note its current location.

If the bookmark already exists and already points at the target revision
(possibly set by `jj tug`), skip the create/move step and go to push.

If the bookmark does not exist locally, create it:

```bash
jj bookmark create "<bookmark>" -r "<revset>"
```

If the bookmark already exists but points elsewhere, move it:

```bash
jj bookmark move "<bookmark>" --to "<revset>"
```

Do not use backwards moves, force-like behavior, or alternate remotes unless the
user explicitly asks for that.

## Push step

After updating the bookmark, show its state:

```bash
jj bookmark list "<bookmark>" --all-remotes
```

Then push it:

```bash
jj git push --remote origin --bookmark "<bookmark>"
```

## Failure handling

If `jj git push` fails a safety check, stop and tell the user to fetch or
resolve the bookmark state first. Recommended next step:

```bash
jj git fetch --remote origin
```

Do not retry with override flags unless the user explicitly asks for that.

## Completion

After a successful push, report:

- the bookmark name
- the resolved revision
- the remote `origin`

If the push was blocked, summarize the safety-check failure and the next
non-destructive command to run.
