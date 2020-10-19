require "tty-prompt"
require "pry"

class CLI 
    
    @@prompt = TTY::Prompt.new
    
    def welcome 
        system('clear')
        puts "You've been invited to an after-work party at Julia's house!"
    end
    

    @@prompt.ask("What is your name?", default: ENV["USER"])


end #end of CLI class