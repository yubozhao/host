#!/bin/sh
# Copies the canonical portrait files into every platform package: the
# shared scripts (portrait-agents and portrait), the helper skill, and the build,
# do, fidelity, publish and unpublish skills. Run it after editing anything in this folder;
# portrait_agents_test.go fails when a package copy drifts.
#
# A package is a folder with a portrait.vars file (KEY=value lines: LEAD,
# LEAD_ID, SCRIPT, PORTRAIT_COMMAND, AS_ME_COMMAND, FIDELITY_COMMAND). Each
# skill keeps its own frontmatter and gets lead.md, do.md or fidelity.md,
# rendered with those values, between its portrait-build, portrait-do or
# portrait-fidelity markers. Every package can lead and carries the helper.
set -eu
here=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$here/.." && pwd)

# render <template> <vars>: {{SPEC}} lines become spec.md; {{KEY}} become values.
render() {
	awk -v spec="$here/spec.md" -v vars="$2" '
		BEGIN {
			while ((getline line < vars) > 0) {
				if (line == "" || line ~ /^#/) continue
				eq = index(line, "="); key = substr(line, 1, eq - 1); val = substr(line, eq + 1)
				gsub(/&/, "\\\\&", val); V["{{" key "}}"] = val
			}
		}
		$0 == "{{SPEC}}" { while ((getline s < spec) > 0) print s; close(spec); next }
		{ for (k in V) gsub(k, V[k]); print }
	' "$1"
}

# fill <skill> <marker> <template> <vars>: put the rendered template between
# the skill's <!-- <marker>:begin --> and <!-- <marker>:end --> lines; the
# skill keeps its own frontmatter.
fill() {
	body=$(mktemp)
	render "$3" "$4" > "$body"
	awk -v body="$body" -v b="<!-- $2:begin -->" -v e="<!-- $2:end -->" '
		$0 == b { print; while ((getline line < body) > 0) print line; close(body); skip = 1; next }
		$0 == e { skip = 0 }
		!skip { print }
	' "$1" > "$1.tmp"
	mv "$1.tmp" "$1"
	rm -f "$body"
}

for vars in "$root"/*/portrait.vars; do
	package=$(dirname "$vars")
	mkdir -p "$package/scripts" "$package/helpers/portrait-helper"
	cp "$here/portrait-agents" "$package/scripts/portrait-agents"
	chmod 755 "$package/scripts/portrait-agents"
	cp "$here/portrait" "$package/scripts/portrait"
	chmod 755 "$package/scripts/portrait"
	render "$here/helper.md" "$vars" > "$package/helpers/portrait-helper/SKILL.md"
	fill "$package/skills/build/SKILL.md" portrait-build "$here/lead.md" "$vars"
	fill "$package/skills/do/SKILL.md" portrait-do "$here/do.md" "$vars"
	fill "$package/skills/fidelity/SKILL.md" portrait-fidelity "$here/fidelity.md" "$vars"
	fill "$package/skills/publish/SKILL.md" portrait-publish "$here/publish.md" "$vars"
	fill "$package/skills/unpublish/SKILL.md" portrait-unpublish "$here/unpublish.md" "$vars"
done
