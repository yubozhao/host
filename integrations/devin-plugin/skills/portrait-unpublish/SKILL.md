---
name: portrait-unpublish
description: "Take the person's portrait listing down, delete the server copy and remove the local sign-in. Use only when the person runs /portrait-unpublish."
triggers: [user]
---

Here `<plugin-root>` is this plugin's folder, two levels above this SKILL.md, holding `.devin-plugin/plugin.json` and `scripts/portrait-agents`. If you do not know this file's path, find the folder once with `find "$HOME" -maxdepth 7 -type f -path '*portrait*/scripts/portrait-agents'`; use its absolute path in every command.

<!-- portrait-unpublish:begin -->
# Unpublish the portrait

Take the person's listing down.

Run `"<plugin-root>/scripts/portrait-agents" unpublish`. It deletes the listing and its jobs from the server, then removes the sign-in from this computer. Tell the person what it printed, in one line. If it fails, give its message as it is; nothing local was removed. The portrait itself stays on this computer.
<!-- portrait-unpublish:end -->
