if @chore.persisted?
  json.form json.partial!("chores/editchore.html.erb", chore: @chore)
  json.updated_item json.partial!("chores/chore.html.erb", chore: @chore)
else
  json.form json.partial!("chores/chore.html.erb", flat: @flat, chore: @chore)
end
