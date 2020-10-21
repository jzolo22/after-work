require 'pry'
class Login_Session < ActiveRecord::Base
    belongs_to :user
    belongs_to :character

    

    def anxiety_points=(num)
        if num.between?(0,100)
            self[:anxiety_points]= num
        elsif num > 100
            self[:anxiety_points] = 100
        elsif num < 0
            self[:anxiety_points] = 0
            # puts "You are so calm, even Buddha would be impressed!"
        end
    end

    # @@login.anxiety_points += 5

end