require "tty-prompt"
require "pry"

class CLI 
    
    @@prompt = TTY::Prompt.new
    
    def welcome 
        system('clear')
        puts "Welcome to After Party! You've been invited to a party at Julia's house!"
        # might be nice to have a pause here
        self.login
    end
    
    def login 
        if @@prompt.yes?("Do you already have a login?") 
            find_user
        else
            create_user_login
        end
        # @@prompt.ask("What is your name?")
    end

    # def find_user
    #     username = @@prompt.ask("What is your username?")
    #     password = @@prompt.mask("What is your password?")
    #     User.find_by(username: username, password: password)
    # end
    
    # def create_user_login
    #     username = @@prompt.ask("Set a username:")
    #     password = @@prompt.mask("Select a password:")
    #     User.create(username: username, password: password)
    # end

end #end of CLI class