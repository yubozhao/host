# portrait for Claude Code

This plugin adds `/portrait:build`, `/portrait:do` and `/portrait:fidelity` to Claude Code. It builds your Agent of You portrait: a folder, shaped like a skill folder, that lets any AI agent act as your agentic self, deciding, working and communicating the way you would. You share it the way you share skills: a git repository, a plugin or a zip. The format is in `integrations/portrait-spec/PORTRAIT-FORMAT.md`.

```
~/.agents/portraits/<your first name>/
  PORTRAIT.md        the system prompt, with skill-style frontmatter
  scenarios.md       situations that calibrate it, with your verdicts
  examples.md        real decisions and short samples of your writing
  corrections.md     the corrections it was built from
  references/        more detail on your methods, fields and people
  scripts/portrait   check, install, uninstall, snapshot, verdict
  versions/          every earlier version, dated
```

`PORTRAIT.md` is written to the agent, in this order:

1. Who you are: the agent acts for you, and never claims to be you or invents facts about your life.
2. How you decide: rules, each with a real example, built from the times you corrected an agent.
3. When to act and when to ask: act alone, act then tell, ask first, never.
4. Never: your hard lines.
5. What you care about: goals, current priorities, values.
6. How you do things: your methods for repeated work.
7. What you know.
8. How you communicate: voice, a few quotes and short samples.
9. People and places you work in: kinds of people by role, and your tools.
10. What the agent doesn't know, and to ask outside the portrait.

`PORTRAIT.md` stays short and points to the other files only when an agent needs them, such as "For a new kind of decision, read examples.md". When two of your corrections disagree, for example "merge without asking" in one project and "wait for my yes" everywhere else, it says which rule applies where, and never picks one silently.

The key input is your corrections: the moments you overruled, redirected or stopped an agent ("no", "instead", "don't", "stop asking"). The script searches Claude's, Codex's and Gemini's own history for them: only messages you typed yourself, and for Codex only sessions you ran yourself rather than scripts or subagents (never tool output, system reminders, messages from other sessions, notices, pasted text or skill bodies), newest first, the last 60 days, at most 60 candidates and 4 minutes. Each agent reads only its own candidates and quotes nothing from history beyond your own correction. A rule needs at least two corrections behind it, or it is marked as a guess. Each line keeps its source in a trailing `<!-- ... -->` comment, so the prompt reads cleanly.

You never need to answer anything. The portrait is saved as soon as it is built. Each run adds about five scenarios to `scenarios.md`, aimed at the rules that are still guesses and at scoped conflicts, such as "a test fails on a pull request that is otherwise ready: I fix it and merge without asking". Mark any right or wrong, or skip; unmarked ones stay "not yet". A wrong one, with your reason, becomes a new rule, and any correction in plain words is applied; each change saves a new version at once.

The run ends with where the portrait is, how to take it to each agent (`~/.agents/portraits/<name>/scripts/portrait install claude`, and the same for codex, gemini, cursor, kimi and alma), and the next step: it can become your Agent of You, a version of you others can hire, and it stays on this computer until you choose to publish.

## Act as you: /portrait:do

`/portrait:do <task>` does a task the way you would. It loads your newest portrait's `PORTRAIT.md` as its operating instructions and reads `examples.md` and `scenarios.md` only when a decision needs them. It also starts when you write `portrait:do` anywhere in a message, or ask it to "do this as me", "act as me" or "how would I handle this". It never sends, posts, signs in, spends, accepts or deletes anything: anything outward-facing stays a draft for you to send. It ends with one line, `Leaned on: <the rules it used>`. With no portrait yet, it says so and points you to `/portrait:build`.

## Blind test: /portrait:fidelity

`/portrait:fidelity <cases-folder>` checks how well the portrait predicts you; it runs `scripts/portrait-agents eval <cases-folder>`. Each case is a folder with `situation.md` (what happened, without your answer) and `answer.md` (what you actually decided, and a one-line reason). For each case, `/portrait:do` answers the situation from a private folder holding only `situation.md` and allowed to read only the portrait. A separate judge run, with no tools and no portrait, compares that answer with `answer.md`: match, close or wrong, with one line why. `results.md` in the cases folder records the portrait version and dates and the effort of both runs, so scores compare across versions, then the score (match counts 1, close 0.5), a table, and every wrong case written as a candidate scenario for `scenarios.md`. The `/portrait:do` run still sees what Claude Code loads for every session, such as your global `CLAUDE.md`.

## Fidelity, measured for you

You never have to answer anything for the portrait to be calibrated. `/portrait:build` holds out your newest corrections (20%, at least 5 and at most 20), builds a draft without them, and runs the blind test on them: `Fidelity 71% from 12 recent decisions`. Every miss becomes a rule, then the portrait is rebuilt from all your corrections and scored again on the same decisions: `After those rules: 55% on the same 12 decisions`. That second number says how well the new rules took; the weekly refresh measures new decisions. With fewer than 10 corrections it says so and skips the score. Every score, from a build, the weekly refresh or `/portrait:fidelity` on your own cases, is a row in the portrait's `fidelity.md` (date, score, cases, portrait version, and the test: before rules, after rules on the same decisions, the weekly forward test, or your own cases), so they compare over time.

## The weekly refresh

At the end of `/portrait:build`, a weekly refresh is turned on (launchd on macOS, Mondays at 10:00; a week the computer is off is skipped). It reads only the corrections since the last run, scores the current portrait on them first (a forward test it has not seen), then folds them in and saves a new version in `versions/`. It runs Claude Code headless at medium effort, about 10 cases a week, never asks anything, never runs twice at once, and logs to the portrait's `logs/` folder. Stop it with `~/.agents/portraits/<name>/scripts/portrait-agents schedule off`. On Linux and Windows, `schedule on` prints a line to add to cron or the task scheduler.

## How hard each agent thinks

Effort is set to keep token use moderate. `/portrait:build` runs at high effort, and so do its helpers where the agent has a setting: Claude `--effort high`, Codex `model_reasoning_effort=high`. Gemini, Cursor, Kimi and Alma have no run-level effort setting, so they run at their default (Kimi's effort is set in its own config, which is never edited). The progress line shows it, such as `Codex: reading (high)...`. A run that fails at high effort tries once more at default and says so. `/portrait:do`, the blind test (both its runs) and the weekly refresh use medium effort. A helper run stops after 15 minutes at high effort or 10 at default; `PORTRAIT_AGENT_TIMEOUT` overrides both, up to 20 minutes.

## Publish your listing: /portrait:publish

`/portrait:publish` lists your portrait so people can find it and ask to hire it. Listing is by invite only, you approve every job, and no money moves. It is the one command that asks you before acting:

1. It refuses if the portrait check finds anything private, or if the portrait's last fidelity score is under 40%, and says what to do next.
2. It drafts a public card: a summary, three kinds of work to hire you for, two sample answers from your scenarios, the fidelity score and the portrait version.
3. It shows you the exact card and the exact files that would upload: `PORTRAIT.md`, `examples.md` and `scenarios.md`, never `corrections.md`, the logs or `versions/`. Nothing uploads unless you say yes.
4. You sign in with a code sent to your email, and the sign-in stays in a private file in the portrait folder that nothing prints.

`portrait-agents listing keep-current on` lets the weekly refresh redraft the card and upload it again; it is off until you turn it on. `/portrait:unpublish` deletes the listing and the server's copy, and removes the sign-in from this computer.

## Your other agents

If you also use Codex, Gemini, Cursor, Kimi or Alma on this computer, Claude asks each of them for its own part and corrections, built from its own memory and history, and merges the parts into one prompt. There is no question first: Claude finds every agent, Kimi included, runs them and shows one progress line each, such as `Codex: reading...` or `Gemini: too old, skipped`.

Each agent's part is made by that agent, so its memory goes to its own company (OpenAI, Google, Cursor, Moonshot AI or Alma), the same as when you use it. The merge happens here, so the parts then go to Anthropic too. The skill shows no notice about this; this README is where it is written down.

Before Claude sees any part, the script drops every line with an email address, phone number, file path or secret, and every line that does not name its source. Corrections are kept as their own block. In the merged prompt, every line names the agent and the source it came from. Lines the agents agree on are combined, and lines they disagree on become the first scenarios for you. Each agent also lists the files it actually read.

Whichever agent you start the portrait in leads. The others help. This plugin is the Claude lead; the other platforms' packages share the same steps and script.

The helpers only draft. They run read-only and headless, stop after 10 minutes, never ask you anything, and never save or upload. An agent that is not signed in, too old (for example Gemini 0.1.2, which has no skills) or not running (Alma) is reported and skipped. Nothing is updated or upgraded without your yes.

What helping adds to your computer, so you can see and remove it. The last message of every run lists these files in one line, `Helpers added to: ...`:

| Agent | Written by `portrait-agents install` | Removed by `portrait-agents uninstall` |
|---|---|---|
| Claude (when another agent leads) | `~/.claude/skills/portrait-helper/SKILL.md` | the same file |
| Codex, Gemini, Kimi | `~/.agents/skills/portrait-helper/SKILL.md`, one file the three share | the same file |
| Cursor | `~/.cursor/skills/portrait-helper/SKILL.md` | the same file |
| Alma | the skill `portrait-helper` in Alma's own skill list (`alma skill create`) | `alma skill uninstall portrait-helper` |

Each run also uses a private temporary folder, which is deleted when the run ends. The helpers' drafts live in a private working folder, removed once the portrait is saved.

You need no other app for any of this.

## Install

In Claude Code:

```
/plugin marketplace add yubozhao/host
/plugin install portrait@host
```

Then run:

```
/portrait:build
```

## What it reads and where it goes

- **Reads**, with Claude Code's read tools only: `~/.claude/CLAUDE.md` and the files it includes, every memory file under `~/.claude/projects/*/memory/`, the `CLAUDE.md` files of those projects, and your own typed messages in the chat logs under `~/.claude/projects/`, searched by the script for corrections. Each other agent reads only its own memory and history.
- **Leaves out**: secrets, keys, email addresses, phone numbers, home paths, other people's private details, and health, money and relationships. Clients are named only if you say the name may be public.
- **Goes to Anthropic**: the draft is made in your Claude chat, like anything else you type in Claude Code. That includes the other agents' parts once they are merged here.
- **Saved** as soon as it is built, and again after each verdict or correction: `~/.agents/portraits/<name>/` on this computer, a private folder (folders 0700, files 0600). Every earlier version is copied to `versions/<YYYY-MM-DD-HHMM>/` first. A 0.4 portrait at `~/.agents/agent-of-you/portrait.md` is read as a starting point and moved into `versions/` on the first 0.5 run. Nothing is uploaded.
- **Installed into an agent** only when you run `scripts/portrait install <agent>`: a small pointer skill for Claude, Cursor and Kimi (`~/.claude/skills/`, `~/.cursor/skills/`, `~/.agents/skills/`), a marked block in `~/.codex/AGENTS.md` for Codex, a marked import block in `~/.gemini/GEMINI.md` for Gemini, and an Alma skill. Your own text in those files is left as it was, and `uninstall` removes exactly what `install` added.

## Test locally

From a checkout of this repository:

```bash
claude --plugin-dir "$PWD/integrations/claude-code-plugin"
```

Then, in Claude Code:

```
/portrait:build
```

Or install it through the local marketplace (the `.claude-plugin/marketplace.json` at the repository root). In Claude Code:

```
/plugin marketplace add /path/to/your/checkout
/plugin install portrait@host
```

Remove it again with `/plugin uninstall portrait@host` and `/plugin marketplace remove host`.

Check the plugin:

```bash
claude plugin validate --strict integrations/claude-code-plugin
```

The full test suite (stub agent CLIs and a temporary home folder, so it never touches your real agents or memory) runs in the development repository before each release.

## How it is built

- `.claude-plugin/plugin.json`: the plugin manifest.
- `skills/build/SKILL.md`: the lead, the `/portrait:build` steps. It is allowed to read files without asking (`Read`, `Glob`, `Grep`). Running the script and saving ask you, as usual.
- `scripts/portrait-agents`: the shared lead logic (`scripts/portrait-agents` is its older name, kept as an alias for one version). It finds, installs, runs and removes the helpers, searches each agent's history for your own typed corrections, checks the drafts (shape, sources, privacy), bundles them for the lead, and saves the portrait folder. It is POSIX `sh` and `awk`, with no other runtime (it uses `zstdcat` for Codex's compressed logs when it is installed).
- `skills/do/SKILL.md`: `/portrait:do`, rendered from `integrations/portrait-spec/do.md`.
- `skills/fidelity/SKILL.md`: `/portrait:fidelity`, rendered from `integrations/portrait-spec/fidelity.md`.
- `skills/publish/SKILL.md` and `skills/unpublish/SKILL.md`: `/portrait:publish` and `/portrait:unpublish`, rendered from `publish.md` and `unpublish.md`.
- `scripts/portrait`: the tool that travels inside every portrait folder: `check`, `install <agent>` and `uninstall <agent>`, `snapshot`, and `verdict <n> right|wrong [reason]`.
- `helpers/portrait-helper/SKILL.md`: the helper that the other agents run.
- `portrait.vars`: this platform's values for the shared lead steps (its name, id and script path).
- Everything shared lives once in `integrations/portrait-spec/`:
  - `spec.md`: the portrait format, the privacy rules and where each agent's memory is.
  - `lead.md`: the lead steps, including the merge rules.
  - `helper.md`: the helper.
  - `do.md` and `fidelity.md`: the do and fidelity skills.
  - `portrait-agents` and `portrait`: the scripts.
  - `PORTRAIT-FORMAT.md`: the portrait folder format, for other tools.
  `sync.sh` copies them into every platform's package. A test fails when a copy drifts, and checks that every package can lead.
- The plugin has no MCP server and needs no other app.
