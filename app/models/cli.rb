require "tty-prompt"
require "tty-font"
require "pry"
require "pastel"

# keep track of how many choices they've made and put them into the party winding down method?

class CLI 
    
    @@prompt = TTY::Prompt.new(active_color: :magenta )
    @@ascii = Artii::Base.new 
    @@pastel = Pastel.new
    @@anx_print = @@pastel.red.bold.detach

    @@character = nil
    @@login = nil
    @@user = nil
    
    # pauses in here are good!!!
    def welcome  
        system('clear')
        puts @@pastel.bold("Welcome to")
        # sleep(1.5)
        puts @@pastel.yellow("#{@@ascii.asciify("After Work")}")
        # sleep(1.5)
        puts @@pastel.bold("A stress quest party at Julia's house.")
        puts ""
        # sleep(2)
        puts "Will you make the right decisions?"
        # sleep(2)
        puts "Only time will tell. 🧐" #fix later
        puts ""
        # sleep(2) 
        self.login
    end


    #pauses here are good!
    def find_user_at_login
        @@user = User.find_user
        if @@user == nil
            system('clear')
            puts "We can't seem to find that username."
            puts " "
            # sleep(1)
            options = ["Try again", "Create a new user"]
            selection = @@prompt.select("Would you like to:", options)
            if selection == "Try again"
                self.find_user_at_login
            else 
                @@user = User.create_user_login
            end
        end
    end

    
    def login 
        options = ["Log In", "Create a New User", "Exit the Party"]
        selection = @@prompt.select("Would you like to:", options)
        if selection == options[0] 
            self.find_user_at_login
        elsif selection == options[1]
            @@user = User.create_user_login
        elsif selection == options[2]
            puts "Catch you at the next one!"
            # sleep(1.5)
            return
            binding.pry
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
        system('clear')
    end

    def choose_character
        # sleep(1.5)
        selection = @@prompt.select("Choose your party animal", %w(Caryn Bob someone_else))
        @@character = Character.find_by(name: selection)

        # refactor the below?? setting character attributes into the login
        @@login.character_id = @@character.id
        @@login.anxiety_points = @@character.anxiety_points
        @@login.num_drinks = @@character.num_drinks
        # binding.pry
        # refactor login above??
        
        system('clear')
        if @@login.anxiety_points > 50
            puts "Work was terrible today! My anxiety is through the roof at " + @@anx_print.("#{@@login.anxiety_points}/100.")
            puts "Hopefully this party will help me lower my anxiety level."
        else 
            puts "Work was so fun today! I got so much done, and my stress level is nice and low at " + @@pastel.green("#{@@login.anxiety_points}/100.")
            puts "Hopefully this party doesn't stress me out."
        end
        sleep(1.5)
        return self.transportation
    end

    # def check_points
    #     puts @@login.anxiety_points
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

    def leave_party
        puts "That's a shame! Hope to see you at the next party!"
        sleep(4)
        self.welcome
    end

    # add a "leave party" option at every decision?

    def transportation
        sleep(3.5)
        system('clear')
        puts "The party is in Brooklyn, but my job is in SoHo."
        puts ""
        options = ["Bike", "Subway", "Uber"]
        selection = @@prompt.select("How should I get to the party?", options)
        rand_number = rand(1..2)
        sleep(1.5)
        
        if selection == "bike" 
            if rand_number == 1
                puts "It's a beautiful day for biking and the fresh air is rejuvenating! - 10 Anxiety Points"
                @@login.anxiety_points -= 10
                # binding.pry
            else
                puts "A car passenger forgot to check the street before opening the door and I had to swerve dangerously to avoid getting hit. + 15 Anxiety Points"
                @@login.anxiety_points += 15
            end
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"

        elsif selection == "subway" 
            if rand_number == 1
                puts "I made the train as the doors were closing AND I was able to get a seat! -5 Anxiety Points"
                @@login.anxiety_points -= 5
            else
                puts "The train was packed and I got caught in between an \"It's Showtime!\" group and someone who forgot to put on deodorant this morning. + 10 Anxiety Points"
                @@login.anxiety_points += 15
            end
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
        elsif selection == "Uber"
            if rand_number == 1
                puts "My Driver was a total sweetie and let me play my own tunes! -10 Anxiety Points"
                @@login.anxiety_points -= 10
            else
                puts "My Uber driver showed up late, drove like a maniac, AND didn't have a mask on! +15 Anxiety Points"
                @@login.anxiety_points += 15
            end
        end
        sleep(2.5)
        self.arrive_to_party
    end
    
    def arrive_to_party
        sleep(2)
        puts ""
        system('clear')
        puts "My anxiety score is: #{@@login.anxiety_points}/100"
        puts ""
        puts "Hello hello!! Welcome to the party, #{@@character.name}! I'm your host, Julia."
        puts ""
        options = ["Oooh yes please! A drink is exactly what I need!", "No, thank you. I'm not sure that's a good idea.", "Maybe! What are your drink options?"]
        selection = @@prompt.select("Can I get you a drink before you head outside?", options)
        if selection == options[0]
            @@login.num_drinks += 1
            if @@character.alcohol_problem
                puts "This feels amazing, but it might be the beginning of a slippery slope... -5 Anxiety Points"
                sleep(2)
                @@login.anxiety_points -= 5
            else
                system('clear')
                puts "Thank you so much! What a delicious cocktail. -10 Anxiety Points"
                sleep(2)
                @@login.anxiety_points -= 10
            end
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
        elsif selection == options[1]
            if @@character.alcohol_problem
                puts "That was definitely the right choice. Drinking can get me into trouble.  -10 Anxiety Points"
                sleep(2)
                @@login.anxiety_points -= 10
            else
                puts "There will be other opportunities for drinking later. I'd rather mingle and make some new friends now. -0 Anxiety Points"
                sleep(2)
            end
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
        elsif selection == "Maybe! What are your drink options?"
            puts "Oops, the host definitely thinks I'm high maintenance. +5 Anxiety Points"
            sleep(2)
            @@login.anxiety_points += 5
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
            options = ["Beer", "Wine", "Vodka"]
            selection = @@prompt.select("We dont have a full bar 🙄 but... grab whatever you like out of the fridge!", options)
            if selection == options[0]
                @@login.num_drinks += 1
            elsif selection == options[1]
                @@login.num_drinks += 1
            elsif selection == options[2]
                @@login.num_drinks += 2
            end       
        end
        sleep(1.5)
        system('clear')
        puts "My anxiety score is: #{@@login.anxiety_points}/100"
        puts ""
        options = ["The weather is perfect, I'll check out the backyard.", "I'm actually going to drop these chips off in the kitchen but I'll be right out!", "This party seems lame, I actually just want to go home."]
        selection = @@prompt.select("The host is inviting me outside...", options)
        if selection == options[0]
            puts "DANG! What a huge backyard.. and in NYC of all places!"
            puts "Hmmmm... what should I get into first?"
            sleep(2)
            self.backyard_intro
        elsif selection == options[1]
            puts "WOW, a dishwasher AND an espresso machine? This host must be a software engineer! 😉"
            sleep(2)
            self.kitchen
        elsif selection == options[2]
            self.leave_party
        end   
    end
    
    def check_num_drinks
        puts "I think I've had #{@@login.num_drinks}..."
        if @@login.num_drinks == 0 && @@character.alcohol_problem
            puts "Maybe I should keep it that way!"
        elsif @@login.num_drinks == 0 && @@character.alcohol_problem == false
            puts "I should relax with a beverage!"
        elsif @@login.num_drinks == 1 && @@character.alcohol_problem 
            puts "I probably shouldn't have much more."
        elsif @@login.num_drinks == 2 && @@character.alcohol_problem
            puts "I need to slow down."
        elsif @@login.num_drinks == 3 && @@character.alcohol_problem
            puts "Things are getting out of hand."
        elsif @@login.num_drinks > 3 && @@character.alcohol_problem
            puts "Yeeeeeehaw!! I'm gonna climb on the table!!"
        elsif @@login.num_drinks == 1 && @@character.alcohol_problem == false
            puts "This party is great!"
        elsif @@login.num_drinks == 2 && @@character.alcohol_problem == false
            puts "I'm really going to let loose tonight."
        elsif @@login.num_drinks == 3 && @@character.alcohol_problem == false
            puts "Should I text my ex??"
        elsif @@login.num_drinks > 3 && @@character.alcohol_problem == false
            puts "Good thing I have my hangover remedies ready to go."
        end
    end

    def kitchen
        options = ["I wanna catch up with the homies", "I'm gonna sneak a bottle from the fridge", "I could use some fresh air. The backyard is calling to me.", "How many drinks have I had? 🤔", "I gotta use the bathroom BAD", "This kitchen is a mess, I'm gonna sneak out and go home before anybody else sees me."]
        selection = @@prompt.select("", options, per_page: 6)
        if selection == options[0]
            self.chat
            puts "Dang Julia knows tons of people."
            self.kitchen
        elsif selection == options[1]
            self.drink
            puts "Ug she even has one of those fancy smart fridges."
            self.kitchen
        elsif selection == options[2]
            puts "DANG! What a huge backyard.. and in NYC of all places!"
            return self.backyard_intro
        elsif selection == options[3]
            self.check_num_drinks
            self.kitchen
        elsif selection == options[4]
            self.bathroom
            puts "Julia has a really nice apartment."
            self.kitchen
        elsif selection == options[5]
            return self.leave_party
        end 
    end

    def bathroom
        rand_number = rand(1..3)
        if rand_number == 1
            puts "Julia caught me snooping through her cabinets and now I feel like a creep 😬 + 10 Anxiety Points"
            @@login.anxiety_points += 10
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
        elsif rand_number == 2
            puts "Wow I really needed to go and feel 1000 times better.  I am ready to party! -10 Anxiety Points"
            @@login.anxiety_points -= 10
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
        elsif rand_number == 3
            puts "It feels like a spa in here I need to ask Julia where she got those candles! -5 Anxiety Points"
            @@login.anxiety_points -= 5
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
        end
        puts "My anxiety score is: #{@@login.anxiety_points}/100"
        puts ""
        sleep(2)
        puts ""
    end

    def drink
        system('clear')
        options = ["Beer", "Wine", "Vodka"]
        selection = @@prompt.select("What's my poison tonight?", options)
        if selection == options[0]
            @@login.num_drinks += 1
        elsif selection == options[1]
            @@login.num_drinks += 1
        elsif selection == options[2]
            @@login.num_drinks += 2
        end       
    end
    
    def chat
        system('clear')
        puts ""
        rand_number = rand(1..9)
        if rand_number == 1
            puts "Wow I just had a great conversation with a new cutie but still don't know if they're single 😬 + 5 Anxiety Points"
            @@login.anxiety_points += 5
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
        elsif rand_number == 2
            puts "Well my old co-worker made me feel like garbage... apparently my old boss hated me. +15 Anxiety Points"
            @@login.anxiety_points += 15
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
        elsif rand_number == 3
            puts "OMG I just lost 15 minutes of my life having that worthless conversation. +5 Anxiety Points"
            @@login.anxiety_points += 5
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
        elsif rand_number == 4
            puts "I have been looking for a new job for months and this person might actually help me get one! -20 Anxiety Points"
            @@login.anxiety_points -= 20
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
        elsif rand_number == 5
            puts "That was really weird this person started asking me way too many personal questions! +10 Anxiety Points"
            @@login.anxiety_points += 10
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
        elsif rand_number == 6
            puts "They were super sweet and that is cool they know my best friend Ebenezer! -10 Anxiety Points"
            @@login.anxiety_points -= 10
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
        elsif rand_number == 7
            puts "They were so cool and noticed my sneakers! Now I feel great! -10 Anxiety Points"
            @@login.anxiety_points -= 10
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
        elsif rand_number == 8
            puts "That was such a good intereaction they invited me to a BBQ at their house next week! -10 Anxiety Points"
            @@login.anxiety_points -= 10
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
        elsif rand_number == 9
            puts "They were very kind and read my astrological chart but I think I am now even more confused about life?!? -0 Anxiety Points"
            # puts "My anxiety score is still: #{@@login.anxiety_points}/100"
        end
        puts "My anxiety score is: #{@@login.anxiety_points}/100"
        puts ""
        sleep(2)
    end

    def backyard_intro
        sleep(4)
        system('clear')
        puts "My anxiety score is: #{@@login.anxiety_points}/100"
        puts ""
        options = ["Head back into the Kitchen", "Grab a drink 😎", "Help get this party started!", "Hang with the DOG!", "I should see if my volleyball skills are as good as I remember.", "Looks like dinner is ready!", "Is everyone leaving?", "How many drinks have I had? 🤔"]
        selection = @@prompt.select("", options, per_page: 8)
        rand_number = rand(1..2)
        if selection == options[0]
        #     self.chat
        #         puts "What else should I do?"
        #     self.backyard_intro
              self.kitchen
        elsif selection == options[1]
            if rand_number == 1
                @@login.num_drinks += 1
                puts "This week has been too long for me to NOT have another drink! - 5 Anxiety Points"
                @@login.anxiety_points -= 5
                # puts "My anxiety score is: #{@@login.anxiety_points}/100"
            else
                puts "Wow somebody just handed me this nasty cocktail and now I feel like I am gonna get sick 🤢. +15 Anxiety Points"
                @@login.anxiety_points += 15
                # puts "My anxiety score is: #{@@login.anxiety_points}/100"
            end
            self.backyard_intro
        elsif selection == options[2]
            if rand_number == 1
                sleep(2)
                puts "Well I never knew setting up a volleyball net was such a breeze! -5 Anxiety Points"
                @@login.anxiety_points -= 5
                sleep(1.5)
            else
                sleep(2)
                puts "Dang I wasnt planning on trying out for top chef!"
                puts "This ARTIST is a real Type A chef and they need me for the next hour to prepare their masterpiece."
                puts "+15 Anxiety Points"
                @@login.anxiety_points += 15
                sleep(2.5)
            end
            # puts "Your anxiety score is #{@@login.anxiety_points}/100."
            # sleep(2)
            self.backyard_intro
        elsif  selection == options[3]
            if @@character.dog_allergy 
                sleep(2)
                puts ""
                puts "Oh no!! I forgot to take my allergy meds today and playing with the dog gave me an embarrassing rash 😫 +20 Anxiety Points"
                @@login.anxiety_points += 20
            else
                puts "What a good little stinker... I feel GREAT! -10 Anxiety Points"
                @@login.anxiety_points -= 10
            end
            # puts "Your anxiety score is #{@@login.anxiety_points}/100."
            puts ""
            sleep(2.5)
            puts "What else is going on in the backyard?"
            self.backyard_intro
        elsif selection == options[4]
            if rand_number == 1
                puts "All these home workouts I've been doing are showing! My friends are totally impressed with my skills. -10 Anxiety Points"
                @@login.anxiety_points -= 10
            else 
                puts "OUCH. I need to get back to the gym, I'm pretty sure I just pulled a muscle, and now my new pants are dirty. +10 Anxiety Points"
                @@login.anxiety_points += 10
            end
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
            sleep(2)
            self.backyard_intro
        elsif selection == options[5]
            self.food
        elsif selection == options[6]
            return self.the_party_starts_to_thin
        elsif selection == options[7]
            self.check_num_drinks
            self.backyard_intro
        end
    end
    
    
    def food
        # puts "My anxiety score is: #{@@login.anxiety_points}/100"
        # puts ""
        options = ["Let's eat!!", "I should totally save my calories for the alcohol and have a drink.", "This party seems lame, I actually just want to go home."]
        selection = @@prompt.select("", options)
        rand_number = rand(1..2)
        if selection == options[0]
            if rand_number == 1
                puts "The grilled shrimp is incredible and I was about to crash, so this dinner is coming in clutch. -10 Anxiety Points"
                @@login.anxiety_points -= 15
                puts "Now I can keep going all night!"
            else 
                puts "Yuck, this chicken is not even cooked all the way through! I hope I don't get sick. +10 Anxiety Points"
                @@login.anxiety_points += 10
                # sleep(2)
                puts "Well... the party must go on."
            end
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
            self.backyard_intro
        elsif selection == options[1]
            if @@character.alcohol_problem && @@login.num_drinks > 3
                puts "I need to slow down, or else things are going to spiral out of control. +15 Anxiety Points"
                @@login.anxiety_points += 15
            elsif @@character.alcohol_problem && @@login.num_drinks.between?(2,3)
                puts "My hangover is going to be awful tomorrow. +15 Anxiety Points."
                @@login.anxiety_points += 10
            elsif @@character.alcohol_problem && @@login.num_drinks == 1
                puts "This is the beginning of a slippery slope."
                @@login.anxiety_points += 5
            elsif @@character.alcohol_problem == false && @@login.num_drinks.between?(2,3)
                puts "I am feeling fluffy!"
                @@login.anxiety_points -= 5
            elsif @@character.alcohol_problem == false && @@login.num_drinks == 1
                puts "Dont mind if I do."
            elsif @@character.alcohol_problem == false && @@login.num_drinks > 3
                puts "This is the beginning of a slippery slope."
            end
            # puts "My anxiety score is: #{@@login.anxiety_points}/100"
            self.backyard_intro
        elsif selection == options[2]
            self.leave_party
        end  
    end
 
    def the_party_starts_to_thin
        sleep(4)
        system('clear')
        puts "My anxiety score is: #{@@login.anxiety_points}/100"
        puts ""
        puts "Yeah, it is getting late and people are trickling out."
        options = ["Let me get this cutie's number before I leave.", "I should help Julia clean up the crazy mess."]
        selection = @@prompt.select("How do I make my exit?", options)
        if selection == options[0]
            if @@character.outgoing == true 
                puts "BAM! Not only did I get cutie's number we even set something up for next weekend!"
                # @@login.anxiety_points -=15
            else
                puts "That did not go over well... I looked like a damn FOOL. That cutie has a partner who is super chill."
                puts "I'm out."
            end
            # puts "Your anxiety score is now #{@@login.anxiety_points += 20}."
            #do we build code to actually calculate the total diff in anxiety points from the beginning and add that difference back?
            #or do we save their score for the end of the game
        elsif selection == options[1]
            puts "Wow that was a ton of work but I feel great! Julia is such a great host and I am leaving feeling a huge sense of accomplishment."
            # @@login.anxiety_points -= 15
            # puts "My anxiety score is now: #{@@login.anxiety_points}/100"
            # sleep(2)
            #do we build code to actually calculate the total diff in anxiety points from the beginning and add that difference back?
            #or do we save their score for the end of the game
        end
        sleep(3)
        system('clear')

        if @@login.anxiety_points < @@character.anxiety_points
            puts "Stepping off Julia's stoop a delivery guy runs into #{@@character.name} with his bike while speeding to their next drop off."
            puts "#{@@character.name} is shook up and has hot food all over them"
        else
            puts "Stepping off Julia's stoop #{@@character.name} finds a $100 bill on the ground. #{@@character.name}s phone buzzes and it is a text message" 
            puts "from a close friend telling them how proud they are of #{@@character.name}"
        end
        sleep(2)
        puts ""
        puts "At the end of the day, anxiety comes from within, so..."
        puts "#{@@character.name}'s Anxiety Points are now back to #{@@character.anxiety_points}/100, same as when #{@@character.name} first left work."
        sleep(2)
        
        # clear screen here 
        # pause
        # mental health resource section
        puts "While anxiety has an internal origin, managing outside stress and making smart choices is a critical part of keeping yourself as healthy as possible."
        puts "If you've found yourself struggling with anxiety (especially during this stressful time)"
        puts "You can visit the page below for resources in your area."
        puts "http"
        return
    end




end #end of CLI class


