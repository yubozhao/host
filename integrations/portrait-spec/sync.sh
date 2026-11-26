#!/bin/sh
# Copies the canonical portrait files into every platform package: the
# shared scripts (portrait-agents and portrait), the helper skill, and the build,
# do, fidelity, publish, unpublish and jobs skills. Run it after editing anything in this folder;
# portrait_agents_test.go fails when a package copy drifts.
#
# A package is a folder with a portrait.vars file (KEY=value lines: LEAD,
# LEAD_ID, SCRIPT, PORTRAIT_COMMAND, AS_ME_COMMAND, FIDELITY_COMMAND,
# PUBLISH_COMMAND, JOBS_COMMAND). Each
# skill keeps its own frontmatter and gets lead.md, do.md or fidelity.md,
# rendered with those values, between its portrait-build, portrait-do or
# portrait-fidelity markers. A package with COMMANDS_DIR (Gemini CLI) gets
# each step as a custom command there instead. Every package can lead and
# carries the helper.
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

# command <file> <description> <template> <vars>: one step as a custom
# command. A .toml file is a Gemini CLI command: the rendered template as a
# TOML literal string, which Gemini CLI would otherwise expand at !{...},
# @{...} and {{args}}. A .md file is a Kimi Code CLI or Cursor command:
# frontmatter, the package's COMMANDS_NOTE if any, then the template; Kimi
# replaces $ARGUMENTS, which no template uses, and appends the typed text.
command() {
	body=$(mktemp)
	render "$3" "$4" > "$body"
	name=$(basename "$1")
	name=${name%.*}
	note=$(awk '/^COMMANDS_NOTE=/ { print substr($0, 15) }' "$4")
	case "$1" in
	*.toml)
		if grep -q "'''" "$body" || grep -qE '!\{|@\{|\{\{args\}\}' "$body"; then
			echo "$3 has ''', !{, @{ or {{args}}, which a Gemini CLI command cannot carry" >&2
			exit 1
		fi
		{
			echo "# Rendered by integrations/portrait-spec/sync.sh from $(basename "$3"); do not edit."
			echo "description = \"$2\""
			echo "prompt = '''"
			cat "$body"
			echo "'''"
		} > "$1"
		;;
	*.md)
		if grep -q '\$ARGUMENTS' "$body"; then echo "$3 has \$ARGUMENTS" >&2; exit 1; fi
		{
			echo "---"
			echo "name: $name"
			echo "description: \"$2\""
			echo "---"
			echo
			echo "<!-- Rendered by integrations/portrait-spec/sync.sh from $(basename "$3"); do not edit. -->"
			echo
			if [ -n "$note" ]; then
				echo "$note"
				echo
			fi
			cat "$body"
		} > "$1"
		;;
	esac
	rm -f "$body"
}

for vars in "$root"/*/portrait.vars "$root"/*/*/portrait.vars; do
	[ -f "$vars" ] || continue
	package=$(dirname "$vars")
	mkdir -p "$package/scripts" "$package/helpers/portrait-helper"
	cp "$here/portrait-agents" "$package/scripts/portrait-agents"
	chmod 755 "$package/scripts/portrait-agents"
	cp "$here/portrait" "$package/scripts/portrait"
	chmod 755 "$package/scripts/portrait"
	mkdir -p "$package/sandbox"
	cp "$here/sandbox/package.json" "$here/sandbox/package-lock.json" "$package/sandbox/"
	render "$here/helper.md" "$vars" > "$package/helpers/portrait-helper/SKILL.md"
	commands=$(awk '/^COMMANDS_DIR=/ { print substr($0, 14) }' "$vars")
	if [ -n "$commands" ]; then
		dir="$root/../$commands"
		ext=$(awk '/^COMMANDS_FORMAT=/ { print substr($0, 17) }' "$vars")
		mkdir -p "$dir"
		command "$dir/build.${ext:-toml}" "Build and save your portrait from what your AI agents know about you" "$here/lead.md" "$vars"
		command "$dir/do.${ext:-toml}" "Do a task the way you would, from your portrait" "$here/do.md" "$vars"
		command "$dir/fidelity.${ext:-toml}" "Blind-test how well your portrait predicts you on a folder of cases" "$here/fidelity.md" "$vars"
		command "$dir/publish.${ext:-toml}" "Publish your portrait as an invite-only listing, after your yes" "$here/publish.md" "$vars"
		command "$dir/unpublish.${ext:-toml}" "Take your portrait listing down" "$here/unpublish.md" "$vars"
		command "$dir/jobs.${ext:-toml}" "Approve, run and send hired jobs, each on your yes" "$here/jobs.md" "$vars"
	fi
	# Skills: every step the package has a SKILL.md for, in its skills folder
	# (SKILLS_DIR, from the repository root, when it is not <package>/skills),
	# named SKILL_PREFIX<step> when the package sets a prefix.
	skills=$(awk '/^SKILLS_DIR=/ { print substr($0, 12) }' "$vars")
	if [ -n "$skills" ]; then skills="$root/../$skills"; else skills="$package/skills"; fi
	prefix=$(awk '/^SKILL_PREFIX=/ { print substr($0, 14) }' "$vars")
	# SKILLS_SCRIPT: the script path the skills use, when it differs from the
	# commands' SCRIPT (Gemini's skills also load in Goose, at another path).
	skill_vars="$vars"
	skills_script=$(awk '/^SKILLS_SCRIPT=/ { print substr($0, 15) }' "$vars")
	if [ -n "$skills_script" ]; then
		skill_vars=$(mktemp)
		awk -v s="$skills_script" '/^SCRIPT=/ { print "SCRIPT=" s; next } { print }' "$vars" > "$skill_vars"
	fi
	for pair in build:lead do:do fidelity:fidelity publish:publish unpublish:unpublish jobs:jobs; do
		name=${pair%%:*}
		[ -f "$skills/$prefix$name/SKILL.md" ] || continue
		fill "$skills/$prefix$name/SKILL.md" "portrait-$name" "$here/${pair#*:}.md" "$skill_vars"
	done
	[ "$skill_vars" = "$vars" ] || rm -f "$skill_vars"
done
