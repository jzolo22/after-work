class Login_Session < ActiveRecord::Base
    belongs_to :user
    belongs_to :character

    # def anxiety_points=(anxiety_points)
    #     if anxiety_points.between?(0,100)
    #         @anxiety_points = anxiety_points
    #     elsif anxiety_points > 100
    #         @anxiety_points = 100
    #     else anxiety_points < 0
    #         @anxiety_points = 0
    #         puts "You are so calm, even Buddha would be impressed!"
    #     end
    # end

end