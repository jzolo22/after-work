require "tty-prompt"
require "pry"

class CLI 
    
    @@prompt = TTY::Prompt.new
    @@character = nil
    @@login = nil
    
    def welcome 
        system('clear')
        puts "Welcome to After Work, an anxiety inducing quest to reduce anxiety!"
        sleep(1.5) # nice to have a pause here
        self.login
    end
    
    def login 
        puts "You've been invited to a party at Julia's house!"
        if @@prompt.yes?("Do you already have a login?") 
            @user = User.find_user
            # option for not being able to find user? maybe use find_or_create_by?
        else
            @user = User.create_user_login
        end
        @@login = Login_Session.create(user_id: @user.id)
        system('clear')
        puts "Welcome #{@user.username}!"
        sleep(1.5)
        self.choose_character
    end

    def choose_character
        # I think the "You've been invited" text should come after the login as the start of the story
        sleep(1.5)
        selection = @@prompt.select("Who would you like to be today?", %w(Caryn someone someone_else))
        # we should read up on and use the "select" TTY prompt here
        # character options
        @@character = Character.find_by(name: selection)

        @@login.character_id = @@character.id
        @@login.anxiety_points = @@character.anxiety_points
        @@login.num_drinks = @@character.num_drinks
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

    def check_points
        if @@login.anxiety_points > 70
            puts "I'm feeling very stressed. My anxiety level is at #{@@login.anxiety_points}/100."
            puts "I should be careful to make less stressful choices." #change text?
        elsif @@login.anxiety_points < 30 
            puts "I'm feeling good! My anxiety level is at #{@@login.anxiety_points}/100."
            puts "Party on!"
        else 
            puts "Things are okay. My anxiety level is at #{@@login.anxiety_points}/100."
            puts "something that we can change later"
        end
    end


    def transportation
        puts "You're heading to Brooklyn from your job in Manhattan"
        selection = @@prompt.select("How do you want to get there?", %w(bike subway uber))
        #bike / subway / Uber
        rand_number = rand(1..2)
        sleep(1.5)
        if selection == "bike" 
            if rand_number == 1
                puts "It's a beautiful day for biking and the fresh air is rejuvenating! - 10 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 10}"
            else
                puts "A car passenger forgets to check the street before opening the door and you have to swerve dangerously to avoid getting hit. + 15 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points += 15}"
            end
            # binding.pry
        end
        if selection == "subway" 
            if rand_number == 1
                puts "well done! You made the train as the doors were closing and you were able to get a seat! -5 anxiety points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 10}"
            else
                puts "A car passenger forgets to check the street before opening the door and you have to swerve dangerously to avoid getting hit. + 15 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points += 15}"
            end
        end
        if selection == "uber" 
            if rand_number == 1
                puts "It's a beautiful day for biking and the fresh air is rejuvenating! - 10 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 10}"
            else
                puts "A car passenger forgets to check the street before opening the door and you have to swerve dangerously to avoid getting hit. + 15 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points += 15}"
            end
        end
    end
    


end #end of CLI class


