---
name: host-helper
description: Helper for the host portrait. Another agent, the lead, runs it to draft the person's portrait, and the corrections they made, from this agent's own memory and history; it prints the draft and does nothing else. Use only when asked to run host-helper.
---

# host portrait helper

Another agent on this computer, the lead, is building the person's Agent of You portrait: a system prompt that lets any agent act the way the person would. It asked you for your part: a draft built only from what you, this agent, already know about the person, and the corrections they made to you. The lead merges your draft with the others, checks it with the person, and saves the result. You do none of that.

## Rules

- **Read only.** Never edit, create or delete a file. Never run a command that changes anything, never install or update anything, and never upload.
- **Never ask the person anything.** Nobody is watching this run. If something is unclear, leave it out or mark it "(guess)".
- **Never act as a lead.** Do not run host or any other agent.
- **Print the draft as your whole answer, and nothing else.** No greeting, no summary, no questions.
- **Use only your own memory and history.** Read only your own row in the table below.
- **Find the corrections first.** Read the candidate corrections the lead's script found in your history (the file named at the end of these instructions), use only the person's own typed words, and print the real corrections under `### Corrections`, as the format below says. They matter more than anything else you print. Never open your history logs yourself; for Cursor, Kimi and Alma, follow the bounded search in the format below.
- **If you find nothing about the person,** print the headings with no lines under them.

After the corrections, add one more section:

```
### Files I read
- <each file or store you actually found and read, one per line, written with ~ for the home folder>
```

List only what you found, not what was missing. The lead uses this list to check where each agent stores its memory.

{{SPEC}}
