# Seeds (minimum)
# Pre-set chores list
# 1 user
# 1 flat

puts "Cleaning database"
# Call destroy method

puts "Creating seeds..."
user = User.new({
  name: "Alex"
  email: "alex@gmail.com"
})
