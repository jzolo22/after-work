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
        options = ["Log In", "Create a New User", "Exit the Party"]
        selection = @@prompt.select("Would you like to log in or create a new user?", options)
        if selection == options[0] 
            self.find_user_at_login
        elsif selection == options[1]
            @@user = User.create_user_login
        elsif selection == options[2]
            puts "Catch you at the next one!"
            sleep(1.5)
            return
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
        selection = @@prompt.select("Choose your party animal", %w(Caryn Bob someone_else))
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
        return self.transportation
    end

    def check_points
        puts @@login.anxiety_points
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

    def leave_party
        puts "That's a shame! Hope to see you at the next party!"
        sleep(4)
        self.welcome
    end

    # add a "leave party" option at every decision?

    def transportation
        system('clear')
        puts "You're heading to Brooklyn from your job in Manhattan"
        options = ["bike", "subway", "Uber"]
        selection = @@prompt.select("How do you want to get there?", options)
        rand_number = rand(1..2)
        # sleep(1.5)
        
        if selection == "bike" 
            if rand_number == 1
                puts "It's a beautiful day for biking and the fresh air is rejuvenating! - 10 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 10}."
            else
                puts "A car passenger forgot to check the street before opening the door and I had to swerve dangerously to avoid getting hit. + 15 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points += 15}."
            end
        
        elsif selection == "subway" 
            if rand_number == 1
                puts "I made the train as the doors were closing AND I was able to get a seat! -5 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 5}."
            else
                puts "The train was packed and I got caught in between an \"It's Showtime!\" group and someone who forgot to put on deodorant this morning. + 10 Anxiety Points"
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


    # def drinking
    #     @@login.num_drinks += 1
    #         if @@character.alcohol_problem && @@login.num_drinks == 1
    #             puts "This feels amazing, but it might be the beginning of a slippery slope... -5 Anxiety Points"
    #             puts "Your anxiety score is now #{@@login.anxiety_points -= 5}."
    #         elsif @@character.alcohol_problem && @@login.num_drinks == 2
    #             puts "Maybe I should lay off the drinking, I don't want to embarrass myself... NAH, keep 'em coming! +5 Anxiety Points"
    #             puts "Your anxiety score is now #{@@login.anxiety_points += 5}."
    #         elsif @@character.alcohol_problem && @@login.num_drinks == 3
    #             puts "Alright, this is going to be the last one for sure! +15 Anxiety Points"
    #             puts "Your anxiety score is now #{@@login.anxiety_points += 15}."
    #         elsif @@character.alcohol_problem && @@login.num_drinks > 3
    #             puts "Shoot... I'm a little tipsyyyyyy. +15 Anxiety Points"
    #             puts "Your anxiety score is now #{@@login.anxiety_points += 15}."
    #         elsif @@character.alcohol_problem == false && @login.num_drinks == 1
    # end

    def arrive_to_party
        sleep(2)
        puts ""
        # system('clear')
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
            else
                puts "There will be other opportunities for drinking later. I'd rather mingle and make some new friends now. -0 Anxiety Points"
                puts "Your anxiety score is still #{@@login.anxiety_points}."
            end
        elsif selection == "Maybe! What are your drink options?"
            puts "Oops, the host definitely thinks I'm high maintenance. +5 Anxiety Points"
            puts "Your anxiety score is now #{@@login.anxiety_points += 5}."
        end
        # insert pause?
        sleep(1.5)
        puts ""
        options = ["The weather is perfect, I'll check out the backyard.", "This party seems lame, I actually just want to go home."]
        # maybe we add a drink option here?
        selection = @@prompt.select("The host is inviting me outside...", options)
            if selection == options[1]
                self.leave_party
            elsif selection == options[0]
                self.backyard_intro
            end     
    end

    def backyard_intro
        sleep(4)
        system('clear')
        puts "DANG! What a huge backyard.. and in NYC of all places!"
        options = ["Chat with new people", "Grab another drink 😎", "Help get this party started!"]
        selection = @@prompt.select("Hmmmm... what should I get into first?", options)
        rand_number = rand(1..2)
        if selection == options[0]
            if rand_number == 1
                puts "Wow I just had a great conversation with a new cutie but still don't know if they were single 😬 + 5 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points += 5}."
            else
                puts "Well my old co-worker made me feel like garbage... apparently my old boss hated me. +15 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points += 15}."
            end
        elsif selection == options[1]
            # I'm confused on this one ... they selected to have a drink above but the "else" statement implies they're not drinking I think
            @@login.num_drinks += 1
            if rand_number == 1
                puts "This week has been too long for me to NOT have another drink! - 5 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 5}."
            else
                puts "Everybody is drinking and I feel like a weirdo with this La Croix. +15 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points += 15}."
            end
        elsif selection == options[2]
            # Kind of confused with this one too ... they selected to help the grill master but then are potentially setting up the volleyball net
            # I wonder if we should incorporate the dog allergy into this one too? (I wrote one in, feel free to change or take out)
            if rand_number == 1
                puts "Well I never knew setting up a volleyball net was such a breeze and I got to play with the DOG! -20 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points -= 20}."
                if @@character.dog_allergy 
                    sleep(3)
                    puts ""
                    puts "Oh no!! I forgot to take my allergy meds today and playing with the dog gave me an embarrassing rash 😫 +20 Anxiety Points"
                    puts "Your anxiety score is now #{@@login.anxiety_points += 20}."
                end
            else
                puts "Dang I wasnt planning on trying out for top chef!  This ARTIST is a real Type A chef and they need me for the next hour to prepare their masterpiece. +15 Anxiety Points"
                puts "Your anxiety score is now #{@@login.anxiety_points += 15}."
            end
        end
        self.food
    end


    def food
        options = ["Let's eat!!", "I should totally save my calories for the drinks and have another.", "I should see if my volleyball skills are as good as I remember." "This party seems lame, I actually just want to go home."]
        selection = @@prompt.select("Looks like dinner is ready!", options)
            if selection == options[0]
                
            elsif selection == options[1]
                # self.drink?
            elsif selection == options[2]
                
            elsif selection == options[3]
                self.leave_party
            end  

    end
 
    def the_party_starts_to_thin
        sleep(4)
        system('clear')
        puts "Ok it is getting late and I dunno where everyone went."
        options = ["Talk to this cutie?", "Help Julia clean up the crazy mess."]
        selection = @@prompt.select("How do I make my exit?", options)
        if selection == options[0]
            puts "That did not go over well... I looked like a damn FOOL that cutie has a partner who is super chill."
            puts "Im out"
            puts "Your anxiety score is now #{@@login.anxiety_points += 20}."
            sleep(4)
            puts "Stepping off Julia's stoop #{@@character.name} find a $100 bill on the ground. Your phone buzzes and it is a text message" 
            puts "from your best friend telling you how proud they are of you - Anxiety Points are back to #{@@character.anxiety_points},"
            puts "same as when #{@@character.name} arrived."
            #do we build code to actually calculate the total diff in anxiety points from the beginning and add that difference back?
            #or do we save their score for the end of the game
        elsif selection == options[1]
            puts "Wow that was a ton of work but I feel great! Julia is such a great host and I am leaving feeling a huge sense of accomplishment. -15 Anxiety Points "
            puts "Your anxiety score is now #{@@login.anxiety_points -= 15}."
            sleep(4)
            puts "Stepping off Julia's stoop #{@@character.name} find a $100 bill on the ground. Your phone buzzes and it is a text message" 
            puts "from your best friend telling you how proud they are of you - Anxiety Points are same as when #{@@character.name} arrived."
            #do we build code to actually calculate the total diff in anxiety points from the beginning and add that difference back?
            #or do we save their score for the end of the game
        end
    end

end #end of CLI class


