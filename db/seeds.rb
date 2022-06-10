chores_array = ["Sweep the floor", "Throw out the garbage", "Pay the rent", "Do the dishes", "Do the laundry"]
frequencies_array = ["daily", "weekly", "monthly"]
repetitions_array = [1, 2, 3]
durations_array = [30, 60, 90, 120]
seed_quotes = ['“Seeds never lose their potential, not even in dirt.”', '“A seed has a few friends, but a tree has many enemies.”', '“All memories carry the seeds of suffering.”', '“Show me your seed and I ll show you your harvest.”']

# DB wipeout
puts "Cleaning database..."
Users.destroy_all
Flat_users.destroy_all
Chores.destroy_all
Flats.destroy_all
Chore_lists.destroy_all
Month_lists.destroy_all
Preferences.destroy_all
puts "Database cleaned 👍"
puts "Starting to seed..."


#  ----
# User creation
puts "Creating users..."
user = User.new({
  name: "admin",
  email: "admin@gmail.com",
  password: "123123"
})
user.save!
3.times do
  user = User.new({
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: "123123"
  })
  user.save!
end
puts "Created 4 users"


# Flat creation (for now the creating one)
puts "creating 1 flat and linking users to the flat"
flat = Flat.new({
  name: "Room8",
  token: "abc123qeytc"
})
flat.save!

User.all.each do |user|
  flat_user = FlatUser.new
  flat_user.user = user
  flat_user.flat = flat
  flat_user.save!
end
puts "created flat and user"


# Chore creation
Flat.all.each do |flat|
  rand(4..8) do
    chore = Chore.new({
      name: chores_array.sample,
      frequency: frequencies_array.sample,
      repetition: repetitions_array.sample,
      duration: durations_array.sample
    })
    chore.flat = flat
    chore.save!
  end
end

# Creating a chore list
Flat.all.each do |flat|
  flat.chores.each do |chore|
    chore_list = Chore_list.new
    chore_list.chore = chore
    chore_list.deadline = Date.today+rand(100)
    chore_list.user = flat.users.sample
  end
end




puts "Lowfi seeds completed 👍"
puts "Now loading seed quote..."
sleep 2
puts seed_quotes.sample

# Month_lists
# Chore_lists
# Preferences

# create_table "preferences", force: :cascade do |t|
#   t.integer "rating"
#   t.bigint "user_id", null: false
#   t.bigint "chores_id", null: false
#   t.datetime "created_at", precision: 6, null: false
#   t.datetime "updated_at", precision: 6, null: false
#   t.index ["chores_id"], name: "index_preferences_on_chores_id"
#   t.index ["user_id"], name: "index_preferences_on_user_id"
# end

# create_table "chore_lists", force: :cascade do |t|
#   t.datetime "deadline"
#   t.boolean "complete", default: false
#   t.bigint "month_list_id", null: false
#   t.bigint "user_id", null: false
#   t.bigint "chores_id", null: false
#   t.datetime "created_at", precision: 6, null: false
#   t.datetime "updated_at", precision: 6, null: false
#   t.index ["chores_id"], name: "index_chore_lists_on_chores_id"
#   t.index ["month_list_id"], name: "index_chore_lists_on_month_list_id"
#   t.index ["user_id"], name: "index_chore_lists_on_user_id"
# end
