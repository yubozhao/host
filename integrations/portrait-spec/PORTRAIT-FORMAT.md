# Portrait format (portrait/1)

A portrait is a folder that lets any AI agent act as one person's agentic self: deciding, working and communicating the way they would. It mirrors an Agent Skills folder, so any tool that reads skills can read a portrait, and it is shared the way skills are: a git repository, a plugin or a zip.

## Location

A person's portraits live in `~/.agents/portraits/<name>/`, beside `~/.agents/skills/<name>/`. `<name>` is the person's first name in lowercase letters, digits and hyphens (at most 64 characters), or `me`.

## Layout

```
<name>/
  PORTRAIT.md        required: frontmatter and the system prompt
  scenarios.md       required: situations that calibrate it, with the person's verdicts
  examples.md        required: real decisions with their reasoning, and short writing samples
  corrections.md     required: the corrections it was built from, with their sources
  references/        optional: supporting detail (methods.md, fields.md, people.md, ...)
  scripts/portrait   optional: check, install, uninstall, snapshot, verdict
  versions/          optional: earlier versions, one dated folder each (YYYY-MM-DD-HHMM)
```

There is no special file extension. Every file is Markdown.

## PORTRAIT.md

YAML frontmatter, compatible with SKILL.md loaders: the two skill fields at the top level, and the portrait's own fields under `metadata`, a map of strings.

```
---
name: sam
description: "Sam's agentic self: how to decide, work and communicate the way they would. Load it when acting for Sam or deciding as they would."
metadata:
  format: portrait/1
  version: "3"
  made: "2026-11-24"
  updated: "2026-11-26"
  agents: "claude, codex, gemini"
---
```

- `name`: equals the folder name.
- `description`: 1 to 1024 characters; when an agent should load the portrait. Quote it, and use no double quotes inside it.
- `metadata.format`: `portrait/1`.
- `metadata.version`: a whole number, raised by 1 on every change.
- `metadata.made`, `metadata.updated`: `YYYY-MM-DD`.
- `metadata.agents`: the agents whose parts are in it.

The body is the system prompt, written to the agent in the second person, with one imperative line per point. It has exactly these sections, in this order, most important first:

1. `## Who you are`: "You are <first name>'s agentic self: you act for them, the way they would." and "You are an AI: never tell anyone you are <first name>, and never invent facts about their life."
2. `## How you decide`: decision rules, each with one real example (the situation, then what they would do and why), and how they rank and trade off. A rule resting on fewer than two corrections is marked "(guess)".
3. `## When to act and when to ask`: a table with the columns `Action` and `What to do`, where `What to do` is one of `Act alone`, `Act, then tell`, `Ask first` or `Never`.
4. `## Never`: hard lines.
5. `## What they care about`: goals in ranked order, current priorities with dates, values.
6. `## How they do things`: methods for repeated work, as short step lists.
7. `## What they know`: fields and depth, mental models, opinions.
8. `## How they communicate`: voice and format, up to 5 short quotes.
9. `## People and places they work in`: kinds of people, by role only, and how to treat each; tools and systems.
10. `## What you don't know`: gaps, and "Outside this portrait, say so and ask."

Rules:

- **Scope, never conflict.** When two rules disagree, one line states which applies where ("In <scope>, merge without asking; everywhere else, wait for their yes."). No line is marked "(conflict)".
- **Sources** go in a trailing HTML comment on each line, such as `<!-- claude: memory: reviews; codex: history; you said -->`, so the prompt reads cleanly when loaded.
- **Progressive disclosure.** `PORTRAIT.md` stays short and names another file only where an agent needs it, such as "For a new kind of decision, read examples.md."
- **Privacy.** No email addresses, phone numbers, file paths, secrets, other people's names or private details, or health, money and relationships, in any file.

## scenarios.md

```
# Scenarios

## 1. <short title>
- Situation: <a situation from the person's own work>
- Agent would: <what the agent would do, and why>
- Verdict: right | wrong | not yet
- Reason: <the person's reason; required when wrong>
- Date: <YYYY-MM-DD of the verdict, or when it was added>
```

Scenarios are numbered and never renumbered. Each run adds new ones aimed at the "(guess)" rules and at scoped conflicts. A `wrong` verdict with a reason becomes a rule in `PORTRAIT.md`, sourced `you said`.

## corrections.md

One line per correction: `- Situation: ... Did: ... Wanted: ... Reason: ... <!-- agent: source -->`.

## scripts/portrait

A POSIX `sh` script that works on the folder above it:

- `portrait check`: validates everything above; prints `ok: <name> (portrait/1, version <n>)` or one `problem:` line each, and exits non-zero on a problem.
- `portrait install <agent>` and `portrait uninstall <agent>`: make the portrait available to an agent, or remove exactly that. Claude, Cursor and Kimi get a small pointer skill (`portrait-<name>`) in `~/.claude/skills/`, `~/.cursor/skills/` or `~/.agents/skills/`; Codex gets a marked block in `~/.codex/AGENTS.md`; Gemini gets a marked `@<folder>/PORTRAIT.md` import block in `~/.gemini/GEMINI.md`; Alma gets a skill through `alma skill create`. Each points to the folder, so an agent always reads the current version.
- `portrait snapshot`: copies the current files to `versions/<YYYY-MM-DD-HHMM>/`.
- `portrait verdict <n> right|wrong [reason]`: snapshots, then records the verdict, reason and date on scenario `n`.
