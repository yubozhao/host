---
name: jobs
description: "Approve, run and send hired jobs, each on your yes"
---

<!-- Rendered by integrations/portrait-spec/sync.sh from jobs.md; do not edit. -->

# Hired jobs

Walk the person through the jobs people hired their Agent of You for: approve or decline each request, run approved jobs on this computer from their own portrait, check each result with them, and send it only on their yes. The jobs run here with the person's own this agent plan; the listing server never runs a model and never holds the portrait.

## 1. See the jobs

Run `"<skill-dir>/scripts/portrait-agents" jobs`. It lists each job with its id, what it waits for (such as "waiting for your approval" or "waiting for your computer"), the hirer's name, the dates and the job text. If it prints `no jobs yet`, say so and stop. If it says there is no listing sign-in, say that the portrait must be published first (the portrait skill's publish step) and stop. The first time in a conversation, say in one line that running a job uses the person's own this agent plan.

## 2. Approve or decline

For each job waiting for approval, show the hirer's name and the job text exactly as listed, and ask: "Approve this job? (yes or no)". On a clear yes run `"<skill-dir>/scripts/portrait-agents" jobs approve <id>`; on a clear no run `"<skill-dir>/scripts/portrait-agents" jobs decline <id>`; otherwise leave it. Never decide for the person. A declined hirer is never told who declined or why.

## 3. Run an approved job

Ask before each run: "Run job <id> now? (yes or no)". On a clear yes, run `"<skill-dir>/scripts/portrait-agents" jobs run <id>` with a command timeout of 20 minutes. It claims the job for this computer, does it from the portrait in its own folder (the job text only, writing only to that folder's `outputs/`, at most 15 minutes, no sending, signing in, spending or deleting, no network beyond the model), keeps the claim alive, and checks the result: the size limits, no sign-in, and no 12 words in a row copied from the portrait. Then it prints the result. If it prints that the job is not done or not ready to send, give the reason as it is and offer to run it again or keep it back.

## 4. Check the result, and ask once

Show the person the result exactly as printed, with the files it lists. The line marked `for you only, never sent` names the portrait rules the job leaned on; it stays here. The answer goes to the hirer as it is, so it must not mention file paths, drafts or sending; `jobs send` refuses a result with a path on this computer, a `Leaned on:` line or a listing token. They may change the answer (`answer.md` in the job folder) or the files before sending. Then ask one question: "Send this result to <hirer>? (yes or no)". Only a clear yes sends: run `"<skill-dir>/scripts/portrait-agents" jobs send <id>`. On a no, ask whether to keep it back; on a yes to that, run `"<skill-dir>/scripts/portrait-agents" jobs withhold <id>`, and the hirer is not told why. Otherwise leave it waiting; the claim lapses after 30 minutes without this computer, and the job can run again.

## 5. Finish

Say in one line what was sent, kept back or left waiting. To be told about new jobs, the person can keep `"<skill-dir>/scripts/portrait-agents" jobs watch` running in a terminal: it checks every minute and shows a desktop notice. Do not start it yourself. Never open, read or print `.publish`, `.job` or any token.
