class Character < ActiveRecord::Base
    has_many :login_sessions
    has_many :users, through: :login_sessions
end