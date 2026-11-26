---
name: portrait-unpublish
description: "Take the person's portrait listing down, delete the server copy and remove the local sign-in. Use only when the person runs /portrait-unpublish."
disable-model-invocation: true
---

<!-- portrait-unpublish:begin -->
# Unpublish the portrait

Take the person's listing down.

Run `"$HOME/.gemini/config/plugins/portrait/scripts/portrait-agents" unpublish`. It deletes the listing and its jobs from the server, then removes the sign-in from this computer. Tell the person what it printed, in one line. If it fails, give its message as it is; nothing local was removed. The portrait itself stays on this computer.
<!-- portrait-unpublish:end -->
