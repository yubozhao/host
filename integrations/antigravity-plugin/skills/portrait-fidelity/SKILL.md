---
name: portrait-fidelity
description: "Measure how well the person's portrait predicts their real decisions with a blind test on a folder of cases, and report the score. Use when the person runs /portrait-fidelity <cases-folder> or asks how accurate, faithful or calibrated their portrait is."
---

<!-- portrait-fidelity:begin -->
# Fidelity

Measure how well the person's portrait predicts what they actually decide, with a blind test.

## 1. Find the cases

The cases folder is the one the person named. If they named none, say in one line: "Name a cases folder: /portrait-fidelity <folder>, where each case is a folder with situation.md (what happened, without your answer) and answer.md (what you decided, and a one-line reason)." Then stop.

Never read `answer.md` yourself, and never open the cases' files: the test stays blind only if the script alone handles them.

## 2. Run the blind test

Run `"$HOME/.gemini/config/plugins/portrait/scripts/portrait-agents" eval <cases-folder>`. For each case it has /portrait-do answer the situation from the portrait alone, then a separate judge, which never sees the portrait, scores that answer against the person's real one: match, close or wrong. It prints one line per case and the score, and writes `results.md` in the cases folder.

If it prints that there is no portrait, say so in one line and offer /portrait-build.

## 3. Report

Say in two or three lines: the score and the number of cases, the portrait version it tested, and where `results.md` is. Then say that each wrong case is listed there as a candidate scenario, which can be added to the portrait's `scenarios.md` and marked with `~/.agents/portraits/<name>/scripts/portrait verdict`. Change nothing yourself.
<!-- portrait-fidelity:end -->
