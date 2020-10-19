class CreateCharacters < ActiveRecord::Migration[6.0]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :occupation
      t.boolean :dog_allergy
      t.boolean :outgoing 
      t.boolean :alcohol_problem
      t.integer :num_drinks 
      t.integer :anxiety_points
      t.boolean :single
    end
  end
end
