require "tty-prompt"
require "pry"

class CLI 
    
    @@prompt = TTY::Prompt.new
    
    def welcome 
        system('clear')
        puts "Welcome to After Work, an anxiety inducing quest to reduce anxiety!"
        sleep(1.5) # nice to have a pause here
        self.login
    end
    
    def login 
        if @@prompt.yes?("Do you already have a login?") 
            User.find_user
            # returns this error: Could not find table 'users' (ActiveRecord::StatementInvalid)

        else
            User.create_user_login
            # returns this error: Could not find table 'users' (ActiveRecord::StatementInvalid)
        end
    end


    # I think the "You've been invited" text should come after the login as the start of the story
    # puts "You've been invited to a party at Julia's house!"


end #end of CLI class