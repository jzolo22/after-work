require 'pry'


User.destroy_all
Character.destroy_all
Login_Session.destroy_all

james = User.create(username: "james", password: "1234")

caryn = Character.create(name: "Caryn", occupation: "teacher", dog_allergy: false, outgoing: true, alcohol_problem: false, num_drinks: 0, anxiety_points: 30, single: true)
# caryn = Character.create(name: "Caryn", occupation: "teacher", dog_allergy: false, outgoing: true, alcohol_problem: false, num_drinks: 0, anxiety_points: 30, single: true)

log_in1 = Login_Session.create(character_id: caryn.id, user_id: james.id, anxiety_points: caryn.anxiety_points, num_drinks: caryn.num_drinks)


characters = [
#     {
#         name: "caryn",
#         occupation: teacher,
#         dog_allergy: false,
#         outgoing: true,
#         alcohol_problem: true,
#         num_drinks: false,
#         anxiety points: 30,
#         single: true
#     },
#     {
#         name: "Mary",
#         occupation: "koenke@sas.upenn.edu",
#         dog_allergy: 34,
#         outgoing: false,
#         alcohol_problem: true,
#         num_drinks: "Mays Landing, NJ",
#         anxiety points: true,
#         single: "NYC"
#     },
#     {
#         name: "Demetrio",
#         email_address: "dlima@gmail.com",
#         age: 30,
#         outgoing: false,
#         alcohol_problem: false,
#         num_drinks: "Brooklyn, NY",
#         single: "NYC"
#     }
# ]

# Traveler.create(travelers)

##character##
# t.string :name
# t.string :occupation
# t.boolean :dog_allergy
# t.boolean :outgoing
# t.boolean :alcohol_problem
# t.integer :num_drinks
# t.integer :anxiety_points
# t.boolean :single

##login_session##
# t.integer :character_id
# t.integer :user_id
# t.integer :anxiety_points
# t.integer :num_drinks









binding.pry



# require 'rest-client' # let you actually make the requests to the URLs 
# require 'json'

# Category.destroy_all
# User.destroy_all
# Game.destroy_all

# # AI: Seed with 100 categories from the API 

# api_response = RestClient.get("http://jservice.io/api/categories?count=100")
# api_data = JSON.parse(api_response)

# api_data.each do |category|
#     Category.create(
#         title: category["title"],
#         api_id: category["id"],
#     )
# end

# # Category.create(api_data) WILL NOT WORK CAUSE EXTRA KEYS!!!

# User.create(username: "Caryn", password: "12345")
