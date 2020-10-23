require "tty-prompt"

class User < ActiveRecord::Base
    has_many :login_sessions
    has_many :characters, through: :login_sessions

    @@prompt = TTY::Prompt.new

    def self.find_user
        username = @@prompt.ask("What is your username?")
        password = @@prompt.mask("What is your password?")
        self.find_by(username: username, password: password)
    end

    def self.create_user_login
        username = @@prompt.ask("Set a username:")
        password = @@prompt.mask("Select a password:")
        self.create(username: username, password: password)
    end

end