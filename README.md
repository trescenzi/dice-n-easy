# dice-n-easy

An incredibly simple ruby discord die rolling bot. Others, while most are solid,
can be slow if they aren't self hosted, or are simply overly complicated.
`dice-n-easy` is built to be super simple to host and have a small
footprint, while still being customizable and handling most complex die rolls.

**To host on Heroku checkout the [heroku branch](/tree/heroku)**

## Commands

### Rolling Dice

`dice-n-easy` uses [Dice-Bag](//github.com/syntruth/Dice-Bag) for all its die rolling. Some common examples below:
- Advantage: `/r 2d20k1+5`
- Disadvantage: `/r 2d20d1+5`
- Reroll 1s: `/r 1d6 r1`
- Explode 5s and 6s: `/r 1d6 e5`

### Macros

`dice-n-easy` supports simple custom macros. Macros are user specific, and they
do care about nicknames. Users can have the same macro names so long as they
aren't nicknamed the same thing. In order to use macros you need to have a redis
db hooked up via environment variables as described below. If you don't provide
a redis db that's ok, you can still use the rolling features just not the
macros.

#### Adding Macros

Macros are added with `/am <macro name> <dice roll>`. The macro name cannot have
spaces and are case insensitive, the dice roll can however. Examples:
- `/am attack 1d20 + 5`
- `/am advantage_attack 2d20k1 + 5`

#### Using Macros

Macros are used with `/m <macro name>`. They cannot be combined with modifiers.
Examples:
- `/m attack`
- `/m advantage_attack`

## Serving

`dice-n-easy` is intended to be really easy to serve via something like Heroku or
on a personal server. All that's required is to set the token environment
variable. However if you'd like you can customize what the bot looks for in
commands. The following variables are available:
- `DICENEASY_TOKEN`: The bot's token
- `DICENEASY_REDISHOST`: The hostname of the redis db for storing macros.
  Defaults to `nil`. If not provided, macros won't work. Everything else will
  though.
- `DICENEASY_REDISPASSWORD`: The password for the redis db.
- `DICENEASY_PREFIX`: The prefix for commands. Defaults to `/`
- `DICENEASY_ROLLCOMMAND`: The command for rolling dice. Defaults to `r`
- `DICENEASY_ADDMACROCOMMAND`: The command for adding macros. Defaults to `am`
- `DICENEASY_USEMACROCOMMAND`: The command for using macros. Defaults to `m`
