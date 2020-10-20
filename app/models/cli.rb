require "tty-prompt"
require "pry"

class CLI 
    
    @@prompt = TTY::Prompt.new
    @@character = nil
    @@login = nil
    @@user = nil
    
    def welcome 
        system('clear')
        puts "Welcome to After Work, a stress quest party at Julia's house."
        sleep(2)
        puts "Will you make the right decisions? Only time will tell. 🧐" #fix later
        sleep(2.5) # nice to have a pause here
        self.login
    end

    # prompt.select("Username or Password not found.") do |option|
    #     option.choice "Log In"
    #     option.choice "Create an Account"

    def find_user_at_login
        @@user = User.find_user
        if @@user == nil
            system('clear')
            puts "We can't seem to find that username."
            puts " "
            options = ["Try again", "Create a new user"]
            selection = @@prompt.select("Would you like to try again or create a new user?", options)
            if selection == "Try again"
                self.find_user_at_login
            else 
                @@user = User.create_user_login
            end
        end
    end

    
    def login 
        options = ["Log in", "Create a new user"]
        selection = @@prompt.select("Would you like to log in or create a new user?", options)
        if selection == "Log in" 

            self.find_user_at_login
            # option for not being able to find user? maybe use find_or_create_by?
        else
            @@user = User.create_user_login
        end
        # binding.pry
        @@login = Login_Session.create(user_id: @@user.id)
        system('clear')
        puts "Welcome, #{@@user.username}!"
        sleep(1.5)
        # I think we should have a few more options for the user here - like "see lowest previous score" / "start the party" /
        # 
        self.user_options
        
    end


    def user_options
        options = ["Get The Party Started", "Change Password", "Delete Profile"]
        selection = @@prompt.select("What would you like to do?", options)
        if selection == "Get The Party Started"
            self.choose_character
        elsif selection == "Delete Profile"
            @@user.destroy
            system('clear')
            self.login
        else
            @@user.password = @@prompt.mask("Set a new password:")
            puts "Your password has been updated."
            self.user_options
        end
        system('clear')
    end

    def choose_character
        sleep(1.5)
        selection = @@prompt.select("Choose your party animal", %w(Caryn someone someone_else))
        @@character = Character.find_by(name: selection)

        # refactor the below?? setting character attributes into the login
        @@login.character_id = @@character.id
        @@login.anxiety_points = @@character.anxiety_points
        @@login.num_drinks = @@character.num_drinks
        # refactor login above??
        
        system('clear')
        if @@login.anxiety_points > 50
            puts "You had a really rough day at work today and you currently have #{@@login.anxiety_points}/100 anxiety points."
            puts "Can you lower your anxiety this evening?"
        else 
            puts "You had a relaxing day and you currently have #{@@login.anxiety_points}/100 anxiety points."
            puts "Can you keep your level of anxiety low this evening?"
        end
        sleep(1.5)
        self.transportation
    end

    # def check_points
    #     if @@login.anxiety_points > 70
    #         puts "I'm feeling very stressed. My anxiety level is at #{@@login.anxiety_points}/100."
    #         puts "I should be careful to make less stressful choices." #change text?
    #     elsif @@login.anxiety_points < 30 
    #         puts "I'm feeling good! My anxiety level is at #{@@login.anxiety_points}/100."
    #         puts "Party on!"
    #     else 
    #         puts "Things are okay. My anxiety level is at #{@@login.anxiety_points}/100."
    #         puts "something that we can change later"
    #     end
    # end

    # add an "leave party" option at every decision?

    def transportation
        puts " "
        puts "You're heading to Brooklyn from your job in Manhattan"
        options = ["bike", "subway", "Uber"]
        selection = @@prompt.select("How do you want to get there?", options)
        rand_number = rand(1..2)
        sleep(1.5)
        
        if selection == "bike" 
            puts "test"
            # binding.pry
            if rand_number == 1
                puts "It's a beautiful day for biking and the fresh air is rejuvenating! - 10 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 10}"
            else
                puts "A car passenger forgets to check the street before opening the door and you have to swerve dangerously to avoid getting hit. + 15 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points += 15}"
            end
            # binding.pry
        
        elsif selection == "subway" 
            if rand_number == 1
                puts "well done! You made the train as the doors were closing AND you were able to get a seat! -5 anxiety points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 5}"
            else
                puts "A car passenger forgets to check the street before opening the door and you have to swerve dangerously to avoid getting hit. + 15 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points += 15}"
            end
        
        elsif selection == "Uber" 
            if rand_number == 1
                puts "It's a beautiful day for biking and the fresh air is rejuvenating! - 10 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 10}"
            else
                puts "A car passenger forgets to check the street before opening the door and you have to swerve dangerously to avoid getting hit. + 15 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points += 15}"
            end
        end
        # self.say_hello
    end



    


end #end of CLI class


