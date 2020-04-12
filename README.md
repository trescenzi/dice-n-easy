# dice-n-easy

An incredibly simple ruby discord die rolling bot. Others, while most are solid,
can be slow if they aren't self hosted, or are simply overly complicated.
`dice-n-easy` is built to be super simple to host and have a small
footprint, while still being customizable and handling most complex die rolls.

## Commands

`dice-n-easy` uses /syntruth/Dice-Bag for all its die rolling. Some common examples below:
- Advantage: `/r 2d20k1+5`
- Disadvantage: `/r 2d20d1+5`
- Reroll 1s: `/r 1d6 r1`
- Explode 5s and 6s: `/r 1d6 e5`

## Serving

`dice-n-easy` is intended to be really easy to serve via something like Heroku or
on a personal server. All that's required is to set the token environment
variable. However if you'd like you can customize what the bot looks for in
commands. The following variables are available:
- `DICENEASY_TOKEN`: The bot's token
- `DICENEASY_PREFIX`: The prefix for commands. Defaults to `/`
- `DICENEASY_ROLLCOMMAND`: The command for rolling dice. Defaults to `r`

## TOOD

- [ ] Add redis interface for macros
