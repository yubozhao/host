# host

Your AI agents already know a lot about how you work: your rules, your memory files, and every time you told one "no, do it this way instead". A portrait gathers that into one folder that lets any AI agent act as your agentic self, deciding, working and communicating the way you would.

A portrait is shaped like a skill folder, so you share it the way you share skills: a git repository, a plugin or a zip. It is the start of your Agent of You, a version of you that others can hire, and it stays on your computer until you choose to publish.

## Install for Claude Code

In Claude Code:

```
/plugin marketplace add yubozhao/host
/plugin install host@host
```

## Commands

- `/host:build` builds your portrait and saves it at once; you never have to answer anything. Claude drafts from its own memory and history. If Codex, Gemini, Cursor, Kimi or Alma are on your computer, each one drafts its own part from its own memory, read-only, and Claude merges the parts. It ends with a few optional scenarios you can mark right or wrong, and the command to take the portrait to each agent.
- `/host:do <task>` does a task the way you would, from your portrait. Anything outward-facing, such as a message, an email or a post, stays a draft for you to send. It never sends, signs in, spends, accepts or deletes anything, and it ends with the rules it leaned on.

- `/host:fidelity <cases-folder>` measures how well the portrait predicts you: a blind test on cases you write (what happened, and what you actually decided), scored by a separate judge that never sees the portrait.

## What it reads and writes

- **Reads**, read-only: each agent's own memory and instructions files, and the messages you typed yourself in its recent history (the last 60 days), to find the times you corrected it. Tool output, system messages, pasted text and other agents' messages never count.
- **Leaves out** email addresses, phone numbers, file paths, secrets, other people's names and private details, and health, money and relationships. A script checks every agent's draft for these before it is used.
- **Writes** your portrait to `~/.agents/portraits/<your first name>/`, a private folder. Every earlier version is kept under `versions/`.
- **Adds** a small helper skill for each other agent it asks, listed at the end of every run.
- **Changes nothing else.** To take the portrait to an agent, you run `~/.agents/portraits/<name>/scripts/portrait install <agent>` yourself; `uninstall` removes exactly what it added.

## Privacy flow

Each agent's part is made by that agent, so its memory goes to its own company, the same as when you use it: OpenAI for Codex, Google for Gemini, Cursor, Moonshot AI for Kimi, Alma. The merge happens in the agent you started in, so the parts then go to that agent's company too, Anthropic for Claude Code. Nothing is uploaded.

## Remove the helpers

The helpers stay for next time unless you remove them. Each run prints where it put them. To remove one, run the plugin's script with the agent's name, for example:

```
~/.claude/plugins/cache/host/host/<version>/scripts/host uninstall codex
```

`<version>` is the installed plugin version, such as `0.7.0`. The agents are `claude`, `codex`, `gemini`, `cursor`, `kimi` and `alma`. The last message of a portrait run shows the exact command for your computer.

## The format

A portrait folder holds `PORTRAIT.md` (frontmatter that skill loaders accept, then the system prompt), `scenarios.md`, `examples.md`, `corrections.md`, `references/`, `scripts/portrait` and `versions/`. The full spec, for tools that want to read or write portraits, is [integrations/portrait-spec/PORTRAIT-FORMAT.md](integrations/portrait-spec/PORTRAIT-FORMAT.md).

## What is here

- `.claude-plugin/marketplace.json`: the Claude Code marketplace.
- `integrations/claude-code-plugin/`: the Claude Code plugin, with its own [README](integrations/claude-code-plugin/README.md).
- `integrations/portrait-spec/`: the shared build steps, the helper, the do and fidelity skills and the scripts that every platform's package is built from (`sync.sh` copies them in).

## License

[FSL-1.1-ALv2](LICENSE.md).
