# Publish the portrait

Publish the person's portrait as a listing others can find. Listing is by invite only, the person approves every job, and no money moves. This is the one step of the plugin that asks the person before acting.

## 1. Check it may be listed

Run `{{SCRIPT}} publish-check`. If it refuses, tell the person its message as it is, and stop: it names what to do next (fix a privacy finding, or raise the fidelity score). Otherwise it prints the fidelity, the portrait version and what would upload: the public card only. The portrait files stay on this computer, where hired jobs run.

## 2. Choose the listing name

Run `{{SCRIPT}} listing name`. It proposes the portrait's folder name and checks it with the listing server. If it prints that the name is not allowed or not available, tell the person in one line, ask them for the name they want (3 to 30 lowercase letters and digits, with single dots between them, such as `sam.lee`), and run `{{SCRIPT}} listing name <their name>` until it prints that the name is available. If it prints `Listings aren't open yet.`, say that and stop.

## 3. Draft the public card

Read the portrait's `PORTRAIT.md` and `scenarios.md`, and write the card to `~/.agents/portraits/<name>/publish/card.md`, exactly in this shape:

```
# <display name: what people call the person, such as Bo>
<a summary paragraph: who someone would be hiring and how they work, 2 or 3 sentences>

## Hire me for
- <a kind of work, one line>
- <a kind of work, one line>
- <a kind of work, one line>

## Sample answers
### <the title of a scenario in scenarios.md>
<what the agent would do there, 1 or 2 sentences>
### <the title of another scenario in scenarios.md>
<what the agent would do there, 1 or 2 sentences>

## Fidelity
<score>% from <K> decisions, portrait version <V>
```

The title is the display name the listing shows: the first name the portrait uses, 1 to 40 characters, never the listing name unless that is what people call them. If the portrait gives no name, ask the person once what people call them. Everywhere else in the card, call them by that name, never by the listing name. Take the fidelity line exactly from what `publish-check` printed. Prefer scenarios the person marked right. Use only what the portrait says: no names of clients or other people, no paths, email addresses or private details. Then run `{{SCRIPT}} card-check ~/.agents/portraits/<name>/publish/card.md` and fix the card until it prints `ok`.

## 4. Show exactly what would be public, and ask once

Show the person the card exactly as written and the listing name. Say that only this card uploads: the portrait, `corrections.md`, the logs and `versions/` stay on this computer. Then ask one question: "Publish this listing as <name>? (yes or no)". Wait for the answer. Only a clear yes publishes; anything else stops here, and nothing is uploaded.

## 5. Publish

On a clear yes, run `{{SCRIPT}} publish --yes`, with a command timeout of 10 minutes. The first time, it opens a sign-in page and prints its link and a code: tell the person to enter that code on the page, then the code sent to their email. The command waits up to 9 minutes for them and then uploads. If it fails, give its message as it is, such as `Listings aren't open yet.`, and stop. Never open, read or print `.publish` or any token; the script keeps the sign-in to itself.

## 6. Finish

Give the listing address it printed. Say in one line that it is invite only, that they approve every job, and that approved jobs run on this computer with {{JOBS_COMMAND}}. Then offer, in one line, to keep the listing current: `{{SCRIPT}} listing keep-current on` makes the weekly refresh redraft the card and upload it again. Do not turn it on yourself.
