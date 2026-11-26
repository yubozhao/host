# portrait

Your AI agents already know a lot about how you work: your rules, your memory files, and every time you told one "no, do it this way instead". A portrait gathers that into one folder that lets any AI agent act as your agentic self, deciding, working and communicating the way you would.

A portrait is shaped like a skill folder, so you share it the way you share skills: a git repository, a plugin or a zip. It is the start of your Agent of You, a version of you that others can hire, and it stays on your computer until you choose to publish.

## Install for Claude Code

In Claude Code:

```
/plugin marketplace add yubozhao/host
/plugin install portrait@host
```

## Install for Codex

In a terminal:

```
codex plugin marketplace add yubozhao/host
codex plugin add portrait@host
```

In Codex the same commands are `$portrait:build`, `$portrait:do`, `$portrait:fidelity`, `$portrait:publish`, `$portrait:unpublish` and `$portrait:jobs`. Codex then leads: it drafts from its own memory first, Claude and the other agents add their parts read-only, and the draft goes to OpenAI instead of Anthropic. `$portrait:publish`, `$portrait:unpublish` and `$portrait:jobs` run only when you type them.

## Install for Gemini CLI

In a terminal:

```
gemini extensions install https://github.com/yubozhao/host
```

In Gemini CLI the same commands are `/portrait:build`, `/portrait:do`, `/portrait:fidelity`, `/portrait:publish`, `/portrait:unpublish` and `/portrait:jobs`. They are commands, so each runs only when you type it. Gemini then leads: it drafts from its own memory first, Claude and the other agents add their parts read-only, and the draft goes to Google.

## Install for Antigravity CLI

In a terminal:

```
git clone https://github.com/yubozhao/host ~/.agy-portrait-host
agy plugin install ~/.agy-portrait-host/integrations/antigravity-plugin
```

In Antigravity the skills are `/portrait-build`, `/portrait-do`, `/portrait-fidelity`, `/portrait-publish`, `/portrait-unpublish` and `/portrait-jobs`; publish, unpublish and jobs run only when you type them.

## Install for Devin (formerly Windsurf)

In a terminal:

```
devin plugins install yubozhao/host#integrations/devin-plugin
```

The skills are `/portrait-build` and the rest; publish, unpublish and jobs run only when you type them.

## Install for OpenCode and Kilo Code

Clone the repository, then add the plugin folder to the `plugin` list of `~/.config/opencode/opencode.json` (or `~/.config/kilo/kilo.json` for Kilo Code):

```
git clone https://github.com/yubozhao/host ~/.opencode-portrait-host
```

```json
{ "plugin": ["~/.opencode-portrait-host/integrations/opencode-plugin"] }
```

Use the full path in place of `~`. The commands are `/portrait-build` and the rest; each runs only when you type it.

## Install for Goose

Goose installs the Gemini CLI extension of this repository:

```
goose plugin install https://github.com/yubozhao/host
```

It imports the `portrait-build`, `portrait-do` and `portrait-fidelity` skills.

## Install for Amp, Warp and Zed

These take plain skill folders. `integrations/agent-skill/portrait` is one skill, `portrait`, with every step and its scripts inside.

Amp:

```
amp skill add yubozhao/host/integrations/agent-skill/portrait --global
```

Warp and Zed: copy the folder to `~/.agents/skills/portrait`:

```
git clone https://github.com/yubozhao/host ~/.portrait-host
cp -R ~/.portrait-host/integrations/agent-skill/portrait ~/.agents/skills/portrait
```

Ask for a step by name: build, do, fidelity, publish, unpublish or jobs. Publish, unpublish and jobs run only when you ask for them in words.

## Install for Kimi Code CLI

In Kimi Code CLI:

```
/plugins install https://github.com/yubozhao/host
/reload
```

## Install for Cursor

Cursor lists plugins in its reviewed marketplace; until this one is listed, add it as a local plugin. In a terminal:

```
git clone https://github.com/yubozhao/host ~/.cursor/portrait-host
ln -s ~/.cursor/portrait-host/integrations/cursor-plugin ~/.cursor/plugins/local/portrait
```

In Kimi Code CLI and Cursor the commands are `/portrait:build`, `/portrait:do`, `/portrait:fidelity`, `/portrait:publish`, `/portrait:unpublish` and `/portrait:jobs`, each run only when you type it. Their own headless modes cannot be kept read-only, so the blind test, the weekly refresh and hired jobs run with Claude Code, Codex or Gemini CLI when one is on your computer.

## Install for GitHub Copilot CLI

In a terminal:

```
copilot plugin marketplace add yubozhao/host
copilot plugin install portrait@host
```

In Copilot CLI the skills are `/portrait:build` and the rest; publish, unpublish and jobs run only when you type them. The portrait's own model runs (the blind test, the weekly refresh, hired jobs) use Claude Code, Codex or Gemini CLI when one is installed.

## Install for Factory Droid, Augment and JetBrains Junie

These read the Claude Code marketplace, so the Claude Code plugin installs as it is.

Factory Droid, in a terminal:

```
droid plugin marketplace add yubozhao/host
droid plugin install portrait@host --scope user
```

Augment (Auggie): run `auggie plugin marketplace add yubozhao/host`, then turn the plugin on in `/plugins`.

JetBrains Junie CLI: add the `yubozhao/host` marketplace and install `portrait` with `/extensions install`.

The commands are the Claude Code ones: `/portrait:build` and the rest.

## Commands

- `/portrait:build` builds your portrait and saves it at once; you never have to answer anything. Claude drafts from its own memory and history. If Codex, Gemini, Cursor, Kimi or Alma are on your computer, each one drafts its own part from its own memory, read-only, and Claude merges the parts. It ends with a few optional scenarios you can mark right or wrong, and the command to take the portrait to each agent.
- `/portrait:do <task>` does a task the way you would, from your portrait. Anything outward-facing, such as a message, an email or a post, stays a draft for you to send. It never sends, signs in, spends, accepts or deletes anything, and it ends with the rules it leaned on.

- `/portrait:fidelity <cases-folder>` measures how well the portrait predicts you: a blind test on cases you write (what happened, and what you actually decided), scored by a separate judge that never sees the portrait.

`/portrait:build` also measures itself: it holds out your newest corrections, builds without them, and reports how often the portrait decided as you did, such as `Fidelity 71% from 12 recent decisions`. Then a weekly refresh keeps it current: it scores the portrait on your new corrections first, then folds them in. Stop it any time with `~/.agents/portraits/<name>/scripts/portrait-agents schedule off`.

- `/portrait:publish` lists your portrait so people can ask to hire it: invite only, you approve every job, and no money moves. It shows the exact public card first and uploads only that card, on your yes; the portrait stays on your computer. `/portrait:unpublish` takes it down.
- `/portrait:jobs` handles the jobs people hire it for: you approve each one, it runs on your computer from your portrait with your own plan, and you check the result before it is sent.

## What it reads and writes

- **Reads**, read-only: each agent's own memory and instructions files, and the messages you typed yourself in its recent history (the last 60 days), to find the times you corrected it. Tool output, system messages, pasted text and other agents' messages never count.
- **Leaves out** email addresses, phone numbers, file paths, secrets, other people's names and private details, and health, money and relationships. A script checks every agent's draft for these before it is used.
- **Writes** your portrait to `~/.agents/portraits/<your first name>/`, a private folder. Every earlier version is kept under `versions/`, and every fidelity score in `fidelity.md`.
- **Schedules** the weekly refresh (on macOS, a LaunchAgent in `~/Library/LaunchAgents/`), which `schedule off` removes.
- **Adds** a small helper skill for each other agent it asks, listed at the end of every run.
- **Changes nothing else.** To take the portrait to an agent, you run `~/.agents/portraits/<name>/scripts/portrait install <agent>` yourself; `uninstall` removes exactly what it added.

## Privacy flow

Each agent's part is made by that agent, so its memory goes to its own company, the same as when you use it: OpenAI for Codex, Google for Gemini, Cursor, Moonshot AI for Kimi, Alma. The merge happens in the agent you started in, so the parts then go to that agent's company too, Anthropic for Claude Code. Nothing is uploaded.

## Remove the helpers

The helpers stay for next time unless you remove them. Each run prints where it put them. To remove one, run the plugin's script with the agent's name, for example:

```
~/.claude/plugins/cache/host/portrait/<version>/scripts/portrait-agents uninstall codex
```

`<version>` is the installed plugin version, such as `0.6.0`. The agents are `claude`, `codex`, `gemini`, `cursor`, `kimi` and `alma`. The last message of a portrait run shows the exact command for your computer.

## The format

A portrait folder holds `PORTRAIT.md` (frontmatter that skill loaders accept, then the system prompt), `scenarios.md`, `examples.md`, `corrections.md`, `references/`, `scripts/portrait` and `versions/`. The full spec, for tools that want to read or write portraits, is [integrations/portrait-spec/PORTRAIT-FORMAT.md](integrations/portrait-spec/PORTRAIT-FORMAT.md).

## What is here

- `.claude-plugin/marketplace.json`: the Claude Code marketplace.
- `integrations/claude-code-plugin/`: the Claude Code plugin, with its own [README](integrations/claude-code-plugin/README.md).
- `integrations/portrait-spec/`: the shared build steps, the helper, the do and fidelity skills and the scripts that every platform's package is built from (`sync.sh` copies them in).

## License

[FSL-1.1-ALv2](LICENSE.md).
