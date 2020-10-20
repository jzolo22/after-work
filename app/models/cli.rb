require "tty-prompt"
require "pry"

class CLI 
    
    @@prompt = TTY::Prompt.new
    
    def welcome 
        system('clear')
        puts "Welcome to After Party! You've been invited to a party at Julia's house!"
        sleep(1.5) # nice to have a pause here
        self.login
    end
    
    def login 
        if @@prompt.yes?("Do you already have a login?") 
            User.find_user
            # returns this error: Could not find table 'users' (ActiveRecord::StatementInvalid)
        else
            # returns this error: Could not find table 'users' (ActiveRecord::StatementInvalid)
            User.create_user_login
        end
    end


end #end of CLI class