require 'discordrb'
require 'dicebag'
require 'dotenv'

def check_user_or_nick(event)
  if event.user.nick != nil
    event.user.nick
  else
    event.user.name
  end
end

def roll_dice(dice_string)
  puts "Rolling #{dice_string}"
  dice   = DiceBag::Roll.new(dice_string)
  dice.result()
end

def format_dice_result(result, user)
  reason = ""
  result.each do |section|
    reason = "%s %sd%s:%s".% [reason, section.count, section.sides, section.tally] if defined? section.count
  end
  response = "#{user} Rolled: `#{result}` \n Breakdown: #{reason}"
  puts "Formatted dice response #{response}"
  response 
end

Dotenv.load
PREFIX = ENV['DICENEASY_PREFIX'] || '/'
ROLLCOMMAND = ENV['DICENEASY_ROLLCOMMAND'] || 'r'
REDIS_HOST = ENV['DICENEASY_REDISHOST']
REDIS_PASSWORD = ENV['DICENEASY_REDISPASSWORD']
ADD_MACRO_COMMAND = ENV['DICENEASY_ADDMACROCOMMAND'] || 'am'
USE_MACRO_COMMAND = ENV['DICENEASY_USEMACROCOMMAND'] || 'm'
TOKEN = ENV['DICENEASY_TOKEN']
puts "Using command prefix: %s" % PREFIX
puts "Using roll-command: %s" % ROLLCOMMAND
puts "Example roll: #{PREFIX}#{ROLLCOMMAND} 1d6+3"
puts "Example add macro: #{PREFIX}#{ADD_MACRO_COMMAND} attack 1d20+4"
puts "Example use macro: #{PREFIX}#{USE_MACRO_COMMAND} attack"
puts "Using redis #{REDIS_HOST} for macros" if REDIS_HOST
puts "Using a password for redis" if REDIS_HOST and REDIS_PASSWORD
puts "Using token: %s" % TOKEN.slice(-5,5)

@bot = Discordrb::Commands::CommandBot.new token: ENV['DICENEASY_TOKEN'], compress_mode: :large, ignore_bots: true, fancy_log: true, prefix: PREFIX
@bot.gateway.check_heartbeat_acks = false

@bot.command ROLLCOMMAND.to_sym do |event|
    puts "ROLLING: #{event.content}"
    input = event.content.strip
    user = check_user_or_nick(event)
    dice_prefix = "#{PREFIX}#{ROLLCOMMAND}"
    
    dice_string = input.delete_prefix(dice_prefix).strip
    begin
      event.respond format_dice_result(roll_dice(dice_string), user)
    rescue
      puts "Dice roll #{dice_string} failed"
      event.respond "#{user} oops! #{dice_string} doesn't compute. Please try again. Common dice rolls look like:\n- Advantage: `#{dice_prefix} 2d20k1+5`\n- Disadvantage: `#{dice_prefix} 2d20d1+5`\n- Reroll 1s: `#{dice_prefix} 1d6 r1`\n- Explode 5s and 6s: `#{dice_prefix} 1d6 e5`"
    end
end

if REDIS_HOST
  require 'redis'
  redis = Redis.new(host: REDIS_HOST, password: REDIS_PASSWORD)

  @bot.command ADD_MACRO_COMMAND.to_sym do |event|
    puts "ADD MACRO: #{event.content}"
    input = event.content.strip
    macro_name = input.split[1].upcase
    dice_string = input.split.drop(2).join(' ')
    user = check_user_or_nick(event)
    begin
      roll_dice(dice_string)
      key = "#{user}:#{macro_name}"
      redis.set(key, dice_string)
      event.respond "#{user} added macro #{input.split[1]} as #{dice_string}. Use with #{PREFIX}#{USE_MACRO_COMMAND} #{input.split[1]}"
    rescue
      puts "Add macro failed #{input}"
      event.respond "#{user} oops! #{input} isn't a macro. Add macros look like: #{PREFIX}#{ADD_MACRO_COMMAND} <macro name> <dice to roll>. Please make sure the dice command is valid and there are no spaces in the macro name."
    end
  end

  @bot.command USE_MACRO_COMMAND.to_sym do |event|
    puts "USE MACRO:#{event.content}"
    input = event.content.strip
    macro_name = input.split[1].upcase
    user = check_user_or_nick(event)
    begin
      key = "#{user}:#{macro_name}"
      dice_string = redis.get(key)
      event.respond format_dice_result(roll_dice(dice_string), user)
    rescue
      puts "Use macro failed #{input}"
      event.respond "#{user} oops! #{input} isn't a saved macro. Remember macros are user and nickname specific."
    end
  end
end
@bot.run
