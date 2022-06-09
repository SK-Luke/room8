# Seeds (minimum)
# Pre-set chores list
# 1 user
# 1 flat

puts "Cleaning database"
# Call destroy method

puts "Creating users..."
user = User.new({
  name: "Alex"
  email: "alex@gmail.com"
})
user.save
puts "user created"

puts "creating flats and link user to flat"
flat = Flat.new({
  name: "room8"
  token: "abc123qeytc"
})
flat.save

flat_user = FlatUser.new
flat_user.user = user
flat_user.flat = flat
flat_user.save
puts "created flat and user"


puts "creating chores"
sweep = Chores.new({
  name: "Sweep da floor"
  frequency: "Daily"
  repetition: 1
  duration: 30 # To convert 30 to 30mins
})
sweep.flat = flat
sweep.save

laundry = Chores.new({
  name: "Do them laundry"
  frequency: "week"
  repetition: 1
  duration: 120 # To convert 120 to 120mins
})
laundry.flat = flat
laundry.save
