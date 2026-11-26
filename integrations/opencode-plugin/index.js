// The portrait plugin for OpenCode: adds /portrait-build, /portrait-do,
// /portrait-fidelity, /portrait-publish, /portrait-unpublish and
// /portrait-jobs. Each command is a step list rendered from
// integrations/portrait-spec by sync.sh; commands run only when typed.
import { readFileSync } from "node:fs"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"

const root = dirname(fileURLToPath(import.meta.url))
const steps = ["build", "do", "fidelity", "publish", "unpublish", "jobs"]

// step returns a rendered command file without its frontmatter and header
// comment, with this plugin's folder in place of <plugin-root>.
function step(name) {
  const text = readFileSync(join(root, "commands", `${name}.md`), "utf8")
  const description = (text.match(/^description: "(.*)"$/m) || [])[1] || ""
  const body = text
    .replace(/^---\n[\s\S]*?\n---\n\n/, "")
    .replace(/^<!-- Rendered by [^\n]*-->\n\n/, "")
    .replaceAll("<plugin-root>", root)
  return { description, template: `${body}\n$ARGUMENTS\n` }
}

export const PortraitPlugin = async () => ({
  config: async (config) => {
    config.command = config.command || {}
    for (const name of steps) {
      const key = `portrait-${name}`
      if (!config.command[key]) config.command[key] = step(name)
    }
  },
})
