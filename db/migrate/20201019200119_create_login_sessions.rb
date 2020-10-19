class CreateLoginSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :login_sessions do |t|
      t.integer :character_id
      t.integer :user_id
      t.integer :anxiety_points
      t.integer :num_drinks
    end
  end
end
