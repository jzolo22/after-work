class User < ActiveRecord::Base
    has_many :login_sessions
    has_many :characters, through: :login_sessions
end