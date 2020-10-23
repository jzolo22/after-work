require 'pry'


User.destroy_all
Character.destroy_all
Login_Session.destroy_all

james = User.create(username: "james", password: "1234")

caryn = Character.create(name: "Caryn", occupation: "teacher", dog_allergy: true, outgoing: true, alcohol_problem: false, num_drinks: 2, anxiety_points: 30, single: true)
isabelle = Character.create(name: "Isabelle", occupation: "teacher", dog_allergy: false, outgoing: true, alcohol_problem: true, num_drinks: 0, anxiety_points: 65, single: true)
michelle = Character.create(name: "Michelle", occupation: "teacher", dog_allergy: false, outgoing: false, alcohol_problem: false, num_drinks: 1, anxiety_points: 55, single: true)
ian = Character.create(name: "Ian", occupation: "teacher", dog_allergy: true, outgoing: true, alcohol_problem: true, num_drinks: 0, anxiety_points: 40, single: true)


binding.pry

