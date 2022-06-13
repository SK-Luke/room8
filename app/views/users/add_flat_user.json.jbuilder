if @flat_user.persisted?
  json.form json.partial!("flats/form.html.erb", user: @roommate, flat: @flat)
  # json.inserted_item json.partial!("flats/add_flatmates.html.erb", flatuser: @flat_user)
  json.inserted_item json.partial!("flats/email_li.html.erb", user: @user)
else
  json.form json.partial!("flats/form.html.erb", user: @roommate, flat: @flat)
end