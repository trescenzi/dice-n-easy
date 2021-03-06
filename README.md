# dice-n-easy

An incredibly simple ruby discord die rolling bot. Others, while most are solid,
can be slow if they aren't self hosted, or are simply overly complicated.
`dice-n-easy` is built to be super simple to host and have a small
footprint, while still being customizable and handling most complex die rolls.

The heroku branch is built to be able to be hosted easily on Heroku. A free tier app
paired with a free redis addon enables all of the features of `dice-n-easy`.
Just fork it and tell Heroku to deploy from that branch.

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
aren't nicknamed the same thing. In order to use macros you need to attach a
redis addon. `dice-n-easy` is currently written to support the Heroku Redis
addon and handles connecting to it automatically with the `REDIS_URL`
environment variable provided by the addon.

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

`dice-n-easy`'s Heroku branch is setup to be served by Heroku. 
All that's required is to set the token environment variable and make sure you
have a worker dyno turned on. The following variables are available for
additional customization:
- `DICENEASY_TOKEN`: The bot's token
- `DICENEASY_PREFIX`: The prefix for commands. Defaults to `/`
- `DICENEASY_ROLLCOMMAND`: The command for rolling dice. Defaults to `r`
- `DICENEASY_ADDMACROCOMMAND`: The command for adding macros. Defaults to `am`
- `DICENEASY_USEMACROCOMMAND`: The command for using macros. Defaults to `m`
- Redis: Used for macros. It not setup macros won't work everything else will though.
  - `DICENEASY_REDISHOST`: The hostname of the redis db for storing macros.
  - `DICENEASY_REDISPASSWORD`: The password for the redis db.
  - `REDIS_URL`: If provided will be used instead of the host + password.
