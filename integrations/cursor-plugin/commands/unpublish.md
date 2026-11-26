---
name: unpublish
description: "Take your portrait listing down"
---

<!-- Rendered by integrations/portrait-spec/sync.sh from unpublish.md; do not edit. -->

Here `<plugin-root>` is this plugin's folder, the one holding `.cursor-plugin/plugin.json` and `scripts/portrait-agents`. Find it once with `find ~/.cursor/plugins -type f -path '*portrait*/scripts/portrait-agents'` and use its absolute path in every command.

# Unpublish the portrait

Take the person's listing down.

Run `"<plugin-root>/scripts/portrait-agents" unpublish`. It deletes the listing and its jobs from the server, then removes the sign-in from this computer. Tell the person what it printed, in one line. If it fails, give its message as it is; nothing local was removed. The portrait itself stays on this computer.
