chores_array = ["Sweep the floor", "Throw out the garbage", "Pay the rent", "Do the dishes", "Do the laundry"]
frequencies_array = ["daily", "weekly", "monthly"]
repetitions_array = [1, 2, 3]
durations_array = [30, 60, 90, 120]
seed_quotes = ['“Seeds never lose their potential, not even in dirt.”', '“A seed has a few friends, but a tree has many enemies.”', '“All memories carry the seeds of suffering.”', '“Show me your seed and I ll show you your harvest.”']

# DB wipeout
puts "Cleaning database..."
FlatUser.destroy_all
User.destroy_all
Chore.destroy_all
Flat.destroy_all
ChoreList.destroy_all
MonthList.destroy_all
Preference.destroy_all
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
puts "Creating a flat..."
flat = Flat.new({
  name: "Room8",
  token: "abc123qeytc"
})
flat.save!

User.all.each do |user|
  flat_user = FlatUser.new
  flat_user.user = user
  flat_user.flat = flat
  flat_user.active = true
  flat_user.save!
end
puts "Created 'Room8' flat and gave it users."


# Chore creation
puts "Creating chores..."
Flat.all.each do |flat|
  8.times do
    chore = Chore.new({
      name: chores_array.sample,
      frequency: frequencies_array.sample,
      repetition: repetitions_array.sample,
      duration: durations_array.sample
    })
    chore.flat = flat
    chore.save!

    month_list = MonthList.create(month: Date.today)

    chore_list = ChoreList.new
    chore_list.chore = chore
    chore_list.deadline = Date.today+rand(3)
    chore_list.user = flat.users.sample
    chore_list.month_list_id = month_list.id
    chore_list.save!
  end
end
puts "Created 8 chores for 'Room8' flat, and assigned them to random user."


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
