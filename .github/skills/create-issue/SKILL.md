---
name: create-issue
description: Creates GitHub issues for the package repository. Use when asked to create, file, or open a GitHub issue, or when planning new features or functions that need to be tracked.
compatibility: Requires the `gh` CLI and an authenticated GitHub session.
---

# Create a GitHub issue

Use `gh api graphql` with the `createIssue` mutation to create issues. This sets the issue type in a single step. Write the body to a temp file first, then pass it via `$(cat ...)`.

## Looking up IDs

The hardcoded IDs below are correct for this repo as of 2026-03-02. If they ever change, or if you're working in a fork or a repo other than "wranglezone/datawrap", re-run these queries to get fresh values (updating owner and name if necessary).

```bash
# Repository node ID
gh api graphql -f query='{ repository(owner: "wranglezone", name: "datawrap") { id } }'

# Available issue type IDs
gh api graphql -f query='{ repository(owner: "wranglezone", name: "datawrap") { issueTypes(first: 20) { nodes { id name } } } }'
```

## Issue type

Choose the type that best fits the issue:

| Type | ID | Use for |
|---|---|---|
| Feature | `IT_kwDODjbzj84BwJRW` | New exported functions or capabilities |
| Bug | `IT_kwDODjbzj84BwJRV` | Something broken or incorrect |
| Documentation | `IT_kwDODjbzj84BwprI` | Docs-only changes |
| Task | `IT_kwDODjbzj84BwJRU` | Maintenance, refactoring, chores |

## Issue title

Titles use conventional commit prefixes:

- `feat: my_function()` — new exported function or feature
- `fix: short description` — bug fix
- `docs: short description` — documentation
- `chore: short description` — maintenance or task

## Issue body structure

Include these sections in order:

### `## Summary`

A single user story sentence (no other content in this section):

```markdown
> As a [role], in order to [goal], I would like to [feature].
```

Example:
```markdown
## Summary

> As a data wrangler, in order to share information about my dataset, I would like to create a simple data dictionary based on my dataset.
```

### `## Proposed signature`

The proposed R function signature, arguments table, and return value description:

````markdown
## Proposed signature

```r
function_name(arg1, arg2)
```

**Arguments**

- `arg1` (`TYPE`) — Description.
- `arg2` (`TYPE`) — Description.

**Returns** a `TYPE` with description.
````

### `## Behavior`

Bullet points describing the expected behavior, edge cases, and any internal helpers that should be implemented as part of this issue.

### `## References` (optional)

Only include this section when there are specific reference implementations, external URLs, or related code to link to. Omit it entirely when there are none.

## Creating the issue

```bash
gh api graphql \
  -f query='mutation($repoId:ID!, $title:String!, $body:String!, $typeId:ID!) {
    createIssue(input:{repositoryId:$repoId, title:$title, body:$body, issueTypeId:$typeId}) {
      issue { url }
    }
  }' \
  -f repoId="R_kgDORb_Ktg" \
  -f title="feat: my_function()" \
  -f body="$(cat /tmp/issue_body.md)" \
  -f typeId="IT_kwDODjbzj84BwJRW"
```
