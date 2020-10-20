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
        # sleep(2)
        puts "Will you make the right decisions? Only time will tell. 🧐" #fix later
        # sleep(2.5) # nice to have a pause here
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
        # sleep(1.5)
        # I think we should have a few more options for the user here - like "see lowest previous score" / "start the party" /
        # 
        self.user_options
        
    end


    def user_options
        options = ["Get The Party Started", "Change Password", "Delete Profile"]
        selection = @@prompt.select("What would you like to do?", options)
        if selection == "Get The Party Started"
           return self.choose_character
        elsif selection == "Delete Profile"
            @@user.destroy
            system('clear')
            self.login
        else
            @@user.password = @@prompt.mask("Set a new password:")
            puts "Your password has been updated."
            self.user_options
        end
        # binding.pry
        # system('clear')
    end

    def choose_character
        # sleep(1.5)
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
        # sleep(1.5)
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
        system('clear')
        puts "You're heading to Brooklyn from your job in Manhattan"
        options = ["bike", "subway", "Uber"]
        selection = @@prompt.select("How do you want to get there?", options)
        rand_number = rand(1..2)
        # sleep(1.5)
        
        if selection == "bike" 
            # binding.pry
            if rand_number == 1
                puts "It's a beautiful day for biking and the fresh air is rejuvenating! - 10 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 10}."
            else
                puts "A car passenger forgets to check the street before opening the door and you have to swerve dangerously to avoid getting hit. + 15 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points += 15}."
            end
            # binding.pry
        
        elsif selection == "subway" 
            if rand_number == 1
                puts "Well done! You made the train as the doors were closing and you were able to get a seat! -5 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 5}."
            else
                puts "Oh no! The train was packed and you got caught in between an Its showtime group and someone who forgot to put on deodorant that morning. + 10 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points += 10}."
            end
        elsif selection == "Uber"
            if rand_number == 1
                puts "My Driver was a total sweetie and let me play my own tunes! -10 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 10}."
            else
                puts "My Uber driver showed up late, drove like a maniac, AND didn't have a mask on! +15 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points += 15}."
            end
        end
        self.arrive_to_party
    end

    def arrive_to_party
        system('clear')
        puts "Hello hello!! Welcome to the party! I'm your host, Julia."
        options = ["Oooh yes please! A drink is exactly what I need!", "No, thank you. I'm not sure that's a good idea.", "Maybe! What are your drink options?"]
        selection = @@prompt.select("Can I get you a drink before you head outside?", options)
        if selection == options[0]
            @@login.num_drinks += 1
            if @@character.alcohol_problem
                puts "This feels amazing, but it might be the beginning of a slippery slope... -5 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 5}."
            else
                puts "Thank you so much! What a delicious cocktail. -10 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 10}."
            end
        elsif selection == options[1]
            if @@character.alcohol_problem
                puts "That was definitely the right choice. Drinking can get me into trouble.  -10 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 10}."
            end

        elsif selection == "Maybe! What are your drink options?"
        end

    end



    


end #end of CLI class


