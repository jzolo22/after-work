require "tty-prompt"
require "pry"

class CLI 
    
    @@prompt = TTY::Prompt.new
    @@character = nil
    
    def welcome 
        system('clear')
        puts "Welcome to After Work, an anxiety inducing quest to reduce anxiety!"
        sleep(1.5) # nice to have a pause here
        self.login
    end
    
    def login 
        if @@prompt.yes?("Do you already have a login?") 
            @user = User.find_user
            # option for not being able to find user? maybe use find_or_create_by?
        else
            @user = User.create_user_login
        end
        system('clear')
        puts "Welcome #{@user.username}!"
        sleep(1.5)
        self.choose_character
    end

    def choose_character
        # I think the "You've been invited" text should come after the login as the start of the story
        puts "You've been invited to a party at Julia's house!"
        selection = @@prompt.select("Who would you like to be today?", %w(Caryn someone someone_else))
        # we should read up on and use the "select" TTY prompt here
        # character options
        @@character = Character.find_by(name: selection)
        system('clear')
        puts "You had a really rough day at work today and you currently have #{@@character.anxiety_points}/100 anxiety points. Can you lower your anxiety this evening?"
        sleep(1.5)
        self.transportation
    end

    # should each decision be its own method? I wasn't sure...

    def transportation
        puts "You're heading to Brooklyn from your job in Manhattan"
        puts "How do you want to get there?"
           # "select" TTY prompt here
        #bike / subway / Uber
        if bike # randomize 2 options
            # it's a beautiful day for biking and the fresh air is rejuvenating! - 10 AP
            # @@character.anxiety_points -= 10
            # display @@character.anxiety_points

            # a car passenger forgets to check the street before opening the door and you have to swerve
            # dangerously to avoid getting hit. + 15 AP
        end

        if subway
        end

        if uber
        end
    end
    


end #end of CLI class