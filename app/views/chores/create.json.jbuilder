if @chore.persisted?
  json.form json.partial!("chores/newchore.html.erb", chore: Chore.new)
  json.inserted_item json.partial!("chores/chore.html.erb", chore: @chore)
else
  json.form json.partial!("chores/chore.html.erb", flat: @flat, chore: @chore)
end
