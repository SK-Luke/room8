# if @flat.persisted?
#   json.form json.partial!("flats/form.html.erb", user: @roommate, flat: @flat)
#   json.inserted_item json.partial!("flats/add_flatmates.html.erb", flatuser: @flat_user)
# else
#   json.form json.partial!("flats/form.html.erb", restaurant: @restaurant)
# end