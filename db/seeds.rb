
chores_array = ["Sweep the floor", "Throw out the garbage", "Do the dishes", "Clean the toilets", "Clean the kitchen", "Buy some beers", "Cook dinner", "Clean the windows", "Water the plants", "Clean the table", "Wash the curtains", "Wash the car", "Defrost the fridge"]

frequencies_array = ["daily", "weekly", "monthly"]
repetitions_array = [1, 2, 3]
durations_array = [15, 30, 60, 90, 120]
seed_quotes = ['“Cause and effect, means and ends, seed and fruit, cannot be severed; for the effect already blooms in the cause, the end preexists in the means, the fruit in the seed.”']

# DB wipeout
puts "_______"
puts "Cleaning up database..."
MonthList.destroy_all
Preference.destroy_all
ChoreList.destroy_all
Chore.destroy_all
FlatUser.destroy_all
Flat.destroy_all
User.destroy_all
puts "✨ Database cleaned"
puts "Starting to seed..."
puts "_______"


#  ----
# User creation
puts "Creating users..."
user1 = User.new({
  name: "Wan Xin",
  email: "wanxinpua@yahoo.com.sg",
  password: "123123"
})
user1.photo.attach(io: URI.open("http://res.cloudinary.com/dlqa2wzkk/image/upload/v1655099375/gvurxm0tgbbmyvldmusw.jpg"), filename: 'wx.jpg', content_type: 'image/jpg')
user1.save!

user2 = User.new({
  name: "Sek Kun",
  email: "sk@gmail.com",
  password: "123123"
})
user2.save!
user2.photo.attach(io: URI.open("http://res.cloudinary.com/dlqa2wzkk/image/upload/v1655099355/e81wixyxy3nw3prd7aw8.jpg"), filename: 'sk.jpg', content_type: 'image/jpg')

user3 = User.new({
  name: "Kenny",
  email: "kiansengnp@gmail.com",
  password: "123123"
})
user3.save!
user3.photo.attach(io: URI.open("http://res.cloudinary.com/dlqa2wzkk/image/upload/v1655099341/odhoptuks79qb73pqqb8.jpg"), filename: 'kenny.jpg', content_type: 'image/jpg')

user4 = User.new({
  name: "Victor",
  email: "victor.duverne@gmail.com",
  password: "123123"
})
user4.save!
user4.photo.attach(io: URI.open("http://res.cloudinary.com/dlqa2wzkk/image/upload/v1655099362/bajbf8wf3hjqipxtkw4v.jpg"), filename: 'vic.jpg', content_type: 'image/jpg')

# puts "done first part"

user5 = User.new({
  name: "Sek Kun",
  email: "sekkun.luke@gmail.com",
  password: "123123"
})
user5.save!
user6 = User.new({
  name: "Victor",
  email: "victor@gmail.com",
  password: "123123"
})
user6.save!

signed_in_users = [user1, user2, user3, user4]

puts "👤 Created 6 users"

# Flat creation (for now the creating one)
puts "Creating a flat..."
flat = Flat.new({
  name: "Big Fish Pond",
  token: "abc123qeytc"
})
flat.save!

signed_in_users.each do |user|
  flat_user = FlatUser.new
  flat_user.user = user
  flat_user.flat = flat
  flat_user.active = true
  flat_user.save!
end
puts "🏠 Created 'Big Fish Pond' flat and gave it 4 flatmates"


# Chore creation
puts "Creating chores..."
Flat.all.each do |flat|
  chores_array.each do |chore_name|
    chore = Chore.new({
      name: chore_name,
      frequency: frequencies_array.sample,
      repetition: repetitions_array.sample,
      duration: durations_array.sample
    })
    chore.flat = flat
    chore.save!

    month_list = MonthList.create(month: Date.today)

    chore_list = ChoreList.new
    chore_list.chore = chore
    chore_list.deadline = Date.today+rand(-10..10)
    # chore_list.deadline = Date.today+rand(-3..3)
    chore_list.user = flat.users.sample
    chore_list.month_list_id = month_list.id
    chore_list.complete = [true, false].sample
    # chore_list.complete = [true, false].sample
    chore_list.save!
  end
end
puts "🧹 Created #{chores_array.count} chores for 'Big Fish Pond' flat, and assigned them to random users"

# Creating 3 more chores for my man Sek Kun

skchore1 = Chore.new({
  name: "Mop the floor",
  frequency: "weekly",
  repetition: 1,
  duration: 60
})
skchore1.flat = flat
skchore1.save!

month_list = MonthList.create(month: Date.today)

chore_list = ChoreList.new
chore_list.chore = skchore1
chore_list.deadline = Date.today+1
chore_list.user = user2
chore_list.month_list_id = month_list.id
chore_list.complete = false
chore_list.save!

skchore2 = Chore.new({
  name: "Do the laundry",
  frequency: "weekly",
  repetition: 2,
  duration: 30
})
skchore2.flat = flat
skchore2.save!

month_list = MonthList.create(month: Date.today)

chore_list = ChoreList.new
chore_list.chore = skchore2
chore_list.deadline = Date.today+1
chore_list.user = user2
chore_list.month_list_id = month_list.id
chore_list.complete = false
chore_list.save!

skchore3 = Chore.new({
  name: "Pay the rent",
  frequency: "monthly",
  repetition: 1,
  duration: 15
})
skchore3.flat = flat
skchore3.save!

month_list = MonthList.create(month: Date.today)

chore_list = ChoreList.new
chore_list.chore = skchore3
chore_list.deadline = Date.today-1
chore_list.user = user2
chore_list.month_list_id = month_list.id
chore_list.complete = false
# chore_list.complete = [true, false].sample
chore_list.save!


# Preference creation
puts "Creating preferences..."
Flat.all.each do |flat|
  flat.users.each do |user|
    flat.chores.each do |chore|
      preference = Preference.new
      preference.rating = rand(1..3)
      preference.user = user
      preference.chore = chore
      preference.save!
    end
  end
end
puts "❤️ Created preferences for each user"
puts "_______"


puts "🌱 Hifi seeds completed"
puts "Now loading seed quote..."
sleep 2
puts seed_quotes.sample
