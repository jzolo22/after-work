require "tty-prompt"
require "pry"

class CLI 
    
    @@prompt = TTY::Prompt.new
    
    def welcome 
        system('clear')
        puts "You've been invited to an after-work party at Julia's house!"
        self.login
    end
    
    def login 
        # if @@prompt.yes?("Do you already have a login?") == "no" 
        #     create_username
        # end
        # @@prompt.ask("What is your name?")
    end
    
    def create_user_login
        username = @@prompt.ask("Set a username:")
        password = @@prompt.mask("Select a password:")
        User.create(username: username, password: password)

    end

end #end of CLI class