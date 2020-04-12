# dice-n-easy

An incredibly simple ruby discord die rolling bot. Sidekick, while wonderful, is
slow sometimes and since it doesn't seem to be open source dice-beta is built to
be a super minimal die roller, largely for use with 5e and other d20 systems.

## Commands

`dice-n-easy` uses syntruth/Dice-Bag for all its die rolling. Some common examples below:
- Advantage: `/r 2d20k1+5`
- Disadvantage: `/r 2d20d1+5`
- Reroll 1s: `/r 1d6 r1`
- Explode 5s and 6s: `/r 1d6 e5`

## Serving

`dice-n-easy` is intended to be really easy to serve via something like Heroku or
on a personal server. All that's required is to set the token environment
variable. However if you'd like you can customize what the bot looks for in
commands. The following variables are available:
- DICENEASY_TOKEN: The bot's token
- DICENEASY_PREFIX: The prefix for commands. Defaults to `/`
- DICENEASY_ROLLCOMMAND: The command for rolling dice. Defaults to `r`

## TOOD

- [ ] Add redis interface for macros
