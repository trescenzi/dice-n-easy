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

Dotenv.load
PREFIX = ENV['DICENEASY_PREFIX'] || '/'
ROLLCOMMAND = ENV['DICENEASY_ROLLCOMMAND'] || 'r'
STRIPPREFIX = "#{PREFIX}#{ROLLCOMMAND}"
puts "Using command prefix: %s" % PREFIX
puts "Using roll-command: %s" % ROLLCOMMAND
puts "Example roll: #{STRIPPREFIX} 1d6+3"
puts "Using token: %s" % ENV['DICENEASY_TOKEN']
@bot = Discordrb::Commands::CommandBot.new token: ENV['DICENEASY_TOKEN'], compress_mode: :large, ignore_bots: true, fancy_log: true, prefix: PREFIX
@bot.gateway.check_heartbeat_acks = false

@bot.command ROLLCOMMAND.to_sym do |event|
    puts "#{event.content}"
    input = event.content
    user = check_user_or_nick(event)
    
    dice_string = input.delete_prefix(STRIPPREFIX).strip
    puts "#{user} is rolling #{dice_string}"
    begin
      dice   = DiceBag::Roll.new(dice_string)
      result = dice.result()
      reason = ""
      result.each do |section|
        reason = "%s %sd%s:%s".% [reason, section.count, section.sides, section.tally] if defined? section.count
      end
      response = "#{user} Rolled: `#{result}` \n Breakdown: #{reason}"
      puts response
      event.respond response
    rescue
      event.respond "#{user} oops! #{dice_string} doesn't compute. Please try again"
    end
end

@bot.run
